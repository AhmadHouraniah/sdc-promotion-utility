# SDC Promotion Utility# SDC Promotion Utility



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)



A powerful tool for promoting SDC (Synopsys Design Constraints) files from IP blocks to top-level designs, with advanced validation and verification capabilities.## 🎯 Purpose



## 🚀 FeaturesThis Python utility automates the promotion of **IP-level SDC constraints** to **top-level designs** in complex SoC and FPGA projects.



- **Multi-IP Support**: Handle multiple IP blocks with complex signal mappingsWhen integrating multiple IP blocks into a top-level design, each IP comes with its own SDC constraints. This tool automatically:

- **Advanced Validation**: Hybrid validation using Yosys + custom SDC validation

- **Signal Intelligence**: Automatic signal connectivity analysis and mapping- 🔗 **Maps IP-level ports** to their corresponding top-level signals  

- **SystemVerilog Support**: Full support for SystemVerilog constructs via Yosys- 🧩 **Expands vector signals** to bit-level constraints  

- **Constraint Preservation**: Maintain initial top-level constraints during promotion- 🎛️ **Promotes all constraint types**: clocks, I/O delays, false paths, transitions, multicycle paths  

- **Comprehensive Testing**: 14 test cases covering edge cases and complex scenarios- 🔀 **Merges multiple IP SDCs** into a unified top-level SDC  

- ✨ **Removes duplicates** and resolves conflicts automatically  

## 📁 Repository Structure- 🎯 **Filters constraints** based on signal connectivity to top-level I/O

- 📋 **Integrates with existing** top-level SDC files

```

sdc-promotion-utility/---

├── scripts/                    # Core Python scripts

│   ├── promote_sdc.py         # Main SDC promotion tool## ✨ Key Features

│   └── validate_sdc.py        # Validation framework

├── tests/                     # Test cases and examples### Core Functionality

│   ├── test1-test3/          # Basic promotion scenarios- **Multi-IP Support**: Process multiple IPs in a single run

│   ├── test4-test6/          # Multi-IP and enhanced features- **Vector Signal Handling**: Automatic expansion of bus signals to individual bits

│   ├── test7-test11/         # Edge cases and complex scenarios- **Wildcard Support**: Handles `signal[*]` patterns in constraints

│   └── test12-test14/        # Large-scale and SystemVerilog tests- **Intelligent Deduplication**: Removes duplicate constraints while preserving intent

├── runs/                      # Generated outputs (created automatically)

│   ├── test*_*.sdc           # Promoted constraint files### Enhanced Features

│   ├── *.log                 # Validation logs- **Debug Mode**: Comprehensive logging with detailed constraint processing information

│   └── *_ignored_constraints.sdc  # Ignored constraints tracking- **Verbose Mode**: Enhanced output showing all processing steps and decisions

├── docs/                      # Documentation- **Signal Connectivity Analysis**: Only promotes I/O delays for signals connected to top-level ports

├── Makefile                   # Build and test automation- **Initial SDC Integration**: Merges with existing top-level constraints (initial SDC takes precedence)

└── README.md                  # This file- **Ignored Constraints Tracking**: Saves non-promoted constraints to separate files for debugging

```- **Conflict Resolution**: Automatically resolves constraint conflicts by choosing appropriate values

- **Type Hints**: Complete type annotations for better code maintainability

## 🛠️ Installation & Requirements- **Enhanced CLI**: Improved command-line interface with better help and version information



### Prerequisites### Supported SDC Constructs

- `create_clock` / `create_generated_clock`

- **Python 3.7+**- `set_input_delay` / `set_output_delay` (with -max/-min)

- **Yosys** (recommended for advanced Verilog validation)- `set_max_transition` / `set_max_delay` / `set_min_delay`

- **OpenSTA** (optional, basic timing validation)- `set_false_path` / `set_multicycle_path`

- `set_clock_groups`

### Install Yosys (Recommended)

---

```bash

# Ubuntu/Debian## 🚀 Quick Start

sudo apt-get install yosys

### Basic Usage

# CentOS/RHEL/Fedora```bash

sudo yum install yosyspython3 promote_sdc.py \

