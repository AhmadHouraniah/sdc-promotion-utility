#!/usr/bin/env python3
import argparse
import re
from collections import OrderedDict

def parse_verilog_ports(rtl_file):
    """Extract inputs/outputs/inouts with widths from a Verilog file."""
    ports = {}
    with open(rtl_file) as f:
        for line in f:
            # Handle input/output/inout with optional reg keyword
            m = re.match(r'\s*(input|output|inout)\s*(?:reg\s*)?(\[[^\]]+\])?\s*(\w+)', line)
            if m:
                direction, width, name = m.groups()
                if width:
                    # width is like [31:0] or [7:0]
                    numbers = re.findall(r'\d+', width)
                    if len(numbers) >= 2:
                        msb, lsb = int(numbers[0]), int(numbers[1])
                        ports[name] = {'dir': direction, 'width': msb - lsb + 1, 'lsb': lsb}
                    else:
                        # Single number like [7] means [7:0]
                        msb = int(numbers[0])
                        ports[name] = {'dir': direction, 'width': msb + 1, 'lsb': 0}
                else:
                    ports[name] = {'dir': direction, 'width': 1, 'lsb': 0}
    return ports

def parse_connection_map(target_rtl, instance_name):
    """
    Build a mapping from source module ports to top-level signals.
    Assumes simple named-port instantiation:
    ip U1 (.din(ip_din_test), ...);
    """
    mapping = {}
    with open(target_rtl) as f:
        data = f.read()
        inst_re = re.compile(r'\b' + re.escape(instance_name) + r'\b\s*\(.*?\);', re.S)
        m = inst_re.search(data)
        if not m:
            raise RuntimeError(f"Instance {instance_name} not found in {target_rtl}")
        inst_text = m.group(0)
        connections = re.findall(r'\.(\w+)\s*\(\s*([\w\[\]:]+)\s*\)', inst_text)
        for port, sig in connections:
            mapping[port] = sig
    return mapping

def expand_vector_signals(mapping, source_ports):
    """Expand vector signals to bit-level mapping."""
    bit_map = {}
    for port, target_sig in mapping.items():
        info = source_ports[port]
        if info['width'] == 1:
            bit_map[port] = target_sig
        else:
            for i in range(info['width']):
                src_bit = f"{port}[{i}]"
                tgt_bit = f"{target_sig}[{i}]"
                bit_map[src_bit] = tgt_bit
    return bit_map

def analyze_signal_connectivity(target_rtl):
    """
    Analyze signal connectivity to determine which internal signals
    connect to top-level inputs/outputs through wires or nets.
    Returns a set of signals that are connected to top-level I/O.
    """
    connected_signals = set()
    top_level_ports = set()
    
    with open(target_rtl) as f:
        content = f.read()
        
        # Extract top-level ports
        port_matches = re.findall(r'(input|output|inout)\s*(?:reg\s*)?(?:\[[^\]]+\])?\s*(\w+)', content)
        for _, port in port_matches:
            top_level_ports.add(port)
            connected_signals.add(port)
        
        # Find wire declarations and their connectivity
        wire_matches = re.findall(r'wire\s*(?:\[[^\]]+\])?\s*(\w+)', content)
        wires = {match for match in wire_matches}
        
        # Find assign statements that connect signals
        assign_matches = re.findall(r'assign\s+(\w+(?:\[[^\]]*\])?)\s*=\s*([^;]+)', content)
        for lhs, rhs in assign_matches:
            # Extract signal names from both sides
            lhs_sig = re.sub(r'\[[^\]]*\]', '', lhs)
            rhs_signals = re.findall(r'\b(\w+)', rhs)
            
            # If LHS is connected to top-level, mark all RHS signals as connected
            if lhs_sig in connected_signals:
                connected_signals.update(rhs_signals)
            # If any RHS is connected to top-level, mark LHS as connected
            elif any(sig in connected_signals for sig in rhs_signals):
                connected_signals.add(lhs_sig)
        
        # Find instance connections that bridge signals
        inst_pattern = r'(\w+)\s+(\w+)\s*\(([^)]+)\)'
        instances = re.findall(inst_pattern, content, re.DOTALL)
        
        for module_name, inst_name, connections in instances:
            conn_matches = re.findall(r'\.(\w+)\s*\(\s*([\w\[\]:]+)\s*\)', connections)
            for port, signal in conn_matches:
                signal_base = re.sub(r'\[[^\]]*\]', '', signal)
                # If signal connects to a top-level port, mark it as connected
                if signal_base in connected_signals:
                    connected_signals.add(signal_base)
    
    return connected_signals

