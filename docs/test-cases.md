# Test Cases Documentation# Test Cases Documentation



## Overview## Test Suite Overview



The SDC Promotion Utility includes 14 comprehensive test cases that validate different aspects of SDC constraint promotion, RTL parsing, and hierarchical signal mapping. Tests 1-8 are legacy cases for basic functionality, while **tests 9-14** represent the current active test suite with comprehensive coverage of real-world scenarios.The SDC Promotion Utility includes 14 comprehensive test cases that validate different aspects of SDC promotion and constraint handling.



## Active Test Suite (Tests 9-14)## Test Categories



All active test cases have been validated for:### Basic Scenarios (test1-test3)

- ✅ **RTL Compilation**: All Verilog files compile cleanly with `iverilog`**Purpose**: Validate fundamental SDC promotion functionality

- ✅ **SDC Promotion**: Constraints promote correctly to top-level

- ✅ **Signal Mapping**: Hierarchical signal paths resolved accurately#### Test 1: Basic Single IP Promotion

- ✅ **Edge Case Handling**: Robust parsing of complex constraints- **Description**: Single IP block with simple signal mapping

- **Features**: Basic constraint promotion, signal connectivity

---- **Files**: 

  - `tests/test1/ip.v` - Simple IP with input/output ports

## Test 9: Complex Processor Core  - `tests/test1/ip.sdc` - Basic timing constraints

**File**: `tests/test9/`  - `tests/test1/top.v` - Top-level wrapper

- **Expected Output**: `runs/test1_top_promoted.sdc`

### Description

Tests promotion of constraints from a complex processor core with pathological Design Compiler output formatting.#### Test 2: Multiple IPs with Vector Signals

- **Description**: Complex IP with vector signals and multiple constraint types

### Key Features- **Features**: Vector signal handling, complex constraint patterns

- **Complex IP**: Advanced processor with multiple clock domains- **Files**: 

- **Pathological Constraints**: Design Compiler generated constraints with unusual formatting  - `tests/test2/ip_complex.v` - IP with vector signals

- **Signal Tracing**: Complex hierarchical signal relationships  - `tests/test2/ip_complex.sdc` - Complex constraints

- **Escaped Identifiers**: Proper handling of Verilog escaped identifiers  - `tests/test2/top_complex.v` - Top-level with vector connections



### Files#### Test 3: Complex Timing Constraints

```- **Description**: Advanced timing constraints and signal relationships

tests/test9/- **Features**: Multi-clock domains, complex timing relationships

├── processor_core_v2_1_3.v  # Main processor IP with complex interface- **Files**: 

├── ip.sdc                   # Constraints with pathological formatting  - `tests/test3/ip_full.v` - Full-featured IP

└── top.v                    # Top-level instantiation  - `tests/test3/ip_full.sdc` - Comprehensive constraint set

```

### Multi-IP Scenarios (test4-test6)

### Test Focus**Purpose**: Validate multiple IP integration and advanced features

- Parsing Design Compiler pathological output

- Complex clock domain constraints#### Test 4: Wildcard Handling and Multiple IPs

- Signal path resolution through deep hierarchy- **Description**: Multiple IP blocks with wildcard signal matching

- Robust constraint promotion with unusual formatting- **Features**: Multiple IP promotion, wildcard constraints

- **Files**: 

### Usage  - `tests/test4/ip1.v`, `tests/test4/ip2.v` - Two different IPs

```bash  - `tests/test4/ip1.sdc`, `tests/test4/ip2.sdc` - Individual constraints

python3 scripts/promote_sdc.py \  - `tests/test4/top_two_ips.v` - Top-level with multiple instances

  --source_rtl tests/test9/processor_core_v2_1_3.v \

  --source_sdc tests/test9/ip.sdc \#### Test 5: Multi-Clock Domains

  --target_rtl tests/test9/top.v \- **Description**: Complex multi-clock domain design

  --target_sdc runs/test9_top_promoted.sdc \- **Features**: Clock domain crossing, complex signal mappings

  --instance u_processor_core_inst1 \- **Files**: 

  --debug  - `tests/test5/spi_ctrl.v`, `tests/test5/mem_ctrl.v` - Interface controllers

```  - `tests/test5/spi_ctrl.sdc`, `tests/test5/mem_ctrl.sdc` - Interface constraints

  - `tests/test5/soc_top.v` - SoC-level integration

---

#### Test 6: Enhanced Features

## Test 10: Unicode and Edge Cases  - **Description**: Connectivity analysis and initial SDC preservation

**File**: `tests/test10/`- **Features**: Enhanced connectivity, initial constraint preservation

- **Files**: Same as test5 plus:

### Description  - `tests/test6/initial_top.sdc` - Existing top-level constraints

