# Makefile for SDC Promotion Utility
# Provides convenient targets for testing, validation, and demonstration

# Configuration
PYTHON = python3
SCRIPT = scripts/promote_sdc.py
VALIDATOR = scripts/validate_sdc.py
TEST_DIR = tests
RUN_DIR = runs

# Ensure run directory exists
$(RUN_DIR):
	@mkdir -p $(RUN_DIR)

# Tests 7-14 for edge cases and advanced scenarios
test7: $(RUN_DIR)
	@echo "=== Test 7: Edge Cases (Complex Signals and Constraints) ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test7/edge_case_ip.v \
		--source_sdc $(TEST_DIR)/test7/edge_case_ip.sdc \
		--target_rtl $(TEST_DIR)/test7/top_edge_case.v \
		--target_sdc $(RUN_DIR)/test7_top_promoted.sdc \
		--instance u_edge_case_processor \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test7_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test7/top_edge_case.v $(TEST_DIR)/test7/edge_case_ip.v
	@echo "✓ Test 7 completed successfully"

test8: $(RUN_DIR)
	@echo "=== Test 8: Clock Domain Crossing ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test8/dc_style_ip2.v \
		--source_sdc $(TEST_DIR)/test8/simple_peripheral_constraints.sdc \
		--target_rtl $(TEST_DIR)/test8/top.v \
		--target_sdc $(RUN_DIR)/test8_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test8_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test8/top.v $(TEST_DIR)/test8/dc_style_ip2.v
	@echo "✓ Test 8 completed successfully"

test9: $(RUN_DIR)
	@echo "=== Test 9: Advanced Multicycle Paths ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test9/peripheral_controller_v1_4_2.v \
		--source_sdc $(TEST_DIR)/test9/ip.sdc \
		--target_rtl $(TEST_DIR)/test9/top.v \
		--target_sdc $(RUN_DIR)/test9_top_promoted.sdc \
		--instance u_peripheral_controller_inst1 \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test9_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test9/top.v $(TEST_DIR)/test9/peripheral_controller_v1_4_2.v
	@echo "✓ Test 9 completed successfully"

test10: $(RUN_DIR)
	@echo "=== Test 10: Signal Mapping with Complex Hierarchies ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test10/unicode_edge_ip.v \
		--source_sdc $(TEST_DIR)/test10/unicode_edge_constraints.sdc \
		--target_rtl $(TEST_DIR)/test10/top.v \
		--target_sdc $(RUN_DIR)/test10_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test10_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test10/top.v $(TEST_DIR)/test10/unicode_edge_ip.v
	@echo "✓ Test 10 completed successfully"

test11: $(RUN_DIR)
	@echo "=== Test 11: Malformed Constraints Handling ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test11/malformed_ip.v \
		--source_sdc $(TEST_DIR)/test11/malformed_constraints.sdc \
		--target_rtl $(TEST_DIR)/test11/top.v \
		--target_sdc $(RUN_DIR)/test11_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test11_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test11/top.v $(TEST_DIR)/test11/malformed_ip.v
	@echo "✓ Test 11 completed successfully"

test12: $(RUN_DIR)
	@echo "=== Test 12: Large-Scale Design with Wide Buses ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test12/large_scale_ip.v \
		--source_sdc $(TEST_DIR)/test12/large_scale_constraints.sdc \
		--target_rtl $(TEST_DIR)/test12/top.v \
		--target_sdc $(RUN_DIR)/test12_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test12_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test12/top.v $(TEST_DIR)/test12/large_scale_ip.v
	@echo "✓ Test 12 completed successfully"

test13: $(RUN_DIR)
	@echo "=== Test 13: SystemVerilog Constructs ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test13/systemverilog_ip.v \
		--source_sdc $(TEST_DIR)/test13/systemverilog_constraints.sdc \
		--target_rtl $(TEST_DIR)/test13/top.v \
		--target_sdc $(RUN_DIR)/test13_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test13_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test13/top.v $(TEST_DIR)/test13/systemverilog_ip.v
	@echo "✓ Test 13 completed successfully"

test14: $(RUN_DIR)
	@echo "=== Test 14: Comprehensive Integration ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test14/comprehensive_ip.v \
		--source_sdc $(TEST_DIR)/test14/comprehensive_ip.sdc \
		--target_rtl $(TEST_DIR)/test14/top.v \
		--target_sdc $(RUN_DIR)/test14_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test14_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test14/top.v $(TEST_DIR)/test14/comprehensive_ip.v
	@echo "✓ Test 14 completed successfully"

