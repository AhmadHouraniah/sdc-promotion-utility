# SDC Promotion Utility# SDC Promotion Utility



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)



A robust tool for promoting SDC (Synopsys Design Constraints) files from IP blocks to top-level designs in complex SoC and FPGA projects.A specialized tool for promoting SDC (Synopsys Design Constraints) files from IP blocks to top-level designs in complex SoC and FPGA projects.



## Overview## Overview



When integrating multiple IP blocks into a top-level design, each IP comes with its own SDC constraints. This utility automates the promotion of IP-level SDC constraints to the top-level design by:When integrating multiple IP blocks into a top-level design, each IP comes with its own SDC constraints. This utility automates the promotion of IP-level SDC constraints to the top-level design by:



- Mapping IP-level port references to their corresponding top-level signal paths- Mapping IP-level ports to their corresponding top-level signals

- Handling complex hierarchical signal naming and escaped identifiers- Expanding vector signals to bit-level constraints

- Promoting all constraint types (clocks, I/O delays, false paths, multicycle paths, etc.)- Promoting all constraint types (clocks, I/O delays, false paths, multicycle paths)

- Merging multiple IP SDCs into a unified top-level SDC- Merging multiple IP SDCs into a unified top-level SDC

- Filtering constraints based on signal connectivity to top-level I/O- Removing duplicates and resolving conflicts automatically

- Handling pathological Design Compiler output with robust parsing- Filtering constraints based on signal connectivity to top-level I/O



## Key Features## Features



### 🚀 **Core Functionality**### Core Functionality

- **Multi-IP Support**: Process multiple IP instances simultaneously- **Multi-IP Support**: Process multiple IP instances in a single operation

- **Hierarchical Signal Mapping**: Correctly map IP signals to top-level hierarchy- **Vector Signal Handling**: Comprehensive support for vector constraints including:

- **Comprehensive Constraint Support**: All major SDC constraint types  - Wildcard syntax: `{data_in[*]}` → `{fifo_data_in[*]}`

- **Signal Connectivity Analysis**: Only promotes constraints for signals connected to top-level I/O  - Range syntax: `{data_in[7:0]}` → `{fifo_data_in[7:0]}`

- **Robust Parsing**: Handles Design Compiler pathological output formatting  - Individual bit expansion to bit-level constraints

  - Mixed vector formats within single constraints

### 🎯 **Advanced Capabilities**- **Intelligent Deduplication**: Removes duplicate constraints while preserving intent

- **Vector Signal Handling**: Complete support for bus signals and ranges

- **Escaped Identifier Support**: Proper handling of Verilog escaped identifiers### Enhanced Capabilities

- **Intelligent Filtering**: Separates promotable vs. internal constraints- **Signal Connectivity Analysis**: Only promotes I/O delays for signals connected to top-level ports

- **Conflict Resolution**: Handles overlapping constraints from multiple IPs- **Advanced Signal Tracing**: Follows assign statements to find ultimate top-level connections

- **Debug and Logging**: Comprehensive debugging and analysis capabilities- **Pathological Syntax Handling**: Robust parsing of Design Compiler output with embedded comments

- **Escaped Identifier Support**: Proper handling of Verilog escaped identifiers (`\signal` ↔ `\\signal`)

### 📋 **Supported SDC Constructs**- **Initial SDC Integration**: Merges with existing top-level constraints

- Clock definitions (`create_clock`, `create_generated_clock`)- **Ignored Constraints Tracking**: Saves non-promoted constraints for debugging

- I/O timing (`set_input_delay`, `set_output_delay`)- **Conflict Resolution**: Automatically resolves constraint conflicts

- Timing exceptions (`set_false_path`, `set_multicycle_path`)

- Design rules (`set_max_delay`, `set_min_delay`, `set_max_transition`)### Testing and Validation

- Clock relationships (`set_clock_groups`)- **Optional Validation**: SDC validation disabled by default for faster testing

- Advanced constraints (`set_load`, `set_drive`, `group_path`, etc.)- **Comprehensive Test Suite**: 14 test cases covering basic to pathological scenarios

- **OpenSTA Integration**: Industry-standard timing validation when needed

## Installation- **Debug and Verbose Modes**: Detailed logging and progress tracking



### Prerequisites### Supported SDC Constructs

- **Python 3.7+** (required)- `create_clock` / `create_generated_clock`

