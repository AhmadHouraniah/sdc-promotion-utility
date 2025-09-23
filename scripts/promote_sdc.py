#!/usr/bin/env python3
"""
SDC Promotion Utility - Enhanced Version

A comprehensive tool for promoting SDC constraints from IP-level to top-level designs.
Supports Design Compiler generated netlists with escaped identifiers, multi-instance
hierarchies, and advanced constraint processing.

Author: Ahmad Houraniah
Version: 2.0
"""

import argparse
import logging
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Set, Optional
from collections import OrderedDict


def escape_replacement(replacement: str) -> str:
    """
    Escape backslashes in replacement strings for regex substitution.
    
    In Python regex replacement strings, backslashes have special meaning
    (e.g., \\1 for group references). For literal backslashes in signal names
    like escaped identifiers (\\signal_name), we need to escape them.
    """
    return replacement.replace('\\', r'\\')


def setup_logging(debug: bool = False, verbose: bool = False) -> logging.Logger:
    """Setup logging configuration with different levels for debug, verbose, and normal modes."""
    if debug:
        level = logging.DEBUG
        format_str = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    elif verbose:
        level = logging.INFO
        format_str = '%(levelname)s: %(message)s'
    else:
        level = logging.WARNING
        format_str = '%(message)s'
    
    logging.basicConfig(
        level=level,
        format=format_str,
        handlers=[logging.StreamHandler(sys.stdout)]
    )
    
    return logging.getLogger(__name__)

def parse_verilog_ports(rtl_file):
    """Extract inputs/outputs/inouts with widths from a Verilog file."""
    ports = {}
    with open(rtl_file) as f:
        content = f.read()
        
        # Parse individual port declarations to get direction/width
        for line in content.split('\n'):
            # Match input/output line with potential multiple ports, including escaped identifiers
            m = re.match(r'\s*(input|output|inout)\s*(?:wire\s*)?(?:reg\s*)?(\[[^\]]+\])?\s*(.*)', line)
            if m:
                direction, width, port_list = m.groups()
                # Split by comma to get all port names, being careful with escaped identifiers
                port_entries = []
                current_entry = ""
                in_escaped = False
                
                for char in port_list + ',':  # Add comma to process last entry
                    if char == '\\' and not in_escaped:
                        in_escaped = True
                        current_entry += char
                    elif char == ' ' and in_escaped:
                        in_escaped = False
                        current_entry += char
                    elif char == ',' and not in_escaped:
                        if current_entry.strip():
                            port_entries.append(current_entry.strip())
                        current_entry = ""
                    else:
                        current_entry += char
                
                for name in port_entries:
                    name = name.strip()
                    # Remove semicolon and any trailing comments
                    name = re.sub(r'[;\s]*(?://.*)?$', '', name)
                    
                    if name and name not in ['wire', 'reg']:
                        if width:
                            numbers = re.findall(r'\d+', width)
                            if len(numbers) >= 2:
                                msb, lsb = int(numbers[0]), int(numbers[1])
                                ports[name] = {'dir': direction, 'width': msb - lsb + 1, 'lsb': lsb}
                            else:
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
        
        for line in inst_text.split('\n'):
            if '.' in line and '(' in line and ')' in line:
                try:
                    # Handle escaped port names like .\escaped_port/name (signal)
                    line_clean = line.strip()
                    
                    # Extract port name - may be escaped
                    port_match = re.search(r'\.(\\\S+|\w+)\s*\(', line_clean)
                    if port_match:
                        port = port_match.group(1)
                        
                        # Extract signal name
                        sig_match = re.search(r'\(([^)]+)\)', line_clean)
                        if sig_match:
                            sig = sig_match.group(1).strip().split(',')[0].split('//')[0].strip()
                            if port and sig:
                                mapping[port] = sig
                except:
                    continue
        
    return mapping

def expand_vector_signals(mapping, source_ports):
    """Expand vector signals to bit-level mapping."""
    bit_map = {}
    print(f"DEBUG: Source ports found: {list(source_ports.keys())}")
    for port, target_sig in mapping.items():
        if port not in source_ports:
            print(f"WARNING: Port '{port}' not found in source_ports")
            continue
        print(f"Mapping: {port} -> {target_sig}")
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