# Default target
.PHONY: help
help:
	@echo "========================================================"
	@echo "           SDC Promotion Utility"
	@echo "========================================================"
	@echo ""
	@echo "🧪 Testing and Validation:"
	@echo "  test-all          - Run all test cases (1-14)"
	@echo "  test1-test14      - Run individual test cases"
	@echo "  validate-all      - Validate all test cases with Yosys/custom validation"
	@echo "  clean-runs        - Clean all generated files in runs/"
	@echo ""
	@echo "🔧 Development and Debug:"
	@echo "  test-debug        - Run test cases with debug output"
	@echo "  test-verbose      - Run test cases with verbose output"  
	@echo "  debug1, debug6    - Individual tests with debug mode"
	@echo "  version           - Show script version information"
	@echo ""
	@echo "📊 Analysis and Demo:"
	@echo "  demo-enhanced     - Demonstrate enhanced features"
	@echo "  compare-results   - Compare test results"
	@echo "  check-tools       - Check available validation tools"
	@echo ""
	@echo "🏗️  Project Management:"
	@echo "  clean            - Clean generated files"
	@echo "  clean-all        - Clean all generated and backup files"
	@echo "  lint             - Check Python code style"
	@echo ""
	@echo "Directory Structure:"
	@echo "  scripts/         - Main Python scripts"
	@echo "  tests/           - Test cases (test1-test14)"
	@echo "  runs/            - Generated files and outputs"
	@echo "  docs/            - Documentation"
	@echo "========================================================"

# Test targets
.PHONY: test-all test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12 test13 test14
test-all: $(RUN_DIR) test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12 test13 test14

test1: $(RUN_DIR)
	@echo "=== Test 1: Basic single IP promotion ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test1/ip.v \
		--source_sdc $(TEST_DIR)/test1/ip.sdc \
		--target_rtl $(TEST_DIR)/test1/top.v \
		--target_sdc $(RUN_DIR)/test1_top_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test1_top_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test1/top.v $(TEST_DIR)/test1/ip.v
	@echo "✓ Test 1 completed successfully"

test2: $(RUN_DIR)
	@echo "=== Test 2: Complex nested modules ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test2/ip_complex.v \
		--source_sdc $(TEST_DIR)/test2/ip_complex.sdc \
		--target_rtl $(TEST_DIR)/test2/top_complex.v \
		--target_sdc $(RUN_DIR)/test2_top_complex_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test2_top_complex_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test2/top_complex.v $(TEST_DIR)/test2/ip_complex.v
	@echo "✓ Test 2 completed successfully"

test3: $(RUN_DIR)
	@echo "=== Test 3: Full design constraints ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test3/ip_full.v \
		--source_sdc $(TEST_DIR)/test3/ip_full.sdc \
		--target_rtl $(TEST_DIR)/test3/top_full.v \
		--target_sdc $(RUN_DIR)/test3_top_full_promoted.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDC..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test3_top_full_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test3/top_full.v $(TEST_DIR)/test3/ip_full.v
	@echo "✓ Test 3 completed successfully"

test4: $(RUN_DIR)
	@echo "=== Test 4: Multiple IP instances ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test4/ip1.v \
		--source_sdc $(TEST_DIR)/test4/ip1.sdc \
		--target_rtl $(TEST_DIR)/test4/top_two_ips.v \
		--target_sdc $(RUN_DIR)/test4_ip1_promoted.sdc \
		--instance u_fifo \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test4/ip2.v \
		--source_sdc $(TEST_DIR)/test4/ip2.sdc \
		--target_rtl $(TEST_DIR)/test4/top_two_ips.v \
		--target_sdc $(RUN_DIR)/test4_ip2_promoted.sdc \
		--instance u_alu \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDCs..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test4_ip1_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test4/top_two_ips.v $(TEST_DIR)/test4/ip1.v
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test4_ip2_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test4/top_two_ips.v $(TEST_DIR)/test4/ip2.v
	@echo "✓ Test 4 completed successfully"

test5: $(RUN_DIR)
	@echo "=== Test 5: SOC memory controller ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test5/mem_ctrl.v \
		--source_sdc $(TEST_DIR)/test5/mem_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test5/soc_top.v \
		--target_sdc $(RUN_DIR)/test5_mem_promoted.sdc \
		--instance u_dram_interface \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test5/spi_ctrl.v \
		--source_sdc $(TEST_DIR)/test5/spi_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test5/soc_top.v \
		--target_sdc $(RUN_DIR)/test5_spi_promoted.sdc \
		--instance u_serial_interface \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDCs..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test5_mem_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test5/soc_top.v $(TEST_DIR)/test5/mem_ctrl.v
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test5_spi_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test5/soc_top.v $(TEST_DIR)/test5/spi_ctrl.v
	@echo "✓ Test 5 completed successfully"

