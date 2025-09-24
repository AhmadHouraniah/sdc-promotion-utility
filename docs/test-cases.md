# Test Cases

This project includes 14 test cases demonstrating promotion across simple, complex, multi-IP, edge, and large-scale scenarios. Use the `Makefile` to run them quickly.

## How to Run

```bash
# Run everything (validation off by default)
make test-all

# Run specific tests
make test1
make test4
make test9 VALIDATE=1   # enable validation for this run

# Clean generated outputs
make clean
```

Validation can be toggled per run using `VALIDATE=1`. The validator (`scripts/validate_sdc.py`) uses OpenSTA if available, otherwise performs syntax/consistency checks.

## Test Overview

- Tests 1–3: Basic single-IP promotion and vector handling
- Tests 4–6: Multiple IPs and combined promotion
- Tests 7–11: Edge cases (complex signals, malformed constraints, unicode, deep hierarchy)
- Tests 12–14: Performance, wide buses, SystemVerilog-origin designs, comprehensive integration

Below are representative examples aligned with the `Makefile` targets.

### Test 1: Basic single IP promotion

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test1/ip.v \
  --source_sdc tests/test1/ip.sdc \
  --target_rtl tests/test1/top.v \
  --target_sdc runs/test1_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

### Test 4: Multiple IP instances (combined)

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test4/ip1.v tests/test4/ip2.v \
  --source_sdc tests/test4/ip1.sdc tests/test4/ip2.sdc \
  --target_rtl tests/test4/top_two_ips.v \
  --target_sdc runs/test4_combined_promoted.sdc \
  --instance u_fifo u_alu \
  --ignored_dir runs
```

### Test 9: Advanced multicycle paths (complex mapping)

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test9/peripheral_controller_v1_4_2.v \
  --source_sdc tests/test9/ip.sdc \
  --target_rtl tests/test9/top.v \
  --target_sdc runs/test9_top_promoted.sdc \
  --instance u_peripheral_controller_inst1 \
  --ignored_dir runs
```

### Test 10: Unicode and special identifiers

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test10/unicode_edge_ip.v \
  --source_sdc tests/test10/unicode_edge_constraints.sdc \
  --target_rtl tests/test10/top.v \
  --target_sdc runs/test10_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

### Test 11: Malformed constraints handling

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test11/malformed_ip.v \
  --source_sdc tests/test11/malformed_constraints.sdc \
  --target_rtl tests/test11/top.v \
  --target_sdc runs/test11_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

### Test 12: Large-scale design with wide buses

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test12/large_scale_ip.v \
  --source_sdc tests/test12/large_scale_constraints.sdc \
  --target_rtl tests/test12/top.v \
  --target_sdc runs/test12_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

### Test 13: SystemVerilog constructs

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test13/systemverilog_ip.v \
  --source_sdc tests/test13/systemverilog_constraints.sdc \
  --target_rtl tests/test13/top.v \
  --target_sdc runs/test13_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

### Test 14: Comprehensive integration

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test14/comprehensive_ip.v \
  --source_sdc tests/test14/comprehensive_ip.sdc \
  --target_rtl tests/test14/top.v \
  --target_sdc runs/test14_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs
```

## Validation

Enable validation with `VALIDATE=1` to run `scripts/validate_sdc.py` after promotion. It will use OpenSTA when available (for .v netlists) or perform syntax/consistency checks otherwise. Check available tools:

```bash
python3 scripts/validate_sdc.py --check-tools
```

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