- **iverilog** (recommended for RTL validation)- `set_input_delay` / `set_output_delay` (with -max/-min)

- `set_max_transition` / `set_max_delay` / `set_min_delay`

### Setup- `set_false_path` / `set_multicycle_path`

```bash- `set_clock_groups`

git clone https://github.com/AhmadHouraniah/sdc-promotion-utility.git

cd sdc-promotion-utility## Installation

```

### Prerequisites

No additional Python packages required - uses only standard library.- Python 3.7+

- Yosys (recommended for advanced Verilog validation)

## Usage- OpenSTA (optional, for basic timing validation)



### Basic Syntax### Install Yosys (Recommended)

```bash```bash

python3 scripts/promote_sdc.py \# Ubuntu/Debian

  --source_rtl <ip_verilog_files> \sudo apt-get install yosys

  --source_sdc <ip_sdc_files> \

  --target_rtl <top_level_verilog> \# CentOS/RHEL/Fedora

  --target_sdc <output_sdc> \sudo yum install yosys

  --instance <instance_names># or

```sudo dnf install yosys



### Single IP Promotion# macOS with Homebrew

```bashbrew install yosys

# Promote constraints from one IP to top-level```

python3 scripts/promote_sdc.py \

  --source_rtl tests/test9/processor_core_v2_1_3.v \## Usage

  --source_sdc tests/test9/ip.sdc \

  --target_rtl tests/test9/top.v \### Basic Promotion

  --target_sdc output.sdc \```bash

  --instance u_processor_core_inst1 \# Basic promotion from single IP

  --verbosepython scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc

```

# With verbose output

### Multiple IP Promotionpython scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc --verbose

```bash

# Promote constraints from multiple IPs# With debug output and file logging

python3 scripts/promote_sdc.py \python scripts/promote_sdc.py tests/test1/ip.sdc tests/test1/top.v inst_name -o output.sdc --debug

  --source_rtl ip1.v ip2.v \```

  --source_sdc ip1.sdc ip2.sdc \

  --target_rtl top.v \### Vector Signal Constraint Examples

  --target_sdc combined.sdc \The tool handles comprehensive vector signal constraint promotion:

  --instance ip1_inst ip2_inst \

  --debug**IP-level SDC (source):**

``````tcl

# Wildcard syntax - any width

### With Existing Top-Level Constraintsset_input_delay -clock ip_clk -max 2.0 [get_ports {data_in[*]}]

```bashset_output_delay -clock ip_clk -max 3.0 [get_ports {data_out[*]}]

# Merge with existing top-level SDC

python3 scripts/promote_sdc.py \# Specific range syntax  

  --source_rtl ip.v \set_input_delay -clock ip_clk -max 2.5 [get_ports {addr_bus[15:0]}]

  --source_sdc ip.sdc \set_max_transition 0.5 [get_ports {ctrl_signals[7:0]}]

  --target_rtl top.v \```

  --target_sdc promoted.sdc \

  --instance ip_inst \**Top-level SDC (promoted):**

  --initial_sdc existing_top.sdc```tcl

```# Promoted with proper signal mapping

set_input_delay -clock ip_clk -max 2.0 [get_ports {fifo_data_in[*]}]

## Command Line Optionsset_output_delay -clock ip_clk -max 3.0 [get_ports {fifo_data_out[*]}]



| Option | Description | Required |# Range preserved with mapped signals

|--------|-------------|----------|set_input_delay -clock ip_clk -max 2.5 [get_ports {memory_addr[15:0]}]  

| `--source_rtl` | IP Verilog files (space-separated) | Yes |set_max_transition 0.5 [get_ports {soc_control[7:0]}]

| `--source_sdc` | IP SDC files (space-separated) | Yes |```

| `--target_rtl` | Top-level Verilog file | Yes |

| `--target_sdc` | Output promoted SDC file | Yes |**Supported Vector Formats:**

| `--instance` | Instance names (space-separated) | Yes |- `{signal[*]}` - wildcard for any vector width

| `--initial_sdc` | Existing top-level SDC to merge with | No |- `{signal[7:0]}` - specific range notation  

| `--ignored_dir` | Directory for ignored constraints | No |- `{signal[15:0]}` - any range specification

| `--debug` | Enable debug logging | No |- `signal[*]` - wildcard without braces

| `--verbose` | Enable verbose output | No |- `signal[7:0]` - range without braces

- Mixed formats within the same constraint

## Example Workflow