def format_constraint_line(line):
    """
    Format a constraint line with proper indentation and line breaks for readability.
    Avoids extremely wide lines by breaking at logical points.
    """
    line = line.strip()
    if not line or line.startswith('#'):
        return line + '\n'
    
    # Define maximum line length before breaking
    MAX_LINE_LENGTH = 120
    
    if len(line) <= MAX_LINE_LENGTH:
        return line + '\n'
    
    # For multi-argument constraints, try to break intelligently
    formatted_line = ""
    
    # Check if this is a constraint with -from/-to/-through arguments
    if any(arg in line for arg in ['-from', '-to', '-through']):
        # Break into logical sections
        sections = []
        current_section = ""
        
        # Split by constraint arguments but keep the argument with its content
        parts = re.split(r'(\s+-(?:from|to|through|setup|hold|max|min|clock)\s+)', line)
        
        for i, part in enumerate(parts):
            if i == 0:  # First part (constraint name)
                current_section = part
            elif part.strip().startswith('-'):  # Argument flag
                if current_section:
                    sections.append(current_section)
                current_section = "    " + part.strip()  # Indent arguments
            else:  # Argument value
                current_section += part
        
        if current_section:
            sections.append(current_section)
        
        # Join sections with line continuations
        if len(sections) > 1:
            formatted_line = sections[0] + " \\\n"
            for section in sections[1:-1]:
                formatted_line += section + " \\\n"
            formatted_line += sections[-1] + "\n"
        else:
            formatted_line = line + "\n"
    
    # For constraints with long get_ports/get_pins lists, try to break at logical points
    elif any(cmd in line for cmd in ['get_ports', 'get_pins', 'get_nets', 'get_clocks']):
        # Look for curly brace content that's very long
        brace_match = re.search(r'\{([^}]+)\}', line)
        if brace_match and len(brace_match.group(0)) > 80:
            content = brace_match.group(1)
            signals = [s.strip() for s in content.split() if s.strip()]
            
            if len(signals) > 3:  # Only break if more than 3 signals
                # Group signals by 3-4 per line
                signal_groups = []
                for i in range(0, len(signals), 4):
                    signal_groups.append(' '.join(signals[i:i+4]))
                
                # Find the position of the opening brace
                before_brace = line[:line.find('{')]
                after_brace = line[line.find('}') + 1:]
                
                formatted_line = before_brace + "{ \\\n"
                for i, group in enumerate(signal_groups):
                    if i == len(signal_groups) - 1:  # Last group
                        formatted_line += "        " + group + " \\\n"
                        formatted_line += "    }" + after_brace + "\n"
                    else:
                        formatted_line += "        " + group + " \\\n"
            else:
                formatted_line = line + "\n"
        else:
            formatted_line = line + "\n"
    
    else:
        # For other long lines, try simple breaking at logical points
        if len(line) > MAX_LINE_LENGTH:
            # Try to break at spaces near logical points
            if ' -' in line:
                parts = line.split(' -')
                formatted_line = parts[0] + " \\\n"
                for part in parts[1:]:
                    formatted_line += "    -" + part + " \\\n"
                formatted_line = formatted_line.rstrip(' \\\n') + "\n"
            else:
                formatted_line = line + "\n"
        else:
            formatted_line = line + "\n"
    
    return formatted_line

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
        
        # Skip comments and empty lines
        if line.strip().startswith('#') or not line.strip():
            promoted_lines.append(format_constraint_line(line))
            continue
        
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
                
                # Also do the normal signal replacement for wildcard lines
                # First try port mappings
                for src, tgt in bit_map.items():
                    pattern = r'\b' + re.escape(src) + r'\b'
                    promoted_line = re.sub(pattern, escape_replacement(tgt), promoted_line)
                
                # Handle get_ports/get_pins/get_nets with braces  
                # First handle individual signals in braces
                for src, tgt in bit_map.items():
                    # Replace {signal} patterns
                    promoted_line = re.sub(r'\{' + re.escape(src) + r'\}', f'{{{escape_replacement(tgt)}}}', promoted_line)
                    # Replace signal inside get_ports/get_pins/get_nets
                    promoted_line = re.sub(r'(get_ports|get_pins|get_nets)\s+' + re.escape(src) + r'\b', f'\\1 {escape_replacement(tgt)}', promoted_line)
                
                # Then handle signals within braces (including space-separated lists)
                def replace_in_braces_wildcard(match):
                    content = match.group(1)
                    original_content = content
                    for src, tgt in bit_map.items():
                        # For indexed signals, use a more specific pattern that handles brackets
                        if '[' in src:
                            # For indexed signals like data_bus[0], use exact match
                            pattern = re.escape(src)
                        else:
                            # For simple signals, use word boundaries
                            pattern = r'\b' + re.escape(src) + r'\b'
                        
                        if re.search(pattern, content):
                            content = re.sub(pattern, escape_replacement(tgt), content)
                    return '{' + content + '}'
                
                original_promoted_line = promoted_line
                promoted_line = re.sub(r'\{([^}]+)\}', replace_in_braces_wildcard, promoted_line)
            else:
                # First try port mappings
                for src, tgt in bit_map.items():
                    pattern = r'\b' + re.escape(src) + r'\b'
                    promoted_line = re.sub(pattern, escape_replacement(tgt), promoted_line)
                
                # Handle get_ports/get_pins/get_nets with braces  
                # First handle individual signals in braces
                for src, tgt in bit_map.items():
                    # Replace {signal} patterns
                    promoted_line = re.sub(r'\{' + re.escape(src) + r'\}', f'{{{escape_replacement(tgt)}}}', promoted_line)
                    # Replace signal inside get_ports/get_pins/get_nets
                    promoted_line = re.sub(r'(get_ports|get_pins|get_nets)\s+' + re.escape(src) + r'\b', f'\\1 {escape_replacement(tgt)}', promoted_line)
                
                # Then handle signals within braces (including space-separated lists)
                def replace_in_braces(match):
                    content = match.group(1)
                    original_content = content
                    for src, tgt in bit_map.items():
                        # For indexed signals, use a more specific pattern that handles brackets
                        if '[' in src:
                            # For indexed signals like data_bus[0], use exact match
                            pattern = re.escape(src)
                        else:
                            # For simple signals, use word boundaries
                            pattern = r'\b' + re.escape(src) + r'\b'
                        
                        if re.search(pattern, content):
                            content = re.sub(pattern, escape_replacement(tgt), content)
                    return '{' + content + '}'
                
                original_promoted_line = promoted_line
                promoted_line = re.sub(r'\{([^}]+)\}', replace_in_braces, promoted_line)
                
                # Handle indexed signals like {some_signal[2]}
                base_name_map = {}
                for src, tgt in bit_map.items():
                    src_base = re.sub(r'\[\d+\]$', '', src)
                    tgt_base = re.sub(r'\[\d+\]$', '', tgt)
                    if src_base != tgt_base:
                        base_name_map[src_base] = tgt_base
                
                for src_base, tgt_base in base_name_map.items():
                    # Replace {signal[n]} patterns
                    promoted_line = re.sub(r'\{' + re.escape(src_base) + r'(\[\d+\])\}', f'{{{escape_replacement(tgt_base)}\\1}}', promoted_line)
                    # Replace wildcard patterns like data_* where data_* should match data_bus
                    wildcard_pattern = re.escape(src_base).replace(r'\_', r'[^_]*') + r'\*'
                    promoted_line = re.sub(wildcard_pattern, f'{escape_replacement(tgt_base)}*', promoted_line)
                
                # Handle simple wildcards like data_* -> data_bus
                for src_base, tgt_base in base_name_map.items():
                    if src_base.startswith('data'):
                        promoted_line = re.sub(r'\bdata_\*', f'{escape_replacement(tgt_base)}*', promoted_line)
                
                # Then add instance prefix to internal paths
                promoted_line = re.sub(r'\b([a-zA-Z]\w*/)', f'{instance_name}/\\1', promoted_line)
                # Handle wildcards that start with */ -> instance_name/*/
                promoted_line = re.sub(r'\*/', f'{instance_name}/*/', promoted_line)
            
            # Debug: Check if line was actually modified
            if promoted_line.strip() == original_line.strip():
                print(f"WARNING: Constraint not modified - {original_line.strip()}")
                print(f"Available mappings: {list(bit_map.keys())}")
                
            # Format the line for readability before adding
            formatted_line = format_constraint_line(promoted_line)
            promoted_lines.append(formatted_line)
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
    """Main function with enhanced argument parsing and error handling."""
    parser = argparse.ArgumentParser(
        description="Promote SDC constraints from IP-level to top-level designs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic usage
  %(prog)s --source_rtl ip.v --source_sdc ip.sdc --target_rtl top.v --target_sdc top.sdc --instance ip_inst
  
  # With debug mode
  %(prog)s --source_rtl ip.v --source_sdc ip.sdc --target_rtl top.v --target_sdc top.sdc --instance ip_inst --debug
  
  # Verbose output
  %(prog)s --source_rtl ip.v --source_sdc ip.sdc --target_rtl top.v --target_sdc top.sdc --instance ip_inst --verbose
  
  # Multiple instances
  %(prog)s --source_rtl ip1.v ip2.v --source_sdc ip1.sdc ip2.sdc --target_rtl top.v --target_sdc top.sdc --instance ip1_inst ip2_inst
        """)
    
    parser.add_argument("--source_rtl", nargs='+', required=True, help="List of source IP Verilog files")
    parser.add_argument("--source_sdc", nargs='+', required=True, help="List of source IP SDC files") 
    parser.add_argument("--target_rtl", required=True, help="Path to target top-level Verilog file")
    parser.add_argument("--target_sdc", required=True, help="Path to output top-level SDC file")
    parser.add_argument("--instance", nargs='+', required=True, help="List of instance names in top-level design")
    parser.add_argument("--initial_sdc", help="Optional initial SDC file to merge with promoted constraints")
    parser.add_argument("--ignored_dir", default=".", help="Directory to store ignored constraint files")
    parser.add_argument("--debug", action='store_true', help="Enable debug mode with detailed logging")
    parser.add_argument("--verbose", action='store_true', help="Enable verbose output")
    parser.add_argument("--version", action='version', version='%(prog)s 2.0')
    
    args = parser.parse_args()
    
    # Setup logging
    logger = setup_logging(debug=args.debug, verbose=args.verbose)

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