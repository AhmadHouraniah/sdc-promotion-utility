# SDC Promotion Utility

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)

## 🎯 Purpose

This Python utility automates the promotion of **IP-level SDC constraints** to **top-level designs** in complex SoC and FPGA projects.

When integrating multiple IP blocks into a top-level design, each IP comes with its own SDC constraints. This tool automatically:

- 🔗 **Maps IP-level ports** to their corresponding top-level signals  
- 🧩 **Expands vector signals** to bit-level constraints  
- 🎛️ **Promotes all constraint types**: clocks, I/O delays, false paths, transitions, multicycle paths  
- 🔀 **Merges multiple IP SDCs** into a unified top-level SDC  
- ✨ **Removes duplicates** and resolves conflicts automatically  
- 🎯 **Filters constraints** based on signal connectivity to top-level I/O
- 📋 **Integrates with existing** top-level SDC files

---

## ✨ Key Features

### Core Functionality
- **Multi-IP Support**: Process multiple IPs in a single run
- **Vector Signal Handling**: Automatic expansion of bus signals to individual bits
- **Wildcard Support**: Handles `signal[*]` patterns in constraints
- **Intelligent Deduplication**: Removes duplicate constraints while preserving intent

### Enhanced Features
- **Debug Mode**: Comprehensive logging with detailed constraint processing information
- **Verbose Mode**: Enhanced output showing all processing steps and decisions
- **Signal Connectivity Analysis**: Only promotes I/O delays for signals connected to top-level ports
- **Initial SDC Integration**: Merges with existing top-level constraints (initial SDC takes precedence)
- **Ignored Constraints Tracking**: Saves non-promoted constraints to separate files for debugging
- **Conflict Resolution**: Automatically resolves constraint conflicts by choosing appropriate values
- **Type Hints**: Complete type annotations for better code maintainability
- **Enhanced CLI**: Improved command-line interface with better help and version information

### Supported SDC Constructs
- `create_clock` / `create_generated_clock`
- `set_input_delay` / `set_output_delay` (with -max/-min)
- `set_max_transition` / `set_max_delay` / `set_min_delay`
- `set_false_path` / `set_multicycle_path`
- `set_clock_groups`

---

## 🚀 Quick Start

### Basic Usage
```bash
python3 promote_sdc.py \
    --source_rtl ip1.v ip2.v \
    --source_sdc ip1.sdc ip2.sdc \
    --target_rtl top.v \
    --target_sdc top_merged.sdc \
    --instance ip1_inst ip2_inst
```

### Enhanced Usage with Connectivity Analysis
```bash
python3 promote_sdc.py \
    --source_rtl spi_ctrl.v mem_ctrl.v \
    --source_sdc spi_ctrl.sdc mem_ctrl.sdc \
    --target_rtl soc_top.v \
    --target_sdc soc_top_promoted.sdc \
    --instance u_spi u_memory \
    --initial_sdc existing_top.sdc \
    --ignored_dir ignored_constraints/
```

### Debug and Verbose Modes
```bash
# Debug mode - detailed logging with debug information
python3 promote_sdc.py \
    --source_rtl mem_ctrl.v \
    --source_sdc mem_ctrl.sdc \
    --target_rtl soc_top.v \
    --target_sdc soc_top_debug.sdc \
    --instance u_dram_interface \
    --debug

# Verbose mode - detailed processing information  
python3 promote_sdc.py \
    --source_rtl spi_ctrl.v mem_ctrl.v \
    --source_sdc spi_ctrl.sdc mem_ctrl.sdc \
    --target_rtl soc_top.v \
    --target_sdc soc_top_verbose.sdc \
    --instance u_spi u_memory \
    --verbose

# Combined debug and verbose with version info
python3 promote_sdc.py --version
python3 promote_sdc.py --help
```

---

## 🛠️ Installation

### Prerequisites
- Python 3.6 or later
- Verilog compiler (iverilog) for validation (optional)

### Setup
```bash
git clone https://github.com/yourusername/sdc-promotion-utility.git
cd sdc-promotion-utility
make dev-setup  # Optional: install development dependencies
```

---

## 📖 Usage Examples

### Using Makefile (Recommended)
```bash
# Run all tests
make test-all

# Test enhanced features
make test6

# Compare original vs enhanced results
make compare-results

# Validate RTL compilation
make compile-all

# See all available targets
make help
```

