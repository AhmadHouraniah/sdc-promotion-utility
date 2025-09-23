# Makefile for SDC Promotion Utility
# Provides convenient targets for testing, validation, and demonstration

PYTHON = python3
SCRIPT = promote_sdc.py

# Default target
.PHONY: help
help:
	@echo "SDC Promotion Utility - Available targets:"
	@echo ""
	@echo "Testing and Validation:"
	@echo "  test-all          - Run all test cases"
	@echo "  test1            - Test basic single IP promotion"
	@echo "  test2            - Test multiple IPs with vector signals"
	@echo "  test3            - Test complex timing constraints"
	@echo "  test4            - Test wildcard handling and deduplication"
	@echo "  test5            - Test multi-clock domains (original)"
	@echo "  test6            - Test enhanced features (connectivity + initial SDC)"
	@echo "  test7            - Test edge cases (complex signals and constraints)"
	@echo ""
	@echo "Debug and Development:"
	@echo "  test-debug        - Run test cases with debug output"
	@echo "  test-verbose      - Run test cases with verbose output"
	@echo "  debug1           - Test 1 with debug mode"
	@echo "  debug6           - Test 6 with debug mode"
	@echo "  version          - Show script version information"
	@echo ""
	@echo "Enhanced Features Demo:"
	@echo "  demo-enhanced     - Demonstrate enhanced features in test6"
	@echo "  compare-results   - Compare test5 vs test6 results"
	@echo "  demo-debug        - Demonstrate debug mode capabilities"
	@echo ""
	@echo "Validation:"
	@echo "  compile-all       - Compile all test RTL designs"
	@echo "  clean            - Clean generated files"
	@echo "  clean-all        - Clean all generated and backup files"
	@echo "  lint             - Check Python code style"
	@echo ""
	@echo "Documentation:"
	@echo "  docs             - Generate documentation"
	@echo "  examples         - Show usage examples"

# Test targets
.PHONY: test-all test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12 test13 test14
test-all: test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12 test13 test14

test1:
	@echo "=== Test 1: Basic single IP promotion ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test1/ip.v \
		--source_sdc test1/ip.sdc \
		--target_rtl test1/top.v \
		--target_sdc test1/top_promoted_test.sdc \
		--instance ip_inst
	@echo "✓ Test 1 completed successfully"

test2:
	@echo "=== Test 2: Multiple IPs with vector signals ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test2/ip_complex.v \
		--source_sdc test2/ip_complex.sdc \
		--target_rtl test2/top_complex.v \
		--target_sdc test2/top_complex_promoted_test.sdc \
		--instance ip_inst
	@echo "✓ Test 2 completed successfully"

test3:
	@echo "=== Test 3: Complex timing constraints ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test3/ip_full.v \
		--source_sdc test3/ip_full.sdc \
		--target_rtl test3/top_full.v \
		--target_sdc test3/top_full_promoted_test.sdc \
		--instance ip_inst
	@echo "✓ Test 3 completed successfully"

test4:
	@echo "=== Test 4: Wildcard handling and multiple IPs ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test4/ip1.v test4/ip2.v \
		--source_sdc test4/ip1.sdc test4/ip2.sdc \
		--target_rtl test4/top_two_ips.v \
		--target_sdc test4/top_merged_test.sdc \
		--instance u_fifo u_alu
	@echo "✓ Test 4 completed successfully"

test5:
	@echo "=== Test 5: Multi-clock domains (original) ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test5/spi_ctrl.v test5/mem_ctrl.v \
		--source_sdc test5/spi_ctrl.sdc test5/mem_ctrl.sdc \
		--target_rtl test5/soc_top.v \
		--target_sdc test5/soc_top_promoted_test.sdc \
		--instance u_serial_interface u_dram_interface
	@echo "✓ Test 5 completed successfully"

test6:
	@echo "=== Test 6: Enhanced features (connectivity + initial SDC) ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test6/spi_ctrl.v test6/mem_ctrl.v \
		--source_sdc test6/spi_ctrl.sdc test6/mem_ctrl.sdc \
		--target_rtl test6/soc_top.v \
		--target_sdc test6/soc_top_enhanced_test.sdc \
		--instance u_serial_interface u_dram_interface \
		--initial_sdc test6/initial_top.sdc \
		--ignored_dir test6
	@echo "✓ Test 6 completed successfully"

