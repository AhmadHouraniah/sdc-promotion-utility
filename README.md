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
- **Initial SDC Integration**: Merges with existing top-level constraints
- **Ignored Constraints Tracking**: Saves non-promoted constraints for debugging
- **Conflict Resolution**: Automatically resolves constraint conflicts
- **Debug and Verbose Modes**: Comprehensive logging and analysis

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

### Basic SDC Promotion
```bash
python3 scripts/promote_sdc.py \
    --source_rtl tests/test1/ip.v \
    --source_sdc tests/test1/ip.sdc \
    --target_rtl tests/test1/top.v \
    --target_sdc runs/top_promoted.sdc \
    --instance ip_inst
```

### Multi-IP Promotion
```bash
python3 scripts/promote_sdc.py \
    --source_rtl tests/test5/mem_ctrl.v tests/test5/spi_ctrl.v \
    --source_sdc tests/test5/mem_ctrl.sdc tests/test5/spi_ctrl.sdc \
    --target_rtl tests/test5/soc_top.v \
    --target_sdc runs/soc_promoted.sdc \
    --instance u_memory u_spi
```

### Advanced Usage with Debug Mode
```bash
python3 scripts/promote_sdc.py \
    --source_rtl tests/test6/mem_ctrl.v \
    --source_sdc tests/test6/mem_ctrl.sdc \
    --target_rtl tests/test6/soc_top.v \
    --target_sdc runs/advanced_promoted.sdc \
    --instance u_dram_interface \
    --initial_sdc tests/test6/initial_top.sdc \
    --ignored_dir runs/ \
    --debug
```

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

The utility includes comprehensive test coverage with 14 test cases:

```bash
# Run all tests
make test-all

# Run specific test
make test1

# Run with validation
make validate

# Clean generated files
make clean
```

### Test Categories
- **Basic Cases (1-3)**: Single IP promotion scenarios
- **Multi-IP Cases (4-6)**: Multiple IP instances and SOC designs
- **Edge Cases (7-11)**: Complex signals, malformed constraints, unicode handling
- **Advanced Cases (12-14)**: Large-scale designs, SystemVerilog constructs

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

## Validation

The utility includes hybrid validation using:
- **Yosys**: Advanced Verilog parsing and SystemVerilog support
- **Custom SDC Parser**: Constraint-specific validation
- **Signal Connectivity Analysis**: Ensures promoted constraints are valid

```bash
# Validate promoted SDC file
python3 scripts/validate_sdc.py runs/promoted.sdc --check-tools --verilog-files top.v ip.v
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.





## 📈 Roadmap---



- [ ] GUI interface for easier constraint management## 🙏 Acknowledgments

- [ ] Integration with more EDA tools

- [ ] Advanced constraint optimization algorithms- Developed for complex SoC integration workflows

- [ ] Real-time constraint conflict detection- Tested with industry-standard EDA tools

- [ ] Export capabilities for different EDA tool formats- Inspired by real-world ASIC/FPGA design challenges


---

**Made with ❤️ for the digital design community**