### Command Line Options
```
Required Arguments:
  --source_rtl RTL [RTL ...]     List of source IP RTL files
  --source_sdc SDC [SDC ...]     List of source IP SDC files  
  --target_rtl RTL               Top-level RTL file
  --target_sdc SDC               Output promoted SDC file
  --instance INST [INST ...]     Instance names in top-level RTL

Optional Arguments:
  --initial_sdc SDC              Existing top-level SDC to merge with
  --ignored_dir DIR              Directory for ignored constraint files
  --debug                        Enable debug mode with detailed logging
  --verbose                      Enable verbose output with processing details
  --version                      Show version information and exit
  -h, --help                     Show complete help message with examples
```

### Debug and Verbose Output Examples

**Debug Mode Output:**
```
DEBUG: Processing instance u_dram_interface with file mem_ctrl.v
DEBUG: Found port mapping: cmd_addr -> u_dram_interface.cmd_addr  
DEBUG: Promoting constraint: set_input_delay 1.5 -clock sys_clk [get_ports cmd_addr*]
DEBUG: Signal cmd_addr[0] connected to top-level port cmd_addr[0]
DEBUG: Successfully promoted constraint with signal mapping
```

**Verbose Mode Output:**
```
Processing u_spi (spi_ctrl.v, spi_ctrl.sdc)
  -> Parsed 23 constraints from spi_ctrl.sdc
  -> Found 15 port mappings in top-level design
  -> Promoted 18 constraints, ignored 5 constraints
  -> Written ignored constraints to u_spi_ignored_constraints.sdc
```

---

## 📁 Project Structure

```
sdc-promotion-utility/
├── promote_sdc.py              # Main promotion script (enhanced)
├── promote_sdc_original.py     # Original version (backup)  
├── Makefile                    # Build and test automation
├── README.md                   # This file
├── LICENSE                     # MIT License
├── test1/                      # Basic single IP test
├── test2/                      # Vector signals test  
├── test3/                      # Complex constraints test
├── test4/                      # Multiple IPs and wildcards
├── test5/                      # Multi-clock domains (original)
├── test6/                      # Enhanced features demonstration
└── __pycache__/               # Python cache (auto-generated)
```

---

## 🧪 Test Cases

The repository includes comprehensive test cases demonstrating various scenarios:

| Test | Description | Features Demonstrated |
|------|-------------|----------------------|
| **test1** | Basic single IP | Simple port mapping, basic constraints |
| **test2** | Vector signals | Bus expansion, complex signal types |
| **test3** | Complex constraints | All constraint types, timing analysis |
| **test4** | Multiple IPs | Deduplication, wildcard handling |
| **test5** | Multi-clock domains | Clock domain crossing, complex IP integration |
| **test6** | Enhanced features | Connectivity analysis, initial SDC, ignored tracking |

---

## 📊 Results Comparison

The enhanced version (test6) demonstrates significant improvements over the original approach:

- **Constraint Reduction**: ~45% fewer constraints in final SDC
- **Improved Accuracy**: Only promotes constraints for connected signals
- **Better Debugging**: Separate files for ignored constraints
- **Conflict Resolution**: Intelligent merging with existing constraints

---

## 🔧 Development

### Running Tests
```bash
# All tests
make test-all

# Specific test
make test6

# Quick CI pipeline
make ci-quick

# Full CI with compilation validation
make ci
```

### Code Quality
```bash
# Lint Python code
make lint

# Clean generated files
make clean
```

---

## 📋 Example Workflow

1. **Prepare IP constraints**: Each IP has its own `.sdc` file
2. **Create top-level design**: Instantiate IPs with proper signal connections
3. **Run promotion**: Use the utility to generate top-level SDC
4. **Review results**: Check promoted constraints and ignored files
5. **Integrate with EDA flow**: Use generated SDC in synthesis/P&R

### Before (Manual Process)
- ❌ Manual port mapping for each IP
- ❌ Error-prone constraint translation
- ❌ Difficult maintenance across design changes
- ❌ No automated conflict detection

### After (Automated Process)  
- ✅ Automatic signal mapping and promotion
- ✅ Intelligent constraint filtering
- ✅ Built-in conflict resolution
- ✅ Easy integration with existing flows

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup
```bash
make dev-setup
make test-all  # Ensure all tests pass
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Developed for complex SoC integration workflows
- Tested with industry-standard EDA tools
- Inspired by real-world ASIC/FPGA design challenges