test6: $(RUN_DIR)
	@echo "=== Test 6: Complex SOC with existing constraints ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/mem_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/mem_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_mem_promoted.sdc \
		--instance u_dram_interface \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/spi_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/spi_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_spi_promoted.sdc \
		--instance u_serial_interface \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDCs..."
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test6_mem_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/mem_ctrl.v
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test6_spi_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/spi_ctrl.v
	@echo "✓ Test 6 completed successfully"

# Specific module tests for test5 and test6 components
	@echo "=== Test 6: Complex SOC with existing constraints ==="
	python3 $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/mem_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/mem_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_mem_promoted.sdc \
		--instance u_dram_interface \
		--ignored_dir $(RUN_DIR)
	python3 $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/spi_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/spi_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_spi_promoted.sdc \
		--instance u_serial_interface \
		--ignored_dir $(RUN_DIR)
	@echo "Validating promoted SDCs..."
	python3 scripts/validate_sdc.py $(RUN_DIR)/test6_mem_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/mem_ctrl.v
	python3 scripts/validate_sdc.py $(RUN_DIR)/test6_spi_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/spi_ctrl.v
	@echo "✓ Test 6 completed successfully"

# Specific module tests
test-soc5-mem: $(RUN_DIR)
	@echo "=== Test 5 Memory Controller Only ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test5/mem_ctrl.v \
		--source_sdc $(TEST_DIR)/test5/mem_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test5/soc_top.v \
		--target_sdc $(RUN_DIR)/test5_mem_promoted.sdc \
		--instance mem_ctrl_inst \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test5_mem_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test5/soc_top.v $(TEST_DIR)/test5/mem_ctrl.v

test-soc5-spi: $(RUN_DIR)
	@echo "=== Test 5 SPI Controller Only ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test5/spi_ctrl.v \
		--source_sdc $(TEST_DIR)/test5/spi_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test5/soc_top.v \
		--target_sdc $(RUN_DIR)/test5_spi_promoted.sdc \
		--instance spi_ctrl_inst \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test5_spi_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test5/soc_top.v $(TEST_DIR)/test5/spi_ctrl.v

test-soc6-mem: $(RUN_DIR)
	@echo "=== Test 6 Memory Controller Only ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/mem_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/mem_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_mem_promoted.sdc \
		--instance mem_ctrl_inst \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test6_mem_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/mem_ctrl.v

test-soc6-spi: $(RUN_DIR)
	@echo "=== Test 6 SPI Controller Only ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test6/spi_ctrl.v \
		--source_sdc $(TEST_DIR)/test6/spi_ctrl.sdc \
		--target_rtl $(TEST_DIR)/test6/soc_top.v \
		--target_sdc $(RUN_DIR)/test6_spi_promoted.sdc \
		--instance spi_ctrl_inst \
		--ignored_dir $(RUN_DIR)
	$(PYTHON) $(VALIDATOR) $(RUN_DIR)/test6_spi_promoted.sdc --check-tools --verilog-files $(TEST_DIR)/test6/soc_top.v $(TEST_DIR)/test6/spi_ctrl.v

# Development and debugging targets
.PHONY: debug
debug: $(RUN_DIR)
	@echo "🐛 Debug Test 1 with verbose output"
	$(PYTHON) $(SCRIPT) \
		--source_rtl $(TEST_DIR)/test1/ip.v \
		--source_sdc $(TEST_DIR)/test1/ip.sdc \
		--target_rtl $(TEST_DIR)/test1/top.v \
		--target_sdc $(RUN_DIR)/test1_debug.sdc \
		--instance ip_inst \
		--ignored_dir $(RUN_DIR) \
		--debug

.PHONY: validate
validate:
	@echo "🔍 Validating tool availability..."
	$(PYTHON) $(VALIDATOR) --check-tools

.PHONY: clean
clean:
	@echo "🧹 Cleaning generated files..."
	rm -rf $(RUN_DIR)/*
	@echo "✓ Clean completed"

.PHONY: lint
lint:
	@echo "🔍 Linting Python scripts..."
	@python3 -m py_compile $(SCRIPT) && echo "✓ promote_sdc.py syntax OK" || echo "✗ promote_sdc.py has syntax errors"
	@python3 -m py_compile $(VALIDATOR) && echo "✓ validate_sdc.py syntax OK" || echo "✗ validate_sdc.py has syntax errors"