Validates handling of unicode characters, special identifiers, and edge case constraint patterns.- **Special**: Uses `--initial_sdc` and `--ignored_dir` features



### Key Features### Edge Cases (test7-test11)

- **Unicode Support**: Signal names with unicode characters**Purpose**: Validate complex scenarios and edge cases

- **Special Characters**: Edge case identifier handling  

- **Boundary Conditions**: Testing parser limits and edge cases#### Test 7: Edge Cases (Complex Signals and Constraints)

- **Character Encoding**: Proper handling of various text encodings- **Description**: Complex signal patterns and constraint edge cases

- **Features**: Unusual signal names, complex constraint patterns

### Files

```#### Test 8: Clock Domain Crossing

tests/test10/- **Description**: CDC-specific constraint handling

├── unicode_edge_ip.v          # IP with unicode signal names- **Features**: False paths, clock group handling

├── unicode_edge_constraints.sdc # Constraints with special characters

└── top.v                      # Top-level wrapper#### Test 9: Advanced Multicycle Paths

```- **Description**: Complex multicycle path scenarios

- **Features**: Setup/hold multicycle paths, complex timing

### Test Focus

- Unicode character handling in signal names#### Test 10: Signal Mapping with Complex Hierarchies

- Special character parsing in constraints- **Description**: Deep hierarchy and complex signal mapping

- Edge case identifier patterns- **Features**: Hierarchical signal references, complex mappings

- Robust text processing

#### Test 11: Large-Scale Design with Many IPs

### Usage- **Description**: Stress testing with large constraint sets

```bash- **Features**: Performance validation, large-scale integration

python3 scripts/promote_sdc.py \

  --source_rtl tests/test10/unicode_edge_ip.v \### Advanced Scenarios (test12-test14)

  --source_sdc tests/test10/unicode_edge_constraints.sdc \**Purpose**: Validate SystemVerilog support and comprehensive integration

  --target_rtl tests/test10/top.v \

  --target_sdc runs/test10_top_promoted.sdc \#### Test 12: Wide Bus Interfaces

  --instance u_unicode_ip \- **Description**: Very wide bus interfaces and massive constraint sets

  --verbose- **Features**: Wide vector handling, performance testing

```- **Special**: Contains ~2000 constraints for stress testing



---#### Test 13: SystemVerilog Constructs

- **Description**: Advanced SystemVerilog language features

## Test 11: Malformed Constraint Recovery- **Features**: SystemVerilog syntax, packed arrays, interfaces

**File**: `tests/test11/`- **Tools**: Validates Yosys SystemVerilog parsing capabilities



### Description#### Test 14: Comprehensive Integration

Tests robust parsing and recovery from malformed SDC constraints and RTL syntax errors.- **Description**: Real-world comprehensive design scenario

- **Features**: Multiple clock domains, complex interfaces, full feature set

### Key Features

- **Error Recovery**: Graceful handling of malformed constraints## Test Execution

- **Partial Parsing**: Recovering valid constraints from broken files

- **Syntax Tolerance**: Robust parsing of imperfect input### Individual Tests

- **Error Reporting**: Clear reporting of parsing issues```bash

make test1        # Run single test

### Filesmake debug1       # Run with debug output

``````

tests/test11/

├── malformed_ip.v           # IP with corrected syntax### Batch Testing

├── malformed_constraints.sdc # SDC with error recovery patterns```bash

├── ip_fixed.v               # Additional IP variantmake test-all     # Run all tests

└── top.v                    # Top-level designmake validate-all # Run all tests with validation

``````



### Test Focus### Test Output Structure

- Malformed constraint parsing```

- Error recovery mechanisms  runs/

- Partial constraint promotion├── test1_top_promoted.sdc              # Promoted constraints

- Diagnostic error reporting├── test1_ip_inst_ignored_constraints.sdc # Ignored constraints

├── test1_validation.log                 # Validation log

### Usage└── ...

```bash```

python3 scripts/promote_sdc.py \

  --source_rtl tests/test11/malformed_ip.v \## Test Validation

  --source_sdc tests/test11/malformed_constraints.sdc \

  --target_rtl tests/test11/top.v \Each test includes automatic validation:

  --target_sdc runs/test11_top_promoted.sdc \

  --instance u_malformed_ip \1. **SDC Promotion**: Execute constraint promotion

  --debug2. **Yosys Validation**: Validate Verilog design integrity

```3. **SDC Validation**: Validate promoted constraint syntax

4. **Output Verification**: Check expected outputs

---

## Expected Results

## Test 12: Large-Scale Design

**File**: `tests/test12/`### Successful Test Output