def parse_sdc(sdc_file):
    """Read SDC file line by line."""
    with open(sdc_file) as f:
        lines = f.readlines()
    return lines

def promote_sdc_lines(lines, bit_map, connected_signals, instance_name):
    """
    Promote SDC by replacing source signals with target signals.
    Only promote input/output delays for signals connected to top-level I/O.
    Returns tuple of (promoted_lines, ignored_lines).
    """
    promoted_lines = []
    ignored_lines = []
    
    # Create a reverse mapping from source base names to target base names
    base_name_map = {}
    for src, tgt in bit_map.items():
        src_base = re.sub(r'\[\d+\]$', '', src)
        tgt_base = re.sub(r'\[\d+\]$', '', tgt)
        if src_base != tgt_base and src_base not in base_name_map:
            base_name_map[src_base] = tgt_base
    
    for line in lines:
        original_line = line
        should_promote = True
        
        # Check if this is an input/output delay constraint
        if 'set_input_delay' in line or 'set_output_delay' in line:
            # Extract the target signal from the constraint
            port_match = re.search(r'\[get_ports\s+([^\]]+)\]', line)
            if port_match:
                ports_str = port_match.group(1)
                ports = re.findall(r'[\w\[\]:]+', ports_str)
                
                # Check if any of the ports are connected to top-level I/O
                connected_to_io = False
                for port in ports:
                    port_base = re.sub(r'\[[^\]]*\]', '', port)
                    # Check both original port name and mapped name
                    target_signal = base_name_map.get(port_base, port_base)
                    if port_base in connected_signals or target_signal in connected_signals:
                        connected_to_io = True
                        break
                
                if not connected_to_io:
                    should_promote = False
                    ignored_lines.append(f"# IGNORED (not connected to top I/O): {original_line}")
                    continue
        
        if should_promote:
            promoted_line = line
            
            # Handle wildcards and individual signals as before
            has_wildcards = '[*]' in promoted_line
            
            if has_wildcards:
                for src_base, tgt_base in base_name_map.items():
                    wildcard_pattern1 = f'{{{re.escape(src_base)}\\[\\*\\]}}'
                    wildcard_replacement1 = f'{{{tgt_base}[*]}}'
                    promoted_line = re.sub(wildcard_pattern1, wildcard_replacement1, promoted_line)
                    
                    wildcard_pattern2 = f'\\b{re.escape(src_base)}\\[\\*\\]'
                    wildcard_replacement2 = f'{tgt_base}[*]'
                    promoted_line = re.sub(wildcard_pattern2, wildcard_replacement2, promoted_line)
            else:
                for src, tgt in bit_map.items():
                    pattern = r'\b' + re.escape(src) + r'\b'
                    promoted_line = re.sub(pattern, tgt, promoted_line)
            
            promoted_lines.append(promoted_line)
        else:
            ignored_lines.append(original_line)
    
    return promoted_lines, ignored_lines

