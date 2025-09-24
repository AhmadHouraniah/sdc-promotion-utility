# SDC Promotion Utility

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)

A specialized tool for promoting SDC (Synopsys Design Constraints) files from IP blocks to top-level designs in complex SoC and FPGA projects.

## Overview

When integrating multiple IP blocks into a top-level design, each IP comes with its own SDC constraints. This utility automates the promotion of IP-level SDC constraints to the top-level design by:

- Mapping IP-level ports to their corresponding top-level signals
- Expanding vector signals to bit-level constraints
- Promoting all constraint types (clocks, I/O delays, false paths, multicycle paths)
- Merging multiple IP SDCs into a unified top-level SDC
- Removing duplicates and resolving conflicts automatically
- Filtering constraints based on signal connectivity to top-level I/O

## Features

### Core Functionality
- **Multi-IP Support**: Process multiple IP instances in a single operation
- **Vector Signal Handling**: Automatic expansion of bus signals to individual bits
- **Wildcard Support**: Handles `signal[*]` patterns in constraints
- **Intelligent Deduplication**: Removes duplicate constraints while preserving intent

### Enhanced Capabilities
- **Signal Connectivity Analysis**: Only promotes I/O delays for signals connected to top-level ports
- **Advanced Signal Tracing**: Follows assign statements to find ultimate top-level connections
- **Pathological Syntax Handling**: Robust parsing of Design Compiler output with embedded comments
- **Escaped Identifier Support**: Proper handling of Verilog escaped identifiers (`\signal` ↔ `\\signal`)
- **Initial SDC Integration**: Merges with existing top-level constraints
- **Ignored Constraints Tracking**: Saves non-promoted constraints for debugging
- **Conflict Resolution**: Automatically resolves constraint conflicts

### Testing and Validation
- **Optional Validation**: SDC validation disabled by default for faster testing
- **Comprehensive Test Suite**: 14 test cases covering basic to pathological scenarios
- **OpenSTA Integration**: Industry-standard timing validation when needed
- **Debug and Verbose Modes**: Detailed logging and progress tracking

### Supported SDC Constructs
- `create_clock` / `create_generated_clock`
- `set_input_delay` / `set_output_delay` (with -max/-min)
- `set_max_transition` / `set_max_delay` / `set_min_delay`
- `set_false_path` / `set_multicycle_path`
- `set_clock_groups`

## Installation

### Prerequisites
- Python 3.7+
- Yosys (recommended for advanced Verilog validation)
- OpenSTA (optional, for basic timing validation)

### Install Yosys (Recommended)
```bash
# Ubuntu/Debian
sudo apt-get install yosys

# CentOS/RHEL/Fedora
sudo yum install yosys
# or
sudo dnf install yosys

# macOS with Homebrew
brew install yosys
```

## Usage

### Basic Promotion
```bash
# Basic promotion from single IP
python scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc

# With verbose output
python scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc --verbose

# With debug output and file logging
python scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc --debug
```

### Combined Processing (Multiple IPs)
```bash
# Process multiple IP blocks in a single run
python scripts/promote_sdc.py tests/test4/ip1.sdc tests/test4/ip2.sdc tests/test4/top_two_ips.v ip1_inst ip2_inst -o combined_output.sdc

# With existing top-level constraints
python scripts/promote_sdc.py tests/test5/mem_ctrl.sdc tests/test5/spi_ctrl.sdc tests/test5/soc_top.v mem_inst spi_inst -t tests/test5/soc_top.sdc -o promoted_constraints.sdc
```

### File Outputs
The tool generates several output files based on logging mode:
- **Debug Mode**: `runs/debug.log` (complete trace), `runs/warnings.log` (warnings), `runs/mappings.txt` (signal mappings)
- **Verbose/Normal Mode**: Warnings and errors to console, minimal file output
- **Promoted Constraints**: Your specified output file (e.g., `-o output.sdc`)
- **Ignored Constraints**: `<instance>_ignored_constraints.sdc` (non-promoted constraints for debugging)

## Command Line Options

| Option | Description |
|--------|-------------|
| `--source_rtl` | IP Verilog files (space-separated for multiple IPs) |
| `--source_sdc` | IP SDC files (space-separated for multiple IPs) |
| `--target_rtl` | Top-level Verilog file |
| `--target_sdc` | Output promoted SDC file |
| `--instance` | Instance names in top-level (space-separated for multiple IPs) |
| `--initial_sdc` | Existing top-level SDC file to merge with |
| `--ignored_dir` | Directory to save ignored constraints |
| `--debug` | Enable debug mode with detailed logging |
| `--verbose` | Enable verbose output |

## Testing

The utility includes comprehensive test coverage with 14 test cases covering basic to pathological scenarios:

```bash
# Run all tests (validation disabled by default)
make test-all

# Run specific test
make test1

# Run with validation enabled
make test1 VALIDATE=1

# Run multiple tests with validation
make test1 test4 test9 VALIDATE=1

# Clean generated files
make clean
```

### Test Categories
- **Basic Cases (1-3)**: Single IP promotion scenarios
- **Multi-IP Cases (4-6)**: Multiple IP instances and SOC designs  
- **Edge Cases (7-11)**: Complex signals, malformed constraints, unicode handling
- **Advanced Cases (12-14)**: Large-scale designs, SystemVerilog constructs

### Validation Control
By default, tests run without OpenSTA validation for faster execution and fewer failures on complex constraints. Use `VALIDATE=1` to enable validation when needed:

```bash
make test9         # Skips validation - focuses on SDC generation
make test9 VALIDATE=1   # Runs full OpenSTA timing validation
```

## Project Structure

```
sdc-promotion-utility/
├── scripts/                   # Core Python scripts
│   ├── promote_sdc.py        # Main SDC promotion tool
│   └── validate_sdc.py       # Validation framework
├── tests/                    # Test cases and examples
│   ├── test1-test3/         # Basic promotion scenarios
│   ├── test4-test6/         # Multi-IP and SOC designs
│   ├── test7-test11/        # Edge cases and error handling
│   └── test12-test14/       # Large-scale and SystemVerilog
├── runs/                     # Generated outputs (auto-created)
├── docs/                     # Documentation
├── Makefile                  # Build and test automation
└── README.md                 # This file
```

## Validation Framework

The validation framework provides optional verification of SDC files and promoted constraints using industry-standard tools.

### Validation Control
- **Disabled by default**: Tests run without validation for faster execution
- **Enable when needed**: Use `VALIDATE=1` to run OpenSTA timing validation  
- **Focus on core functionality**: SDC generation works regardless of validation results

### Available Validation Methods

**OpenSTA Integration** (Primary - Timing-Aware):
- Full timing analysis with netlist support
- Comprehensive constraint checking  
- Industry-standard timing validation
- Handles complex hierarchical designs

**Custom Syntax Validation** (Fallback):
- Fast syntax checking for SDC commands
- Basic constraint validation without timing analysis
- Works with SDC files alone (no netlist required)

### Usage Examples
```bash
# Test without validation (default)
make test1

# Test with OpenSTA validation
make test1 VALIDATE=1

# Direct validation with OpenSTA
python scripts/validate_sdc.py runs/test1_top_promoted.sdc --verilog tests/test1/top.v

# Quick syntax validation only  
python scripts/validate_sdc.py runs/test1_top_promoted.sdc
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
