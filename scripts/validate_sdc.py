#!/usr/bin/env python3
"""
SDC Validation Framework

This module provides comprehensive validation for SDC (Synopsys Design Constraints) files
using multiple validation approaches:
1. OpenSTA-based validation for full timing analysis
2. Lig        # Try OpenSTA validation first if available and we have Verilog files
        if self.opensta_available and all_verilog_files:
            try:
                return self._validate_with_opensta(sdc_file, all_verilog_files)
            except Exception as e:
                print(f"OpenSTA validation failed, using syntax validation: {e}")
        
        # Fall back to syntax validation
        return self._validate_syntax_only(sdc_file)validation for basic constraint checking
3. Integration with the SDC promotion utility test suite

Features:
- Validates SDC syntax and semantics
- Supports both input and output SDC files
- Provides detailed error reporting
- Integrates with existing test infrastructure
- Falls back gracefully when OpenSTA is unavailable
"""

import os
import sys
import tempfile
import subprocess
import re
import argparse
from typing import List, Dict, Tuple, Optional, NamedTuple
from pathlib import Path

class ValidationResult(NamedTuple):
    """Result of SDC validation"""
    is_valid: bool
    errors: List[str]
    warnings: List[str]
    validator_used: str
    
class SDCValidator:
    """Comprehensive SDC file validator using multiple validation approaches"""
    
    def __init__(self, opensta_available: bool = None):
        """Initialize the validator
        
        Args:
            opensta_available: Override auto-detection of OpenSTA availability
        """
        self.opensta_available = self._check_opensta_available() if opensta_available is None else opensta_available
        self.sdc_commands = self._get_known_sdc_commands()
        
    def _check_opensta_available(self) -> bool:
        """Check if OpenSTA is available on the system"""
        try:
            result = subprocess.run(['sta', '-exit'], 
                                  capture_output=True, 
                                  text=True, 
                                  timeout=5,
                                  input='exit\n')
            return result.returncode == 0
        except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def _get_known_sdc_commands(self) -> Dict[str, Dict]:
        """Return dictionary of known SDC commands and their syntax patterns"""
        return {
            'create_clock': {
                'pattern': r'create_clock\s+.*-period\s+[\d.]+.*',
                'required_args': ['-period'],
                'description': 'Creates a clock definition'
            },
            'set_input_delay': {
                'pattern': r'set_input_delay\s+.*-clock\s+\w+.*',
                'required_args': ['-clock'],
                'description': 'Sets input delay constraint'
            },
            'set_output_delay': {
                'pattern': r'set_output_delay\s+.*-clock\s+\w+.*',
                'required_args': ['-clock'],
                'description': 'Sets output delay constraint'
            },
            'set_max_delay': {
                'pattern': r'set_max_delay\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets maximum delay constraint'
            },
            'set_min_delay': {
                'pattern': r'set_min_delay\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets minimum delay constraint'
            },
            'set_multicycle_path': {
                'pattern': r'set_multicycle_path\s+.*',
                'required_args': [],
                'description': 'Sets multicycle path constraint'
            },
            'set_false_path': {
                'pattern': r'set_false_path\s+.*',
                'required_args': [],
                'description': 'Sets false path constraint'
            },
            'set_clock_uncertainty': {
                'pattern': r'set_clock_uncertainty\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets clock uncertainty'
            },
            'set_clock_latency': {
                'pattern': r'set_clock_latency\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets clock latency'
            },
            'set_clock_groups': {
                'pattern': r'set_clock_groups\s+.*',
                'required_args': [],
                'description': 'Sets clock grouping for isolation'
            },
            'set_case_analysis': {
                'pattern': r'set_case_analysis\s+[01]\s+.*',
                'required_args': [],
                'description': 'Sets case analysis'
            },
            'set_disable_timing': {
                'pattern': r'set_disable_timing\s+.*',
                'required_args': [],
                'description': 'Disables timing arcs'
            },
            'set_max_transition': {
                'pattern': r'set_max_transition\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets maximum transition time'
            },
            'set_min_transition': {
                'pattern': r'set_min_transition\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets minimum transition time'
            },
            'set_max_fanout': {
                'pattern': r'set_max_fanout\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets maximum fanout'
            },
            'set_max_capacitance': {
                'pattern': r'set_max_capacitance\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets maximum capacitance'
            },
            'group_path': {
                'pattern': r'group_path\s+.*-name\s+\w+.*',
                'required_args': ['-name'],
                'description': 'Groups timing paths'
            },
            'set_load': {
                'pattern': r'set_load\s+[\d.]+\s+.*',
                'required_args': [],
                'description': 'Sets load capacitance'
            },
            'set_driving_cell': {
                'pattern': r'set_driving_cell\s+.*',
                'required_args': [],
                'description': 'Sets driving cell'
            },
            'all_clocks': {
                'pattern': r'all_clocks',
                'required_args': [],
                'description': 'Collection of all clocks'
            },
            'all_inputs': {
                'pattern': r'all_inputs',
                'required_args': [],
                'description': 'Collection of all input ports'
            },
            'all_outputs': {
                'pattern': r'all_outputs',
                'required_args': [],
                'description': 'Collection of all output ports'
            },
            'all_registers': {
                'pattern': r'all_registers',
                'required_args': [],
                'description': 'Collection of all registers'
            },
            'get_ports': {
                'pattern': r'get_ports\s+.*',
                'required_args': [],
                'description': 'Gets port objects'
            },
            'get_pins': {
                'pattern': r'get_pins\s+.*',
                'required_args': [],
                'description': 'Gets pin objects'
            },
            'get_cells': {
                'pattern': r'get_cells\s+.*',
                'required_args': [],
                'description': 'Gets cell objects'
            },
            'get_nets': {
                'pattern': r'get_nets\s+.*',
                'required_args': [],
                'description': 'Gets net objects'
            },
            'get_clocks': {
                'pattern': r'get_clocks\s+.*',
                'required_args': [],
                'description': 'Gets clock objects'
            }
        }
    
    def validate_file(self, sdc_file: str, verilog_file: str = None, verilog_files: List[str] = None) -> ValidationResult:
        """Validate an SDC file using the best available method
        
        Args:
            sdc_file: Path to SDC file to validate
            verilog_file: Primary Verilog file for context (used with OpenSTA/Yosys)
            verilog_files: List of all Verilog files for multi-module designs
            
        Returns:
            ValidationResult with validation outcome and details
        """
        if not os.path.exists(sdc_file):
            return ValidationResult(
                is_valid=False,
                errors=[f"SDC file not found: {sdc_file}"],
                warnings=[],
                validator_used="file_check"
            )
        
        # Determine Verilog files to use
        all_verilog_files = []
        if verilog_files:
            all_verilog_files = verilog_files
        elif verilog_file and os.path.exists(verilog_file):
            all_verilog_files = [verilog_file]
        
        # Try OpenSTA validation if available and we have a single Verilog file
        if self.opensta_available and verilog_file and os.path.exists(verilog_file):
            try:
                return self._validate_with_opensta(sdc_file, verilog_file)
            except Exception as e:
                print(f"OpenSTA validation failed, falling back to syntax validation: {e}")
        
        # Fall back to syntax validation
        return self._validate_syntax(sdc_file)
    
    def _validate_with_opensta(self, sdc_file: str, verilog_file: str) -> ValidationResult:
        """Validate SDC file using OpenSTA
        
        Args:
            sdc_file: Path to SDC file
            verilog_file: Path to Verilog file for design context
            
        Returns:
            ValidationResult from OpenSTA validation
        """
        errors = []
        warnings = []
        
        # Create log file name based on SDC file location
        sdc_dir = os.path.dirname(sdc_file)
        base_name = os.path.splitext(os.path.basename(sdc_file))[0]
        log_file = os.path.join(sdc_dir, f"{base_name}_opensta.log")
        
        # Create temporary TCL script for OpenSTA
        with tempfile.NamedTemporaryFile(mode='w', suffix='.tcl', delete=False) as tcl_file:
            tcl_script = f"""
# Redirect all output to log file
set log_file [open "{log_file}" w]

# Read design
if {{[catch {{read_verilog {verilog_file}}} result]}} {{
    puts $log_file "ERROR: Failed to read Verilog file: $result"
    puts "ERROR: Failed to read Verilog file: $result"
    close $log_file
    exit 1
}}
puts $log_file "INFO: Successfully read Verilog file: {verilog_file}"

# Try to link design (find top module automatically)
set verilog_content [read [open {verilog_file} r]]
if {{[regexp -line {{^\\s*module\\s+(\\w+)}} $verilog_content match top_module]}} {{
    puts $log_file "INFO: Found top module: $top_module"
    if {{[catch {{link_design $top_module}} result]}} {{
        puts $log_file "ERROR: Failed to link design $top_module: $result"
        puts "ERROR: Failed to link design $top_module: $result"
        close $log_file
        exit 1
    }}
    puts $log_file "INFO: Successfully linked design: $top_module"
}} else {{
    puts $log_file "ERROR: Could not find top module in Verilog file"
    puts "ERROR: Could not find top module in Verilog file"
    close $log_file
    exit 1
}}

# Read and validate SDC file
puts $log_file "INFO: Reading SDC file: {sdc_file}"
if {{[catch {{source {sdc_file}}} result]}} {{
    puts $log_file "ERROR: SDC validation failed: $result"
    puts "ERROR: SDC validation failed: $result"
    close $log_file
    exit 1
}} else {{
    puts $log_file "SUCCESS: SDC file is valid"
    puts "SUCCESS: SDC file is valid"
}}

# Try a basic timing check to ensure constraints are meaningful
puts $log_file "INFO: Running basic timing checks"
if {{[catch {{check_setup}} result]}} {{
    puts $log_file "WARNING: Setup check issues: $result"
    puts "WARNING: Setup check issues: $result"
}} else {{
    puts $log_file "INFO: Setup checks passed"
}}

puts $log_file "INFO: OpenSTA validation completed successfully"
close $log_file
exit 0
"""
            tcl_file.write(tcl_script)
            tcl_file_path = tcl_file.name
        
        try:
            # Run OpenSTA with the TCL script
            result = subprocess.run(
                ['sta', tcl_file_path],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            output = result.stdout + result.stderr
            
            # Parse OpenSTA output for errors and warnings
            for line in output.split('\n'):
                line = line.strip()
                if line.startswith('ERROR:'):
                    errors.append(line[6:].strip())
                elif line.startswith('WARNING:'):
                    warnings.append(line[8:].strip())
                # Only count lines that start with "Error:" or "Warning:" as errors/warnings
                # This avoids parsing error messages within warning descriptions
                elif line.startswith('Error:'):
                    errors.append(line)
                elif line.startswith('Warning:'):
                    warnings.append(line)
            
            # Also read the log file if it exists for additional details
            if os.path.exists(log_file):
                try:
                    with open(log_file, 'r') as f:
                        log_content = f.read()
                        print(f"OpenSTA log saved to: {log_file}")
                        # Extract additional errors/warnings from log - only lines that start with ERROR:/WARNING:
                        for line in log_content.split('\n'):
                            line = line.strip()
                            if line.startswith('ERROR:') and line[6:].strip() not in errors:
                                errors.append(line[6:].strip())
                            elif line.startswith('WARNING:') and line[8:].strip() not in warnings:
                                warnings.append(line[8:].strip())
                except Exception as e:
                    warnings.append(f"Could not read log file {log_file}: {e}")
            
            is_valid = result.returncode == 0 and len(errors) == 0
            
            return ValidationResult(
                is_valid=is_valid,
                errors=errors,
                warnings=warnings,
                validator_used="opensta"
            )
            
        finally:
            # Clean up temporary file
            try:
                os.unlink(tcl_file_path)
            except OSError:
                pass
    
    def _validate_sdc_syntax_and_references(self, sdc_file: str, context_output: str = "") -> ValidationResult:
        """Validate SDC syntax and signal references using custom parsing
        
        Args:
            sdc_file: Path to SDC file
            context_output: Output from timing tool for signal reference checking
            
        Returns:
            ValidationResult from custom SDC validation
        """
        errors = []
        warnings = []
        
        try:
            with open(sdc_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            try:
                with open(sdc_file, 'r', encoding='latin-1') as f:
                    content = f.read()
                warnings.append("File encoding is not UTF-8, used Latin-1")
            except Exception as e:
                errors.append(f"Failed to read SDC file: {e}")
                return ValidationResult(
                    is_valid=False,
                    errors=errors,
                    warnings=warnings,
                    validator_used="custom_sdc"
                )
        
        lines = content.split('\n')
        
        for line_num, line in enumerate(lines, 1):
            line = line.strip()
            
            # Skip comments and empty lines
            if not line or line.startswith('#'):
                continue
            
            # Basic SDC command validation
            found_command = False
            for cmd_name, cmd_info in self.sdc_commands.items():
                if line.startswith(cmd_name):
                    found_command = True
                    # Check basic syntax pattern
                    if not re.match(cmd_info['pattern'], line, re.IGNORECASE):
                        errors.append(f"Line {line_num}: Invalid syntax for {cmd_name} command")
                    
                    # Check for required arguments
                    for req_arg in cmd_info['required_args']:
                        if req_arg not in line:
                            errors.append(f"Line {line_num}: Missing required argument {req_arg} for {cmd_name}")
                    break
            
            if not found_command:
                # Check if it looks like an SDC command but is unsupported
                if any(keyword in line.lower() for keyword in ['create_', 'set_', 'get_']):
                    warnings.append(f"Line {line_num}: Unrecognized SDC command: {line[:50]}...")
        
        return ValidationResult(
            is_valid=len(errors) == 0,
            errors=errors,
            warnings=warnings,
            validator_used="custom_sdc"
        )
    
    def _validate_syntax(self, sdc_file: str) -> ValidationResult:
        """Validate SDC file using syntax checking
        
        Args:
            sdc_file: Path to SDC file
            
        Returns:
            ValidationResult from syntax validation
        """
        errors = []
        warnings = []
        
        try:
            with open(sdc_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            # Try with different encoding
            try:
                with open(sdc_file, 'r', encoding='latin-1') as f:
                    content = f.read()
                warnings.append("File encoding is not UTF-8, used Latin-1")
            except Exception as e:
                errors.append(f"Failed to read file: {e}")
                return ValidationResult(
                    is_valid=False,
                    errors=errors,
                    warnings=warnings,
                    validator_used="syntax_check"
                )
        
        lines = content.split('\n')
        
        for line_num, line in enumerate(lines, 1):
            line = line.strip()
            
            # Skip comments and empty lines
            if not line or line.startswith('#'):
                continue
            
            # Check for basic syntax issues
            syntax_errors = self._check_line_syntax(line, line_num)
            errors.extend(syntax_errors)
            
            # Check for known SDC commands
            syntax_warnings = self._check_command_syntax(line, line_num)
            warnings.extend(syntax_warnings)
        
        # Check for basic constraint consistency
        consistency_issues = self._check_constraint_consistency(content)
        warnings.extend(consistency_issues)
        
        is_valid = len(errors) == 0
        
        return ValidationResult(
            is_valid=is_valid,
            errors=errors,
            warnings=warnings,
            validator_used="syntax_check"
        )
    
    def _check_line_syntax(self, line: str, line_num: int) -> List[str]:
        """Check basic syntax issues in a line"""
        errors = []
        
        # Check for unmatched braces
        open_braces = line.count('{')
        close_braces = line.count('}')
        if open_braces != close_braces:
            errors.append(f"Line {line_num}: Unmatched braces ({{ {open_braces}, }} {close_braces})")
        
        # Check for unmatched brackets
        open_brackets = line.count('[')
        close_brackets = line.count(']')
        if open_brackets != close_brackets:
            errors.append(f"Line {line_num}: Unmatched brackets ([ {open_brackets}, ] {close_brackets})")
        
        # Check for basic TCL syntax issues
        if line.endswith('\\') and not line.endswith('\\\\'):
            # Line continuation should be followed by actual continuation
            pass  # This is actually valid TCL
        
        # Check for incomplete strings
        quote_count = line.count('"')
        if quote_count % 2 != 0:
            errors.append(f"Line {line_num}: Unmatched quotes")
        
        return errors
    
    def _check_command_syntax(self, line: str, line_num: int) -> List[str]:
        """Check SDC command syntax"""
        warnings = []
        
        # Extract command name
        parts = line.split()
        if not parts:
            return warnings
            
        command = parts[0]
        
        # Check if it's a known SDC command
        if command in self.sdc_commands:
            cmd_info = self.sdc_commands[command]
            
            # Check required arguments
            for required_arg in cmd_info['required_args']:
                if required_arg not in line:
                    warnings.append(f"Line {line_num}: Command '{command}' missing required argument '{required_arg}'")
            
            # Check pattern matching only for commands with strict patterns
            if cmd_info['required_args'] and not re.search(cmd_info['pattern'], line, re.IGNORECASE):
                warnings.append(f"Line {line_num}: Command '{command}' syntax may be incorrect")
        
        # Only flag truly unknown commands that look like SDC but aren't in our list
        elif (command.startswith('set_') or command.startswith('get_') or 
              command in ['create_clock', 'group_path', 'all_clocks', 'all_inputs', 'all_outputs']) and command not in self.sdc_commands:
            warnings.append(f"Line {line_num}: Unknown SDC command '{command}' - please verify syntax")
        
        return warnings
    
    def _check_constraint_consistency(self, content: str) -> List[str]:
        """Check for constraint consistency issues"""
        warnings = []
        
        # Look for clock definitions
        clock_matches = re.findall(r'create_clock\s+.*?-name\s+(\w+)', content, re.IGNORECASE)
        clocks = set(clock_matches)
        
        # Look for clock references in other constraints
        clock_refs = re.findall(r'-clock\s+(\w+)', content, re.IGNORECASE)
        
        # Check for undefined clock references
        for clock_ref in clock_refs:
            if clock_ref not in clocks:
                warnings.append(f"Reference to undefined clock '{clock_ref}'")
        
        # Check for unreferenced clocks
        unreferenced_clocks = clocks - set(clock_refs)
        if unreferenced_clocks:
            warnings.append(f"Clocks defined but not referenced: {', '.join(unreferenced_clocks)}")
        
        return warnings

def validate_sdc_files(input_sdc: str, output_sdc: str = None, verilog_file: str = None, 
                      verbose: bool = False) -> Tuple[bool, Dict]:
    """Validate input and optionally output SDC files
    
    Args:
        input_sdc: Path to input SDC file
        output_sdc: Path to output/promoted SDC file (optional)
        verilog_file: Path to Verilog file for context (optional)
        verbose: Enable verbose output
        
    Returns:
        Tuple of (all_valid, results_dict)
    """
    validator = SDCValidator()
    results = {}
    all_valid = True
    
    # Validate input SDC
    if verbose:
        print(f"Validating input SDC: {input_sdc}")
    
    input_result = validator.validate_file(input_sdc, verilog_file)
    results['input'] = input_result
    
    if not input_result.is_valid:
        all_valid = False
        if verbose:
            print(f"  ❌ Input SDC validation failed ({input_result.validator_used})")
            for error in input_result.errors:
                print(f"    ERROR: {error}")
    else:
        if verbose:
            print(f"  ✅ Input SDC is valid ({input_result.validator_used})")
    
    if input_result.warnings and verbose:
        for warning in input_result.warnings:
            print(f"    WARNING: {warning}")
    
    # Validate output SDC if provided
    if output_sdc:
        if verbose:
            print(f"Validating output SDC: {output_sdc}")
        
        output_result = validator.validate_file(output_sdc, verilog_file)
        results['output'] = output_result
        
        if not output_result.is_valid:
            all_valid = False
            if verbose:
                print(f"  ❌ Output SDC validation failed ({output_result.validator_used})")
                for error in output_result.errors:
                    print(f"    ERROR: {error}")
        else:
            if verbose:
                print(f"  ✅ Output SDC is valid ({output_result.validator_used})")
        
        if output_result.warnings and verbose:
            for warning in output_result.warnings:
                print(f"    WARNING: {warning}")
    
    return all_valid, results

def validate_sdc_files_enhanced(input_sdc: str, output_sdc: str = None, 
                               verilog_file: str = None, verilog_files: List[str] = None,
                               verbose: bool = False) -> Tuple[bool, Dict]:
    """Enhanced SDC validation supporting multiple Verilog files and better tool selection
    
    Args:
        input_sdc: Path to input SDC file
        output_sdc: Optional path to output SDC file
        verilog_file: Primary Verilog file (for backward compatibility)
        verilog_files: List of Verilog files for multi-module designs
        verbose: Whether to print detailed output
        
    Returns:
        Tuple of (all_valid, results_dict)
    """
    validator = SDCValidator()
    all_valid = True
    results = {}
    
    if verbose:
        print(f"Using validator: ", end="")
        if validator.opensta_available:
            print("OpenSTA")
        else:
            print("Syntax validation only")
    
    # Validate input SDC
    if verbose:
        print(f"Validating input SDC: {input_sdc}")
    
    input_result = validator.validate_file(input_sdc, verilog_file, verilog_files)
    results['input'] = input_result
    
    if not input_result.is_valid:
        all_valid = False
        if verbose:
            print(f"  ❌ Input SDC validation failed ({input_result.validator_used})")
            for error in input_result.errors:
                print(f"    ERROR: {error}")
    else:
        if verbose:
            print(f"  ✅ Input SDC is valid ({input_result.validator_used})")
    
    if input_result.warnings and verbose:
        for warning in input_result.warnings:
            print(f"    WARNING: {warning}")
    
    # Validate output SDC if provided
    if output_sdc:
        if verbose:
            print(f"Validating output SDC: {output_sdc}")
        
        output_result = validator.validate_file(output_sdc, verilog_file, verilog_files)
        results['output'] = output_result
        
        if not output_result.is_valid:
            all_valid = False
            if verbose:
                print(f"  ❌ Output SDC validation failed ({output_result.validator_used})")
                for error in output_result.errors:
                    print(f"    ERROR: {error}")
        else:
            if verbose:
                print(f"  ✅ Output SDC is valid ({output_result.validator_used})")
        
        if output_result.warnings and verbose:
            for warning in output_result.warnings:
                print(f"    WARNING: {warning}")
    
    return all_valid, results

def main():
    """Command-line interface for SDC validation"""
    parser = argparse.ArgumentParser(description='Validate SDC constraint files')
    parser.add_argument('input_sdc', nargs='?', help='Input SDC file to validate')
    parser.add_argument('--output-sdc', help='Output/promoted SDC file to validate')
    parser.add_argument('--verilog', help='Primary Verilog file for design context')
    parser.add_argument('--verilog-files', nargs='+', help='Multiple Verilog files for multi-module designs')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--check-tools', action='store_true', help='Check available validation tools and exit')
    
    args = parser.parse_args()
    
    if args.check_tools:
        validator = SDCValidator()
        print("Available validation tools:")
        if validator.opensta_available:
            print("  ✅ OpenSTA - Full timing validation (requires netlist format)")
        else:
            print("  ❌ OpenSTA - Not available")
        print("  ✅ Custom syntax validation - SDC syntax and constraint checking")
        
        if validator.opensta_available:
            print("\n🎯 Recommended: Using OpenSTA for comprehensive timing validation")
            print("   Note: OpenSTA works best with netlist files (.v from synthesis)")
        else:
            print("\n⚠️  Using syntax validation only (no timing analysis)")
        sys.exit(0)
    
    if not args.input_sdc:
        parser.error("input_sdc is required unless using --check-tools")
    
    # Determine Verilog files to use
    verilog_files = args.verilog_files if args.verilog_files else None
    if args.verilog and not verilog_files:
        verilog_files = [args.verilog]
    
    all_valid, results = validate_sdc_files_enhanced(
        args.input_sdc, 
        args.output_sdc, 
        args.verilog,
        verilog_files,
        args.verbose
    )
    
    if all_valid:
        print("✅ All SDC files are valid")
        sys.exit(0)
    else:
        print("❌ SDC validation failed")
        sys.exit(1)

if __name__ == '__main__':
    main()