# or    --source_rtl ip1.v ip2.v \

sudo dnf install yosys    --source_sdc ip1.sdc ip2.sdc \

    --target_rtl top.v \

# macOS with Homebrew    --target_sdc top_merged.sdc \

brew install yosys    --instance ip1_inst ip2_inst

```

# From source

git clone https://github.com/YosysHQ/yosys.git### Enhanced Usage with Connectivity Analysis

cd yosys```bash

make && sudo make installpython3 promote_sdc.py \

```    --source_rtl spi_ctrl.v mem_ctrl.v \

    --source_sdc spi_ctrl.sdc mem_ctrl.sdc \

### Install OpenSTA (Optional)    --target_rtl soc_top.v \

    --target_sdc soc_top_promoted.sdc \

```bash    --instance u_spi u_memory \

# Build from source    --initial_sdc existing_top.sdc \

git clone https://github.com/The-OpenROAD-Project/OpenSTA.git    --ignored_dir ignored_constraints/

cd OpenSTA```

mkdir build && cd build

cmake ..### Debug and Verbose Modes

make && sudo make install```bash

```# Debug mode - detailed logging with debug information

python3 promote_sdc.py \

## 🚀 Quick Start    --source_rtl mem_ctrl.v \

    --source_sdc mem_ctrl.sdc \

### Basic Usage    --target_rtl soc_top.v \

    --target_sdc soc_top_debug.sdc \

```bash    --instance u_dram_interface \

# Check available tools    --debug

make check-tools

# Verbose mode - detailed processing information  

# Run a simple testpython3 promote_sdc.py \

make test1    --source_rtl spi_ctrl.v mem_ctrl.v \

    --source_sdc spi_ctrl.sdc mem_ctrl.sdc \

# Run all tests    --target_rtl soc_top.v \

make test-all    --target_sdc soc_top_verbose.sdc \

    --instance u_spi u_memory \

# Run with debug output    --verbose

make debug1

```# Combined debug and verbose with version info

python3 promote_sdc.py --version

### Manual Usagepython3 promote_sdc.py --help

```

```bash

# Basic SDC promotion---

python3 scripts/promote_sdc.py \

    --source_rtl tests/test1/ip.v \## 🛠️ Installation

    --source_sdc tests/test1/ip.sdc \

    --target_rtl tests/test1/top.v \### Prerequisites

    --target_sdc runs/promoted_output.sdc \- Python 3.6 or later

    --instance ip_inst- Verilog compiler (iverilog) for validation (optional)



# Validate the promoted SDC### Setup

python3 scripts/validate_sdc.py runs/promoted_output.sdc \```bash

    --check-tools \git clone https://github.com/yourusername/sdc-promotion-utility.git

    --verilog-files tests/test1/top.v tests/test1/ip.vcd sdc-promotion-utility

```make dev-setup  # Optional: install development dependencies

```

## 🧪 Validation Framework

---

The utility uses a **hybrid validation approach** that combines multiple tools for comprehensive coverage:

## 📖 Usage Examples

### 1. Yosys Validation

- **Purpose**: Verilog/SystemVerilog design validation### Using Makefile (Recommended)

- **Capabilities**: ```bash

  - Advanced SystemVerilog parsing# Run all tests

  - Module hierarchy validationmake test-all

  - Design syntax checking

- **Advantage**: Superior to OpenSTA for complex SystemVerilog designs# Test enhanced features

make test6

### 2. Custom SDC Validation

- **Purpose**: SDC constraint syntax and reference validation# Compare original vs enhanced results

- **Capabilities**:make compare-results

  - SDC command syntax checking

  - Constraint reference validation# Validate RTL compilation

  - Format and structure verificationmake compile-all



### 3. Combined Benefits# See all available targets

- **Design Context**: Yosys ensures Verilog design is validmake help

- **Constraint Accuracy**: Custom validation ensures SDC correctness```

- **Comprehensive Coverage**: Better than single-tool approaches

### Command Line Options

### Validation Strategy Flow```

Required Arguments:

```  --source_rtl RTL [RTL ...]     List of source IP RTL files

Verilog Files → Yosys → Design Valid? → Custom SDC Validator → Final Result  --source_sdc SDC [SDC ...]     List of source IP SDC files  

                  ↓                           ↓  --target_rtl RTL               Top-level RTL file

               [Parse & Check]           [Syntax & References]  --target_sdc SDC               Output promoted SDC file

```  --instance INST [INST ...]     Instance names in top-level RTL



## 📖 Usage ExamplesOptional Arguments:

  --initial_sdc SDC              Existing top-level SDC to merge with

### Example 1: Basic Single IP  --ignored_dir DIR              Directory for ignored constraint files

```bash  --debug                        Enable debug mode with detailed logging

make test1  --verbose                      Enable verbose output with processing details

# Promotes constraints from a single IP to top-level design  --version                      Show version information and exit

```  -h, --help                     Show complete help message with examples

```

### Example 2: Multiple IPs with Complex Signals

```bash### Debug and Verbose Output Examples

make test4

# Handles multiple IP blocks with vector signals and wildcards**Debug Mode Output:**

``````

DEBUG: Processing instance u_dram_interface with file mem_ctrl.v

### Example 3: Enhanced FeaturesDEBUG: Found port mapping: cmd_addr -> u_dram_interface.cmd_addr  

```bashDEBUG: Promoting constraint: set_input_delay 1.5 -clock sys_clk [get_ports cmd_addr*]

make test6DEBUG: Signal cmd_addr[0] connected to top-level port cmd_addr[0]

# Demonstrates connectivity analysis and initial SDC preservationDEBUG: Successfully promoted constraint with signal mapping

``````



### Example 4: Large-Scale SystemVerilog Design**Verbose Mode Output:**

```bash```

make test13Processing u_spi (spi_ctrl.v, spi_ctrl.sdc)

# Tests advanced SystemVerilog constructs and large constraint sets  -> Parsed 23 constraints from spi_ctrl.sdc

```  -> Found 15 port mappings in top-level design

  -> Promoted 18 constraints, ignored 5 constraints

## 🔧 Advanced Features  -> Written ignored constraints to u_spi_ignored_constraints.sdc

```

### Multi-IP Integration

The tool can handle multiple IP blocks simultaneously:---



```bash## 📁 Project Structure

python3 scripts/promote_sdc.py \

    --source_rtl ip1.v ip2.v ip3.v \```

    --source_sdc ip1.sdc ip2.sdc ip3.sdc \sdc-promotion-utility/

    --target_rtl top.v \├── promote_sdc.py              # Main promotion script (enhanced)

    --target_sdc promoted.sdc \├── promote_sdc_original.py     # Original version (backup)  

    --instance u_ip1 u_ip2 u_ip3├── Makefile                    # Build and test automation

```├── README.md                   # This file

├── LICENSE                     # MIT License

### Initial SDC Preservation├── test1/                      # Basic single IP test

Preserve existing top-level constraints:├── test2/                      # Vector signals test  

├── test3/                      # Complex constraints test

```bash├── test4/                      # Multiple IPs and wildcards

python3 scripts/promote_sdc.py \├── test5/                      # Multi-clock domains (original)

    --source_rtl ip.v \├── test6/                      # Enhanced features demonstration

    --source_sdc ip.sdc \└── __pycache__/               # Python cache (auto-generated)

    --target_rtl top.v \```

    --target_sdc promoted.sdc \

    --instance ip_inst \---

    --initial_sdc existing_top.sdc

```## 🧪 Test Cases



### Debug ModeThe repository includes comprehensive test cases demonstrating various scenarios:

Get detailed processing information:

| Test | Description | Features Demonstrated |

```bash|------|-------------|----------------------|

make debug1| **test1** | Basic single IP | Simple port mapping, basic constraints |

# or| **test2** | Vector signals | Bus expansion, complex signal types |

python3 scripts/promote_sdc.py [args] --debug| **test3** | Complex constraints | All constraint types, timing analysis |

```| **test4** | Multiple IPs | Deduplication, wildcard handling |

| **test5** | Multi-clock domains | Clock domain crossing, complex IP integration |

## 📊 Test Cases Overview| **test6** | Enhanced features | Connectivity analysis, initial SDC, ignored tracking |