```

### Description=== Test X: [Description] ===

Performance and scalability testing with large IP containing thousands of signals and constraints.[Promotion output with statistics]

Validating promoted SDC...

### Key FeaturesAvailable validation tools:

- **Scalability**: Large IP with thousands of signals  ✅ Yosys - Advanced Verilog parsing with SystemVerilog support

- **Performance**: Efficient processing of large constraint sets  ✅ OpenSTA - Basic timing validation (limited Verilog support)

- **Memory Management**: Optimized parsing for large files  ✅ Custom syntax validation - Always available

- **Complex Hierarchies**: Deep signal path resolution🎯 Recommended: Using Yosys for best validation coverage

✓ Test X completed successfully

### Files```

```

tests/test12/### Common Test Metrics

├── large_scale_ip.v           # Large IP with many signals- **Constraints Promoted**: Number of successfully promoted constraints

├── large_scale_constraints.sdc # Extensive constraint set- **Constraints Ignored**: Number of constraints that couldn't be promoted

└── top.v                      # Top-level design- **Validation Status**: Pass/fail for each validation step

```- **Processing Time**: Time taken for promotion and validation



### Test Focus## Troubleshooting Test Failures

- Large file processing performance

- Memory usage optimization### Common Issues

- Scalable parsing algorithms

- Complex signal relationship mapping1. **Missing Verilog Files**

   - **Error**: "Verilog file not found"

### Usage   - **Solution**: Check test file paths in `tests/testX/`

```bash

python3 scripts/promote_sdc.py \2. **Module Reference Errors**

  --source_rtl tests/test12/large_scale_ip.v \   - **Error**: "Module referenced in design is not part of the design"

  --source_sdc tests/test12/large_scale_constraints.sdc \   - **Solution**: Ensure all dependent modules are included

  --target_rtl tests/test12/top.v \

  --target_sdc runs/test12_top_promoted.sdc \3. **Validation Tool Missing**

  --instance u_large_scale_ip \   - **Error**: "Command 'yosys' not found"

  --verbose   - **Solution**: Install Yosys or accept custom validation fallback

```

4. **Constraint Syntax Errors**

---   - **Error**: "Invalid SDC syntax"

   - **Solution**: Check SDC file format and syntax

## Test 13: SystemVerilog to Verilog

**File**: `tests/test13/`### Debug Strategies



### Description1. **Use Debug Mode**: `make debug1` for detailed output

Tests promotion of constraints from SystemVerilog IPs that have been converted to Verilog.2. **Check Individual Components**: Run promotion and validation separately

3. **Validate Tools**: `make check-tools` to verify tool availability

### Key Features4. **Check File Paths**: Ensure all test files exist and are accessible

- **SystemVerilog Origins**: IPs originally designed in SystemVerilog

- **Verilog Conversion**: Converted to standard Verilog syntax## Adding New Tests

- **Feature Mapping**: SystemVerilog features mapped to Verilog equivalents

- **Constraint Adaptation**: SDCs adapted for Verilog namingTo add a new test case:



### Files1. **Create Test Directory**: `tests/testXX/`

```2. **Add Required Files**:

tests/test13/   - Verilog design files (`.v`)

├── systemverilog_ip.v         # SystemVerilog-to-Verilog converted IP   - SDC constraint files (`.sdc`)

├── systemverilog_constraints.sdc # Adapted constraints   - Optional: Initial SDC files

└── top.v                      # Standard Verilog top-level3. **Update Makefile**: Add new test target

```4. **Document**: Update this documentation



### Test Focus### Test Template

- SystemVerilog to Verilog constraint mapping```makefile

- Feature translation validationtestXX: $(RUN_DIR)

- Naming convention handling    @echo "=== Test XX: [Description] ==="

- Syntax compatibility testing    $(PYTHON) $(SCRIPT) \

        --source_rtl $(TEST_DIR)/testXX/[source].v \

### Usage        --source_sdc $(TEST_DIR)/testXX/[source].sdc \

```bash        --target_rtl $(TEST_DIR)/testXX/[target].v \

python3 scripts/promote_sdc.py \        --target_sdc $(RUN_DIR)/testXX_[output].sdc \

  --source_rtl tests/test13/systemverilog_ip.v \        --instance [instance_name]

  --source_sdc tests/test13/systemverilog_constraints.sdc \    @echo "Validating promoted SDC..."

  --target_rtl tests/test13/top.v \    $(PYTHON) $(VALIDATOR) $(RUN_DIR)/testXX_[output].sdc \

  --target_sdc runs/test13_top_promoted.sdc \        --check-tools --verilog-files [verilog_files]

  --instance u_systemverilog_ip \    @echo "✓ Test XX completed successfully"

  --debug```

```

## Performance Benchmarks

---

| Test | Constraints | Promotion Time | Validation Time | Total Time |