### Combined Processing (Multiple IPs)

### 1. Prepare Your Files```bash

```# Process multiple IP blocks in a single run

project/python scripts/promote_sdc.py tests/test4/ip1.sdc tests/test4/ip2.sdc tests/test4/top_two_ips.v ip1_inst ip2_inst -o combined_output.sdc

├── ip_core.v          # IP Verilog

├── ip_core.sdc        # IP constraints  # With existing top-level constraints

└── top_level.v        # Top-level designpython scripts/promote_sdc.py tests/test5/mem_ctrl.sdc tests/test5/spi_ctrl.sdc tests/test5/soc_top.v mem_inst spi_inst -t tests/test5/soc_top.sdc -o promoted_constraints.sdc

``````



### 2. Run Promotion### File Outputs

```bashThe tool generates several output files based on logging mode:

python3 scripts/promote_sdc.py \- **Debug Mode**: `runs/debug.log` (complete trace), `runs/warnings.log` (warnings), `runs/mappings.txt` (signal mappings)

  --source_rtl ip_core.v \- **Verbose/Normal Mode**: Warnings and errors to console, minimal file output

  --source_sdc ip_core.sdc \- **Promoted Constraints**: Your specified output file (e.g., `-o output.sdc`)

  --target_rtl top_level.v \- **Ignored Constraints**: `<instance>_ignored_constraints.sdc` (non-promoted constraints for debugging)

  --target_sdc top_promoted.sdc \

  --instance u_ip_core \## Command Line Options

  --verbose

```| Option | Description |

|--------|-------------|

### 3. Review Output| `--source_rtl` | IP Verilog files (space-separated for multiple IPs) |

```| `--source_sdc` | IP SDC files (space-separated for multiple IPs) |

INFO: Processing u_ip_core (ip_core.v, ip_core.sdc)| `--target_rtl` | Top-level Verilog file |

INFO:   -> 45 constraints promoted, 12 ignored| `--target_sdc` | Output promoted SDC file |

Final promoted SDC with 47 constraints written to top_promoted.sdc| `--instance` | Instance names in top-level (space-separated for multiple IPs) |

```| `--initial_sdc` | Existing top-level SDC file to merge with |

| `--ignored_dir` | Directory to save ignored constraints |

## Signal Mapping Examples| `--debug` | Enable debug mode with detailed logging |

| `--verbose` | Enable verbose output |

### Input: IP-Level SDC

```tcl## Testing

# IP-level constraints reference IP port names

create_clock -name main_clk -period 5.0 [get_ports clk]The utility includes comprehensive test coverage with 14 test cases covering basic to pathological scenarios:

set_input_delay -clock main_clk -max 2.0 [get_ports {data_in[7:0]}]

set_output_delay -clock main_clk -max 3.0 [get_ports {data_out[15:0]}]```bash

```# Run all tests (validation disabled by default)

make test-all

### Output: Top-Level SDC  

```tcl# Run specific test

# Promoted constraints reference top-level signal pathsmake test1

create_clock -name main_clk -period 5.0 [get_ports system_clock]

set_input_delay -clock main_clk -max 2.0 [get_ports {u_ip_core/processor_data[7:0]}]# Run with validation enabled

set_output_delay -clock main_clk -max 3.0 [get_ports {u_ip_core/result_bus[15:0]}]make test1 VALIDATE=1

```

# Run multiple tests with validation

## Testingmake test1 test4 test9 VALIDATE=1



The utility includes 14 comprehensive test cases covering various scenarios:# Clean generated files

make clean

### Run All Tests```

```bash

# Test RTL compilation### Test Categories

for i in {9..14}; do- **Basic Cases (1-3)**: Single IP promotion scenarios

  echo "Testing test$i..."- **Multi-IP Cases (4-6)**: Multiple IP instances and SOC designs  

  iverilog -o /tmp/test${i} tests/test${i}/*.v && echo "✓ PASS" || echo "✗ FAIL"- **Edge Cases (7-11)**: Complex signals, malformed constraints, unicode handling

done- **Advanced Cases (12-14)**: Large-scale designs, SystemVerilog constructs



# Test SDC promotion### Validation Control

python3 scripts/promote_sdc.py \By default, tests run without OpenSTA validation for faster execution and fewer failures on complex constraints. Use `VALIDATE=1` to enable validation when needed:

  --source_rtl tests/test9/processor_core_v2_1_3.v \

  --source_sdc tests/test9/ip.sdc \```bash

  --target_rtl tests/test9/top.v \make test9         # Skips validation - focuses on SDC generation

  --target_sdc /tmp/test9.sdc \make test9 VALIDATE=1   # Runs full OpenSTA timing validation

  --instance u_processor_core_inst1```

