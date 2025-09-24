# Test Cases Documentation

## Test Suite Overview

The SDC Promotion Utility includes 14 comprehensive test cases that validate different aspects of SDC promotion and constraint handling.

## Test Categories

### Basic Scenarios (test1-test3)
**Purpose**: Validate fundamental SDC promotion functionality

#### Test 1: Basic Single IP Promotion
- **Description**: Single IP block with simple signal mapping
- **Features**: Basic constraint promotion, signal connectivity
- **Files**: 
  - `tests/test1/ip.v` - Simple IP with input/output ports
  - `tests/test1/ip.sdc` - Basic timing constraints
  - `tests/test1/top.v` - Top-level wrapper
- **Expected Output**: `runs/test1_top_promoted.sdc`

#### Test 2: Multiple IPs with Vector Signals
- **Description**: Complex IP with vector signals and multiple constraint types
- **Features**: Vector signal handling, complex constraint patterns
- **Files**: 
  - `tests/test2/ip_complex.v` - IP with vector signals
  - `tests/test2/ip_complex.sdc` - Complex constraints
  - `tests/test2/top_complex.v` - Top-level with vector connections

#### Test 3: Complex Timing Constraints
- **Description**: Advanced timing constraints and signal relationships
- **Features**: Multi-clock domains, complex timing relationships
- **Files**: 
  - `tests/test3/ip_full.v` - Full-featured IP
  - `tests/test3/ip_full.sdc` - Comprehensive constraint set

### Multi-IP Scenarios (test4-test6)
**Purpose**: Validate multiple IP integration and advanced features

#### Test 4: Wildcard Handling and Multiple IPs
- **Description**: Multiple IP blocks with wildcard signal matching
- **Features**: Multiple IP promotion, wildcard constraints
- **Files**: 
  - `tests/test4/ip1.v`, `tests/test4/ip2.v` - Two different IPs
  - `tests/test4/ip1.sdc`, `tests/test4/ip2.sdc` - Individual constraints
  - `tests/test4/top_two_ips.v` - Top-level with multiple instances

#### Test 5: Multi-Clock Domains
- **Description**: Complex multi-clock domain design
- **Features**: Clock domain crossing, complex signal mappings
- **Files**: 
  - `tests/test5/spi_ctrl.v`, `tests/test5/mem_ctrl.v` - Interface controllers
  - `tests/test5/spi_ctrl.sdc`, `tests/test5/mem_ctrl.sdc` - Interface constraints
  - `tests/test5/soc_top.v` - SoC-level integration

#### Test 6: Enhanced Features
- **Description**: Connectivity analysis and initial SDC preservation
- **Features**: Enhanced connectivity, initial constraint preservation
- **Files**: Same as test5 plus:
  - `tests/test6/initial_top.sdc` - Existing top-level constraints
- **Special**: Uses `--initial_sdc` and `--ignored_dir` features

### Edge Cases (test7-test11)
**Purpose**: Validate complex scenarios and edge cases

#### Test 7: Edge Cases (Complex Signals and Constraints)
- **Description**: Complex signal patterns and constraint edge cases
- **Features**: Unusual signal names, complex constraint patterns

#### Test 8: Clock Domain Crossing
- **Description**: CDC-specific constraint handling
- **Features**: False paths, clock group handling

#### Test 9: Advanced Multicycle Paths
- **Description**: Complex multicycle path scenarios
- **Features**: Setup/hold multicycle paths, complex timing

#### Test 10: Signal Mapping with Complex Hierarchies
- **Description**: Deep hierarchy and complex signal mapping
- **Features**: Hierarchical signal references, complex mappings

#### Test 11: Large-Scale Design with Many IPs
- **Description**: Stress testing with large constraint sets
- **Features**: Performance validation, large-scale integration

### Advanced Scenarios (test12-test14)
**Purpose**: Validate SystemVerilog support and comprehensive integration

#### Test 12: Wide Bus Interfaces
- **Description**: Very wide bus interfaces and massive constraint sets
- **Features**: Wide vector handling, performance testing
- **Special**: Contains ~2000 constraints for stress testing