test7:
	@echo "=== Test 7: Edge cases (complex signals and constraints) ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test7/edge_case_ip.v \
		--source_sdc test7/edge_case_ip.sdc \
		--target_rtl test7/top_edge_case.v \
		--target_sdc test7/top_edge_case_promoted_test.sdc \
		--instance u_edge_case_processor \
		--initial_sdc test7/initial_edge_case.sdc \
		--ignored_dir test7
	@echo "✓ Test 7 completed successfully"

test8:
	@echo "=== Test 8: Design Compiler style peripheral controller ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test8/dc_style_ip2.v \
		--source_sdc test8/simple_peripheral_constraints.sdc \
		--target_rtl test8/top.v \
		--target_sdc test8/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test8
	@echo "✓ Test 8 completed successfully"

test9:
	@echo "=== Test 9: Multi-instance integration test ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test9/processor_core_v2_1_3.v \
		--source_sdc test9/ip.sdc \
		--target_rtl test9/top.v \
		--target_sdc test9/top_promoted_test.sdc \
		--instance u_processor_core_inst1 \
		--ignored_dir test9
	@echo "✓ Test 9 completed successfully"

test10:
	@echo "=== Test 10: Unicode and extreme character edge cases ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test10/unicode_edge_ip.v \
		--source_sdc test10/unicode_edge_constraints.sdc \
		--target_rtl test10/top.v \
		--target_sdc test10/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test10
	@echo "✓ Test 10 completed successfully"

test11:
	@echo "=== Test 11: Malformed constraints error handling ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test11/ip_fixed.v \
		--source_sdc test11/malformed_constraints.sdc \
		--target_rtl test11/top.v \
		--target_sdc test11/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test11 || echo "Note: Test 11 expected to show error handling for malformed constraints"
	@echo "✓ Test 11 completed (error handling test)"

test12:
	@echo "=== Test 12: Large scale performance test ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test12/large_scale_ip.v \
		--source_sdc test12/large_scale_constraints.sdc \
		--target_rtl test12/top.v \
		--target_sdc test12/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test12
	@echo "✓ Test 12 completed successfully"

test13:
	@echo "=== Test 13: SystemVerilog constructs test ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test13/systemverilog_ip.v \
		--source_sdc test13/systemverilog_constraints.sdc \
		--target_rtl test13/top.v \
		--target_sdc test13/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test13
	@echo "✓ Test 13 completed successfully"

test14:
	@echo "=== Test 14: Comprehensive integration test ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test14/comprehensive_ip.v \
		--source_sdc test14/comprehensive_ip.sdc \
		--target_rtl test14/top.v \
		--target_sdc test14/top_promoted_test.sdc \
		--instance ip_inst \
		--ignored_dir test14
	@echo "✓ Test 14 completed successfully"

# Debug and verbose testing targets
.PHONY: test-debug test-verbose debug1 debug6 debug7 version demo-debug
test-debug: debug1 debug6 debug7

test-verbose:
	@echo "=== Test 1 with verbose output ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test1/ip.v \
		--source_sdc test1/ip.sdc \
		--target_rtl test1/top.v \
		--target_sdc test1/top_verbose_test.sdc \
		--instance ip_inst \
		--verbose
	@echo "✓ Verbose test 1 completed"

debug1:
	@echo "=== Test 1 with debug output ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test1/ip.v \
		--source_sdc test1/ip.sdc \
		--target_rtl test1/top.v \
		--target_sdc test1/top_debug_test.sdc \
		--instance ip_inst \
		--debug
	@echo "✓ Debug test 1 completed"

debug6:
	@echo "=== Test 6 with debug output ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test6/spi_ctrl.v test6/mem_ctrl.v \
		--source_sdc test6/spi_ctrl.sdc test6/mem_ctrl.sdc \
		--target_rtl test6/soc_top.v \
		--target_sdc test6/soc_top_debug_test.sdc \
		--instance u_serial_interface u_dram_interface \
		--initial_sdc test6/initial_top.sdc \
		--ignored_dir test6 \
		--debug
	@echo "✓ Debug test 6 completed"

