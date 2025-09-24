# Validation Framework Documentation

## Overview

The SDC Promotion Utility uses a hybrid validation approach that combines multiple tools to provide comprehensive validation coverage for both Verilog designs and SDC constraints.

## Validation Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Yosys Tool    │    │   Python Script  │    │   Custom SDC    │
│                 │    │                  │    │   Validator     │
│ ✓ Parse Verilog │───▶│ ✓ Orchestrate    │───▶│ ✓ Check SDC     │
│ ✓ Check modules │    │ ✓ Generate logs  │    │ ✓ Syntax rules  │
│ ✓ Design valid  │    │ ✓ Handle errors  │    │ ✓ References    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Tool Responsibilities

### 1. Yosys (Design Validation)
- **Purpose**: Verilog/SystemVerilog design parsing and validation
- **What it does**:
  - Parses Verilog and SystemVerilog files
  - Builds design hierarchy
  - Validates module instantiations and connections
  - Checks for syntax errors and design issues
- **What it doesn't do**:
  - Does NOT read or validate SDC files
  - Does NOT perform timing analysis
  - Does NOT check constraint syntax

### 2. Custom SDC Validator (Constraint Validation)
- **Purpose**: SDC syntax and reference validation
- **What it does**:
  - Validates SDC command syntax
  - Checks constraint references
  - Verifies argument patterns
  - Ensures proper formatting
- **What it doesn't do**:
  - Does NOT parse Verilog files
  - Does NOT perform design hierarchy checks
  - Does NOT do timing analysis

### 3. Python Orchestration Layer
- **Purpose**: Coordinate validation and provide user interface
- **What it does**:
  - Manages tool execution
  - Generates user-friendly messages
  - Handles error reporting
  - Provides logging and status updates

## Validation Flow

1. **Input Validation**: Check if input files exist
2. **Yosys Validation**: Parse Verilog files and validate design
3. **SDC Validation**: Check SDC syntax and references
4. **Result Aggregation**: Combine results from both validators
5. **Report Generation**: Provide comprehensive validation report

## Tool Detection and Fallback

The validation framework automatically detects available tools:

```python
# Tool availability check
yosys_available = check_tool_availability('yosys')
opensta_available = check_tool_availability('sta')

# Validation strategy selection
if yosys_available and verilog_files:
    return validate_with_yosys(sdc_file, verilog_files)
elif opensta_available and single_verilog_file:
    return validate_with_opensta(sdc_file, verilog_file)
else:
    return validate_sdc_syntax_only(sdc_file)
```

## Configuration and Options

### Command Line Options

```bash
# Basic validation
python3 scripts/validate_sdc.py constraints.sdc

# With Verilog context (single file)
python3 scripts/validate_sdc.py constraints.sdc --verilog design.v

# With multiple Verilog files
python3 scripts/validate_sdc.py constraints.sdc --verilog-files top.v ip1.v ip2.v

# Check available tools
python3 scripts/validate_sdc.py --check-tools

# Verbose output
python3 scripts/validate_sdc.py constraints.sdc --verbose
```

### Integration with Make Targets

All test targets automatically include validation:

```makefile
test1: $(RUN_DIR)
    # Run SDC promotion
    $(PYTHON) $(SCRIPT) [promotion args]
    # Validate results
    $(PYTHON) $(VALIDATOR) output.sdc --check-tools --verilog-files top.v ip.v
```

## Error Handling and Reporting

### Yosys Errors
- **Module not found**: Missing Verilog files or incorrect paths
- **Syntax errors**: Invalid Verilog syntax
- **Hierarchy issues**: Instantiation problems

### SDC Validation Errors
- **Invalid syntax**: Malformed SDC commands
- **Missing arguments**: Required arguments not provided
- **Reference errors**: Invalid object references

### Common Solutions
1. **"Module referenced in design is not part of the design"**
   - Solution: Include all dependent Verilog files using `--verilog-files`

2. **"Command 'yosys' not found"**
   - Solution: Install Yosys or accept fallback to custom validation

3. **"Invalid SDC syntax"**
   - Solution: Check SDC command format against supported syntax patterns

## Performance Considerations

- **Yosys**: Fast for small-medium designs, may be slower for very large designs
- **Custom Validation**: Very fast, scales well with constraint count
- **Combined**: Slight overhead but comprehensive coverage

## Supported SDC Commands

The custom validator supports validation of these SDC commands:

- `create_clock`
- `create_generated_clock`
- `set_clock_uncertainty`
- `set_clock_latency`
- `set_input_delay`
- `set_output_delay`
- `set_max_delay`
- `set_min_delay`
- `set_multicycle_path`
- `set_false_path`
- `set_clock_groups`
- `set_max_transition`
- `set_max_fanout`
- `set_max_capacitance`
- `set_load`
- `set_drive`
- And more...

## Future Enhancements

1. **Enhanced Error Messages**: More specific error descriptions
2. **Interactive Mode**: Real-time validation feedback
3. **Integration**: Direct integration with EDA tools
4. **Performance**: Optimization for very large designs
5. **Coverage**: Support for more SDC commands and advanced features