| Test | Description | Features Demonstrated |---

|------|-------------|----------------------|

| test1-3 | Basic scenarios | Single IP, vector signals, complex constraints |## 📊 Results Comparison

| test4-6 | Multi-IP cases | Multiple IPs, enhanced features, connectivity |

| test7-11 | Edge cases | Complex hierarchies, CDC, multicycle paths |The enhanced version (test6) demonstrates significant improvements over the original approach:

| test12-14 | Advanced | Wide buses, SystemVerilog, comprehensive integration |

- **Constraint Reduction**: ~45% fewer constraints in final SDC

## 🛠️ Development & Debugging- **Improved Accuracy**: Only promotes constraints for connected signals

- **Better Debugging**: Separate files for ignored constraints

### Check Tool Availability- **Conflict Resolution**: Intelligent merging with existing constraints

```bash

make check-tools---

```

## 🔧 Development

### Run Validation Tests

```bash### Running Tests

make validate-all```bash

```# All tests

make test-all

### Debug Individual Tests

```bash# Specific test

make debug1    # Debug test 1make test6

make debug6    # Debug test 6

```# Quick CI pipeline

make ci-quick

### Code Quality

```bash# Full CI with compilation validation

make lint      # Check Python code stylemake ci

``````



### Cleanup### Code Quality

```bash```bash

make clean-runs   # Clean generated files# Lint Python code

make clean-all    # Complete cleanupmake lint

```

# Clean generated files

## 🤝 Contributingmake clean

```

1. Fork the repository

2. Create a feature branch (`git checkout -b feature/amazing-feature`)---

3. Make your changes

4. Add tests for new functionality## 📋 Example Workflow

5. Ensure all tests pass (`make test-all`)

6. Check code style (`make lint`)1. **Prepare IP constraints**: Each IP has its own `.sdc` file

7. Commit your changes (`git commit -m 'Add amazing feature'`)2. **Create top-level design**: Instantiate IPs with proper signal connections

8. Push to the branch (`git push origin feature/amazing-feature`)3. **Run promotion**: Use the utility to generate top-level SDC

9. Open a Pull Request4. **Review results**: Check promoted constraints and ignored files

5. **Integrate with EDA flow**: Use generated SDC in synthesis/P&R

## 📝 License

### Before (Manual Process)

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.- ❌ Manual port mapping for each IP

- ❌ Error-prone constraint translation

## 🆘 Support & Troubleshooting- ❌ Difficult maintenance across design changes

- ❌ No automated conflict detection

### Common Issues

### After (Automated Process)  

**Q: "Command 'yosys' not found"**- ✅ Automatic signal mapping and promotion

A: Install Yosys following the installation instructions above. The tool will fall back to custom validation if Yosys is unavailable.- ✅ Intelligent constraint filtering

- ✅ Built-in conflict resolution

**Q: "Module referenced in design is not part of the design"**- ✅ Easy integration with existing flows

A: Ensure all dependent Verilog files are included using `--verilog-files` option in validation.

---

**Q: Tests failing with validation errors**

A: Check that all required Verilog files exist and paths are correct. Use `make debug1` for detailed error information.## 🤝 Contributing



### Getting HelpContributions are welcome! Please feel free to submit issues, feature requests, or pull requests.



- Check the help: `make help`### Development Setup

- Validation help: `make help-validation````bash

- Testing help: `make help-testing`make dev-setup

- Run with debug mode: `make debug1`make test-all  # Ensure all tests pass

```

### Performance Tips

---

- Use Yosys for better SystemVerilog support

- Organize large designs with proper module hierarchy## 📄 License

- Use the `--ignored_dir` option to track ignored constraints

- Run individual tests during development rather than `test-all`This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## 📈 Roadmap---



- [ ] GUI interface for easier constraint management## 🙏 Acknowledgments

- [ ] Integration with more EDA tools

- [ ] Advanced constraint optimization algorithms- Developed for complex SoC integration workflows

- [ ] Real-time constraint conflict detection- Tested with industry-standard EDA tools

- [ ] Export capabilities for different EDA tool formats- Inspired by real-world ASIC/FPGA design challenges


---

**Made with ❤️ for the digital design community**