#### Test 13: SystemVerilog Constructs
- **Description**: Advanced SystemVerilog language features
- **Features**: SystemVerilog syntax, packed arrays, interfaces
- **Tools**: Validates Yosys SystemVerilog parsing capabilities

#### Test 14: Comprehensive Integration
- **Description**: Real-world comprehensive design scenario
- **Features**: Multiple clock domains, complex interfaces, full feature set

## Test Execution

### Individual Tests
```bash
make test1        # Run single test
make debug1       # Run with debug output
```

### Batch Testing
```bash
make test-all     # Run all tests
make validate-all # Run all tests with validation
```

### Test Output Structure
```
runs/
├── test1_top_promoted.sdc              # Promoted constraints
├── test1_ip_inst_ignored_constraints.sdc # Ignored constraints
├── test1_validation.log                 # Validation log
└── ...
```

## Test Validation

Each test includes automatic validation:

1. **SDC Promotion**: Execute constraint promotion
2. **Yosys Validation**: Validate Verilog design integrity
3. **SDC Validation**: Validate promoted constraint syntax
4. **Output Verification**: Check expected outputs

## Expected Results

### Successful Test Output
```
=== Test X: [Description] ===
[Promotion output with statistics]
Validating promoted SDC...
Available validation tools:
  ✅ Yosys - Advanced Verilog parsing with SystemVerilog support
  ✅ OpenSTA - Basic timing validation (limited Verilog support)
  ✅ Custom syntax validation - Always available
🎯 Recommended: Using Yosys for best validation coverage
✓ Test X completed successfully
```

### Common Test Metrics
- **Constraints Promoted**: Number of successfully promoted constraints
- **Constraints Ignored**: Number of constraints that couldn't be promoted
- **Validation Status**: Pass/fail for each validation step
- **Processing Time**: Time taken for promotion and validation

## Troubleshooting Test Failures

### Common Issues

1. **Missing Verilog Files**
   - **Error**: "Verilog file not found"
   - **Solution**: Check test file paths in `tests/testX/`

2. **Module Reference Errors**
   - **Error**: "Module referenced in design is not part of the design"
   - **Solution**: Ensure all dependent modules are included

3. **Validation Tool Missing**
   - **Error**: "Command 'yosys' not found"
   - **Solution**: Install Yosys or accept custom validation fallback

4. **Constraint Syntax Errors**
   - **Error**: "Invalid SDC syntax"
   - **Solution**: Check SDC file format and syntax

### Debug Strategies

1. **Use Debug Mode**: `make debug1` for detailed output
2. **Check Individual Components**: Run promotion and validation separately
3. **Validate Tools**: `make check-tools` to verify tool availability
4. **Check File Paths**: Ensure all test files exist and are accessible

## Adding New Tests

To add a new test case:

1. **Create Test Directory**: `tests/testXX/`
2. **Add Required Files**:
   - Verilog design files (`.v`)
   - SDC constraint files (`.sdc`)
   - Optional: Initial SDC files
3. **Update Makefile**: Add new test target
4. **Document**: Update this documentation

### Test Template
```makefile
testXX: $(RUN_DIR)
    @echo "=== Test XX: [Description] ==="
    $(PYTHON) $(SCRIPT) \
        --source_rtl $(TEST_DIR)/testXX/[source].v \
        --source_sdc $(TEST_DIR)/testXX/[source].sdc \
        --target_rtl $(TEST_DIR)/testXX/[target].v \
        --target_sdc $(RUN_DIR)/testXX_[output].sdc \
        --instance [instance_name]
    @echo "Validating promoted SDC..."
    $(PYTHON) $(VALIDATOR) $(RUN_DIR)/testXX_[output].sdc \
        --check-tools --verilog-files [verilog_files]
    @echo "✓ Test XX completed successfully"
```

## Performance Benchmarks

| Test | Constraints | Promotion Time | Validation Time | Total Time |
|------|-------------|----------------|-----------------|------------|
| test1 | 6 | <1s | <1s | <2s |
| test4 | 44 | <1s | <1s | <2s |
| test12 | 218 | ~2s | ~1s | ~3s |
| test14 | 42 | <1s | <1s | <2s |

*Times are approximate and depend on system performance*