## Test 14: Comprehensive Multi-Domain Design|------|-------------|----------------|-----------------|------------|

**File**: `tests/test14/`| test1 | 6 | <1s | <1s | <2s |

| test4 | 44 | <1s | <1s | <2s |

### Description| test12 | 218 | ~2s | ~1s | ~3s |

Complete end-to-end test with comprehensive IP featuring multiple clock domains, complex interfaces, and extensive constraint sets.| test14 | 42 | <1s | <1s | <2s |



### Key Features*Times are approximate and depend on system performance*
- **Multi-Domain**: Multiple independent clock domains
- **Complex Interfaces**: Advanced signal interfaces and protocols
- **Comprehensive Constraints**: Full spectrum of SDC constraint types
- **Real-World Scenario**: Realistic SoC integration scenario

### Files
```
tests/test14/
├── comprehensive_ip.v    # Full-featured IP design
├── comprehensive_ip.sdc  # Complete constraint set
└── top.v                 # Comprehensive top-level
```

### Test Focus
- Complete constraint type coverage
- Multi-domain signal promotion
- Complex interface handling
- End-to-end validation

### Usage
```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test14/comprehensive_ip.v \
  --source_sdc tests/test14/comprehensive_ip.sdc \
  --target_rtl tests/test14/top.v \
  --target_sdc runs/test14_top_promoted.sdc \
  --instance u_comprehensive_ip \
  --verbose
```

---

## Legacy Test Suite (Tests 1-8)

Tests 1-8 provide basic functionality validation but are not actively maintained. They cover:

- **test1**: Basic single IP promotion
- **test2**: Complex IP with vector signals  
- **test3**: Advanced timing constraints
- **test4**: Multiple IP integration
- **test5**: Multi-clock domain designs
- **test6**: Initial top-level SDC merging
- **test7**: Wildcard constraint handling
- **test8**: Advanced signal mapping

These tests remain available for compatibility but **tests 9-14** represent the current validation suite.

---

## Running the Test Suite

### Individual Test Execution
```bash
# Test RTL compilation
iverilog -o /tmp/test9 tests/test9/*.v

# Test SDC promotion  
python3 scripts/promote_sdc.py \
  --source_rtl tests/test9/processor_core_v2_1_3.v \
  --source_sdc tests/test9/ip.sdc \
  --target_rtl tests/test9/top.v \
  --target_sdc /tmp/test9.sdc \
  --instance u_processor_core_inst1
```

### Batch Testing
```bash
# Test all active cases (9-14)
for i in {9..14}; do
  echo "=== Testing test$i ==="
  iverilog -o /tmp/test${i} tests/test${i}/*.v && echo "✓ RTL PASS" || echo "✗ RTL FAIL"
done
```

### Validation Checklist

For each test case, verify:
- ✅ **RTL Compilation**: `iverilog` compiles without errors
- ✅ **SDC Parsing**: Tool parses SDC files without critical errors  
- ✅ **Constraint Promotion**: Expected constraints appear in output
- ✅ **Signal Mapping**: Hierarchical paths resolved correctly
- ✅ **Output Quality**: Promoted SDC is syntactically valid

## Test Results Analysis

### Expected Outputs
Each test generates:
- **Promoted SDC**: `runs/test{N}_top_promoted.sdc`
- **Debug Log**: `runs/debug.log` (if `--debug` enabled)
- **Signal Mappings**: `runs/mappings.txt` (if `--debug` enabled)  
- **Ignored Constraints**: `runs/{instance}_ignored_constraints.sdc`

### Success Criteria
- **Constraint Count**: Appropriate number of constraints promoted
- **Signal Resolution**: All promoted signals resolve to valid top-level paths
- **Syntax Validity**: Output SDC is syntactically correct
- **Coverage**: Key constraint types successfully promoted

### Common Issues
- **No Constraints Promoted**: Check signal connectivity and instance names
- **Parsing Errors**: Verify RTL syntax and SDC format
- **Missing Signals**: Ensure IP ports connect to top-level I/O

---

## Contributing New Test Cases

### Test Case Structure
```
tests/test{N}/
├── {ip_name}.v      # IP Verilog file
├── {ip_name}.sdc    # IP constraint file  
└── top.v            # Top-level instantiation
```

### Requirements
1. **RTL Validity**: Must compile with `iverilog`
2. **SDC Validity**: Must be syntactically correct SDC
3. **Signal Connectivity**: IP signals must connect to top-level I/O
4. **Documentation**: Include test purpose and expected behavior
5. **Naming Convention**: Use descriptive, consistent naming

### Validation Steps
1. Verify RTL compilation: `iverilog -t null test{N}/*.v`
2. Test SDC promotion with utility
3. Validate promoted constraints manually
4. Add to automated test suite
5. Update documentation