```

## Project Structure

### Test Categories

- **test9**: Complex processor with pathological constraints  ```

- **test10**: Unicode and special character edge casessdc-promotion-utility/

- **test11**: Malformed constraint recovery├── scripts/                   # Core Python scripts

- **test12**: Large-scale IP with thousands of signals│   ├── promote_sdc.py        # Main SDC promotion tool

- **test13**: SystemVerilog to Verilog conversion│   └── validate_sdc.py       # Validation framework

- **test14**: Comprehensive multi-domain design├── tests/                    # Test cases and examples

│   ├── test1-test3/         # Basic promotion scenarios

## Project Structure│   ├── test4-test6/         # Multi-IP and SOC designs

│   ├── test7-test11/        # Edge cases and error handling

```│   └── test12-test14/       # Large-scale and SystemVerilog

sdc-promotion-utility/├── runs/                     # Generated outputs (auto-created)

├── scripts/├── docs/                     # Documentation

│   ├── promote_sdc.py      # Main SDC promotion tool├── Makefile                  # Build and test automation

│   └── validate_sdc.py     # SDC validation utilities└── README.md                 # This file

├── tests/```

│   ├── test1-test8/        # Legacy test cases

│   └── test9-test14/       # Current working test cases## Validation Framework

├── runs/                   # Generated outputs and logs

├── docs/                   # DocumentationThe validation framework provides optional verification of SDC files and promoted constraints using industry-standard tools.

├── Makefile               # Build automation

└── README.md              # This file### Validation Control

```- **Disabled by default**: Tests run without validation for faster execution

- **Enable when needed**: Use `VALIDATE=1` to run OpenSTA timing validation  

## Advanced Features- **Focus on core functionality**: SDC generation works regardless of validation results



### Debug Mode### Available Validation Methods

```bash

# Enable detailed logging**OpenSTA Integration** (Primary - Timing-Aware):

python3 scripts/promote_sdc.py ... --debug- Full timing analysis with netlist support

# Creates: runs/debug.log, runs/mappings.txt, runs/warnings.log- Comprehensive constraint checking  

```- Industry-standard timing validation

- Handles complex hierarchical designs

### Ignored Constraints

Non-promotable constraints are saved for analysis:**Custom Syntax Validation** (Fallback):

```bash- Fast syntax checking for SDC commands

# Constraints that couldn't be promoted are saved as:- Basic constraint validation without timing analysis

# <instance_name>_ignored_constraints.sdc- Works with SDC files alone (no netlist required)

```

### Usage Examples

### Signal Tracing```bash

The tool traces signals through:# Test without validation (default)

- Module port connectionsmake test1

- Wire assignments  

- Generate blocks# Test with OpenSTA validation

- Hierarchical pathsmake test1 VALIDATE=1



## Troubleshooting# Direct validation with OpenSTA

python scripts/validate_sdc.py runs/test1_top_promoted.sdc --verilog tests/test1/top.v

### Common Issues

# Quick syntax validation only  

**"Number of source RTLs, SDCs, and instances must match"**python scripts/validate_sdc.py runs/test1_top_promoted.sdc

- Ensure equal number of `--source_rtl`, `--source_sdc`, and `--instance` arguments```



**"No constraints promoted"**  ## License

- Check that IP signals are connected to top-level I/O

- Verify instance names match those in top-level RTLThis project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

- Enable `--debug` mode for detailed analysis

**Parsing Errors**
- Ensure Verilog files are syntactically correct
- Test with `iverilog` first: `iverilog -t null your_file.v`

### Getting Help
```bash
# Show all command options
python3 scripts/promote_sdc.py --help

# Enable debug mode for detailed analysis
python3 scripts/promote_sdc.py ... --debug --verbose
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add test cases for new functionality
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### Recent Updates
- ✅ Fixed all RTL compilation issues in test cases 9-14
- ✅ Updated SDC constraint files to match corrected RTL  
- ✅ Improved handling of escaped identifiers and special characters
- ✅ Enhanced robust parsing of pathological Design Compiler output
- ✅ Complete rewrite of large-scale test cases with clean implementations