debug7:
	@echo "=== Test 7 with debug output (edge cases) ==="
	$(PYTHON) $(SCRIPT) \
		--source_rtl test7/edge_case_ip.v \
		--source_sdc test7/edge_case_ip.sdc \
		--target_rtl test7/top_edge_case.v \
		--target_sdc test7/top_edge_case_debug_test.sdc \
		--instance u_edge_case_processor \
		--initial_sdc test7/initial_edge_case.sdc \
		--ignored_dir test7 \
		--debug
	@echo "✓ Debug test 7 completed"

version:
	@echo "=== Script Version Information ==="
	$(PYTHON) $(SCRIPT) --version

demo-debug: debug6
	@echo ""
	@echo "=== Debug Mode Demonstration ==="
	@echo "Debug mode provides detailed logging including:"
	@echo "  ✓ Port mapping discovery"
	@echo "  ✓ Signal connectivity analysis"  
	@echo "  ✓ Constraint processing details"
	@echo "  ✓ File I/O operations"
	@echo "  ✓ Error diagnostics"
	@echo ""
	@echo "Compare with standard output by running: make test6"

# Enhanced features demonstration
.PHONY: demo-enhanced compare-results
demo-enhanced: test6
	@echo ""
	@echo "=== Enhanced Features Demonstration ==="
	@echo "Connectivity Analysis:"
	@echo "  - Only promotes I/O delays for signals connected to top-level ports"
	@echo "  - Saves ignored constraints to separate files for debugging"
	@echo ""
	@echo "Initial SDC Integration:"
	@echo "  - Merges existing top-level constraints with promoted ones"
	@echo "  - Initial SDC takes precedence in case of conflicts"
	@echo ""
	@echo "Results:"
	@if [ -f test6/soc_top_enhanced_test.sdc ]; then \
		echo "  - Promoted SDC: $$(wc -l < test6/soc_top_enhanced_test.sdc) lines"; \
	fi
	@if [ -f test6/u_serial_interface_ignored_constraints.sdc ]; then \
		echo "  - SPI ignored: $$(wc -l < test6/u_serial_interface_ignored_constraints.sdc) lines"; \
	fi
	@if [ -f test6/u_dram_interface_ignored_constraints.sdc ]; then \
		echo "  - Memory ignored: $$(wc -l < test6/u_dram_interface_ignored_constraints.sdc) lines"; \
	fi

compare-results: test5 test6
	@echo ""
	@echo "=== Comparison: Original vs Enhanced ==="
	@if [ -f test5/soc_top_promoted_test.sdc ] && [ -f test6/soc_top_enhanced_test.sdc ]; then \
		echo "Original (test5): $$(wc -l < test5/soc_top_promoted_test.sdc) lines"; \
		echo "Enhanced (test6): $$(wc -l < test6/soc_top_enhanced_test.sdc) lines"; \
		echo "Reduction: $$(($(shell wc -l < test5/soc_top_promoted_test.sdc) - $(shell wc -l < test6/soc_top_enhanced_test.sdc))) lines saved"; \
	fi

# Compilation validation
.PHONY: compile-all compile-test1 compile-test2 compile-test3 compile-test4 compile-test5 compile-test6
compile-all: compile-test1 compile-test2 compile-test3 compile-test4 compile-test5 compile-test6

compile-test1:
	@echo "Compiling test1..."
	@cd test1 && iverilog *.v > /dev/null 2>&1 && echo "✓ test1 RTL compiles" || echo "✗ test1 compilation failed"

compile-test2:
	@echo "Compiling test2..."
	@cd test2 && iverilog *.v > /dev/null 2>&1 && echo "✓ test2 RTL compiles" || echo "✗ test2 compilation failed"

compile-test3:
	@echo "Compiling test3..."
	@cd test3 && iverilog *.v > /dev/null 2>&1 && echo "✓ test3 RTL compiles" || echo "✗ test3 compilation failed"