def parse_sdc_command(line):
    """Parse an SDC command to extract command type and target signals."""
    line = line.strip()
    if not line or line.startswith('#'):
        return None, None, line
    
    # Extract command type (first word)
    cmd_match = re.match(r'(\w+)', line)
    if not cmd_match:
        return None, None, line
    
    cmd_type = cmd_match.group(1)
    
    # For delay constraints, include -max/-min in the command type
    if cmd_type in ['set_input_delay', 'set_output_delay']:
        if '-max' in line:
            cmd_type += '_max'
        elif '-min' in line:
            cmd_type += '_min'
    
    # Extract target signals from get_ports, get_pins, get_nets, etc.
    targets = []
    
    # Handle get_ports [list of ports]
    port_patterns = re.findall(r'\[get_ports\s+([^\]]+)\]', line)
    for pattern in port_patterns:
        # Remove quotes and split on whitespace to handle multiple ports
        ports = re.findall(r'[\w\[\]:]+', pattern)
        targets.extend(ports)
    
    # Handle get_pins [list of pins]  
    pin_patterns = re.findall(r'\[get_pins\s+([^\]]+)\]', line)
    for pattern in pin_patterns:
        pins = re.findall(r'[\w\[\]:/.]+', pattern)
        targets.extend(pins)
    
    # Handle get_nets [list of nets]
    net_patterns = re.findall(r'\[get_nets\s+([^\]]+)\]', line)
    for pattern in net_patterns:
        nets = re.findall(r'[\w\[\]:/.]+', pattern)
        targets.extend(nets)
    
    # For clock creation, also consider the clock name
    if cmd_type == 'create_clock':
        clock_name_match = re.search(r'-name\s+(\w+)', line)
        if clock_name_match:
            targets.append(f"clock:{clock_name_match.group(1)}")
    
    return cmd_type, targets, line

def merge_with_initial_sdc(initial_sdc_lines, promoted_lines):
    """
    Merge initial SDC constraints with promoted ones.
    Initial SDC takes precedence for conflicting constraints.
    """
    if not initial_sdc_lines:
        return promoted_lines
    
    # Parse both sets of constraints
    initial_constraints = {}
    promoted_constraints = {}
    
    # Process initial SDC first (higher priority)
    for line in initial_sdc_lines:
        cmd_type, targets, clean_line = parse_sdc_command(line)
        if cmd_type and targets:
            for target in targets:
                key = f"{cmd_type}::{target}"
                initial_constraints[key] = line
    
    # Process promoted SDC
    for line in promoted_lines:
        cmd_type, targets, clean_line = parse_sdc_command(line)
        if cmd_type and targets:
            for target in targets:
                key = f"{cmd_type}::{target}"
                if key not in initial_constraints:  # Only add if not in initial
                    promoted_constraints[key] = line
    
    # Combine: initial SDC first, then non-conflicting promoted constraints
    result = list(initial_sdc_lines)
    
    # Add promoted constraints that don't conflict
    added_promoted = set()
    for line in promoted_lines:
        cmd_type, targets, clean_line = parse_sdc_command(line)
        if cmd_type and targets:
            conflict = False
            for target in targets:
                key = f"{cmd_type}::{target}"
                if key in initial_constraints:
                    conflict = True
                    break
            if not conflict and line not in added_promoted:
                result.append(line)
                added_promoted.add(line)
        else:
            # Non-constraint lines (comments, etc.) - add them
            if line not in added_promoted:
                result.append(line)
                added_promoted.add(line)
    
    return result

def remove_duplicates(lines):
    """Remove duplicate and conflicting SDC lines while preserving order."""
    seen_exact = OrderedDict()  # For exact duplicates
    command_targets = OrderedDict()  # For conflicting constraints
    result = []
    
    for line in lines:
        original_line = line
        cmd_type, targets, clean_line = parse_sdc_command(line)
        
        if not clean_line.strip():
            continue
            
        # Check for exact duplicates first
        if clean_line in seen_exact:
            continue
        seen_exact[clean_line] = True
        
        # If we can't parse the command or it has no targets, just add it
        if not cmd_type or not targets:
            result.append(original_line)
            continue
        
        # For commands that can conflict, check against previous commands
        if cmd_type in ['set_input_delay_max', 'set_input_delay_min', 'set_output_delay_max', 'set_output_delay_min', 
                       'set_max_transition', 'set_max_delay', 'set_min_delay', 'create_clock']:
            
            # Create a key that identifies the command type and its targets
            for target in targets:
                key = f"{cmd_type}::{target}"
                
                # For create_clock, we want to avoid duplicates completely
                if cmd_type == 'create_clock':
                    if key not in command_targets:
                        command_targets[key] = len(result)
                        result.append(original_line)
                    # Skip duplicate clock creation
                    break
                else:
                    # For other commands, keep the latest constraint (overwrite)
                    if key in command_targets:
                        # Replace the previous command
                        old_index = command_targets[key]
                        result[old_index] = None  # Mark for removal
                    
                    command_targets[key] = len(result)
                    result.append(original_line)
        else:
            # For other commands (false_path, multicycle_path, etc.), just add them
            result.append(original_line)
    
    # Remove None entries (overwritten commands)
    result = [line for line in result if line is not None]
    
    return result