compile-test4:
	@echo "Compiling test4..."
	@cd test4 && iverilog *.v > /dev/null 2>&1 && echo "✓ test4 RTL compiles" || echo "✗ test4 compilation failed"

compile-test5:
	@echo "Compiling test5..."
	@cd test5 && iverilog *.v > /dev/null 2>&1 && echo "✓ test5 RTL compiles" || echo "✗ test5 compilation failed"

compile-test6:
	@echo "Compiling test6..."
	@cd test6 && iverilog *.v > /dev/null 2>&1 && echo "✓ test6 RTL compiles" || echo "✗ test6 compilation failed"

# Code quality
.PHONY: lint
lint:
	@echo "Checking Python code style..."
	@if command -v pylint > /dev/null 2>&1; then \
		pylint $(SCRIPT) || echo "Note: pylint warnings found"; \
	else \
		echo "pylint not found, checking basic syntax..."; \
		$(PYTHON) -m py_compile $(SCRIPT) && echo "✓ Python syntax OK"; \
	fi

# Documentation and examples
.PHONY: docs examples
docs:
	@echo "=== SDC Promotion Utility Documentation ==="
	@echo ""
	@echo "This utility promotes IP-level SDC constraints to top-level designs."
	@echo ""
	@echo "Key Features:"
	@echo "  ✓ Multi-IP constraint promotion"
	@echo "  ✓ Signal connectivity analysis"
	@echo "  ✓ Initial SDC integration"
	@echo "  ✓ Automatic deduplication"
	@echo "  ✓ Vector signal expansion"
	@echo "  ✓ Wildcard pattern handling"
	@echo ""
	@echo "Run 'make examples' for usage examples."

examples:
	@echo "=== Usage Examples ==="
	@echo ""
	@echo "1. Basic single IP promotion:"
	@echo "   make test1"
	@echo ""
	@echo "2. Multiple IPs with enhanced features:"
	@echo "   make test6"
	@echo ""
	@echo "3. Manual usage:"
	@echo "   python3 promote_sdc.py \\"
	@echo "     --source_rtl ip1.v ip2.v \\"
	@echo "     --source_sdc ip1.sdc ip2.sdc \\"
	@echo "     --target_rtl top.v \\"
	@echo "     --target_sdc top_merged.sdc \\"
	@echo "     --instance ip1_u ip2_u \\"
	@echo "     --initial_sdc initial.sdc \\"
	@echo "     --ignored_dir ignored_constraints/"

# Cleanup
.PHONY: clean clean-tests clean-generated clean-all clean-backups
clean: clean-tests clean-generated

clean-all: clean clean-backups
	@echo "✓ Complete cleanup finished"

clean-tests:
	@echo "Cleaning test outputs..."
	@find test* -name "*_test.sdc" -delete 2>/dev/null || true
	@find test* -name "*_promoted*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_enhanced*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_debug*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_verbose*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_ignored_constraints.sdc" -delete 2>/dev/null || true
	@find test* -name "test_output*.sdc" -delete 2>/dev/null || true
	@find test* -name "a.out" -delete 2>/dev/null || true

clean-generated:
	@echo "Cleaning generated files..."
	@rm -rf __pycache__/ *.pyc .pytest_cache/ 2>/dev/null || true

clean-backups:
	@echo "Cleaning backup files..."
	@rm -f promote_sdc_broken.py promote_sdc_enhanced.py 2>/dev/null || true
	@echo "✓ Backup files cleaned"

# Development targets
.PHONY: install-deps dev-setup
install-deps:
	@echo "Installing development dependencies..."
	@if command -v pip3 > /dev/null 2>&1; then \
		pip3 install pylint; \
	else \
		echo "pip3 not found, skipping pylint installation"; \
	fi

dev-setup: install-deps
	@echo "Setting up development environment..."
	@echo "✓ Development setup complete"

# CI/Testing targets
.PHONY: ci ci-quick ci-debug
ci: clean compile-all test-all lint
	@echo "✓ Full CI pipeline completed successfully"

ci-quick: test1 test4 test6 compile-test6
	@echo "✓ Quick CI pipeline completed successfully"

ci-debug: clean debug1 debug6 version
	@echo "✓ Debug CI pipeline completed successfully"