def main():
    parser = argparse.ArgumentParser(description="Promote multiple SDCs to top-level with enhanced features")
    parser.add_argument("--source_rtl", nargs='+', required=True, help="List of source RTLs")
    parser.add_argument("--source_sdc", nargs='+', required=True, help="List of source SDCs")
    parser.add_argument("--target_rtl", required=True, help="Top-level RTL")
    parser.add_argument("--target_sdc", required=True, help="Output promoted SDC")
    parser.add_argument("--instance", nargs='+', required=True, help="List of instance names corresponding to each source RTL/SDC")
    parser.add_argument("--initial_sdc", help="Optional initial SDC file to merge with promoted constraints")
    parser.add_argument("--ignored_dir", default=".", help="Directory to store ignored constraint files")
    args = parser.parse_args()

    if not (len(args.source_rtl) == len(args.source_sdc) == len(args.instance)):
        raise RuntimeError("Number of source RTLs, SDCs, and instances must match")

    # Analyze signal connectivity in target RTL
    print("Analyzing signal connectivity...")
    connected_signals = analyze_signal_connectivity(args.target_rtl)
    print(f"Found {len(connected_signals)} signals connected to top-level I/O")

    # Load initial SDC if provided
    initial_sdc_lines = []
    if args.initial_sdc:
        print(f"Loading initial SDC from {args.initial_sdc}")
        initial_sdc_lines = parse_sdc(args.initial_sdc)

    all_promoted_lines = []
    
    # Process each IP separately
    for i, (rtl, sdc, inst) in enumerate(zip(args.source_rtl, args.source_sdc, args.instance)):
        print(f"Processing {inst} ({rtl}, {sdc})")
        
        source_ports = parse_verilog_ports(rtl)
        mapping = parse_connection_map(args.target_rtl, inst)
        bit_map = expand_vector_signals(mapping, source_ports)
        sdc_lines = parse_sdc(sdc)
        
        # Promote with connectivity checking
        promoted_lines, ignored_lines = promote_sdc_lines(sdc_lines, bit_map, connected_signals, inst)
        all_promoted_lines.extend(promoted_lines)
        
        # Write ignored constraints to separate file
        if ignored_lines:
            ignored_file = f"{args.ignored_dir}/{inst}_ignored_constraints.sdc"
            with open(ignored_file, 'w') as f:
                f.write(f"# Ignored constraints for instance {inst}\n")
                f.write(f"# These constraints were not promoted because signals are not connected to top-level I/O\n")
                f.write(f"# Source: {sdc}\n\n")
                f.writelines(ignored_lines)
            print(f"  -> {len(ignored_lines)} ignored constraints written to {ignored_file}")
        
        print(f"  -> {len(promoted_lines)} constraints promoted, {len(ignored_lines)} ignored")

    # Merge with initial SDC if provided
    if initial_sdc_lines:
        print("Merging with initial SDC...")
        final_lines = merge_with_initial_sdc(initial_sdc_lines, all_promoted_lines)
    else:
        final_lines = all_promoted_lines

    # Remove duplicates across all promoted SDC lines
    final_lines = remove_duplicates(final_lines)

    with open(args.target_sdc, 'w') as f:
        f.writelines(final_lines)

    print(f"Final promoted SDC with {len(final_lines)} constraints written to {args.target_sdc}")

if __name__ == "__main__":
    main()