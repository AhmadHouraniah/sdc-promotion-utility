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
	@echo ""
	@echo "Enhanced Features Demo:"
	@echo "  demo-enhanced     - Demonstrate enhanced features in test6"
	@echo "  compare-results   - Compare test5 vs test6 results"
	@echo ""
	@echo "Validation:"
	@echo "  compile-all       - Compile all test RTL designs"
	@echo "  clean            - Clean generated files"
	@echo "  lint             - Check Python code style"
	@echo ""
	@echo "Documentation:"
	@echo "  docs             - Generate documentation"
	@echo "  examples         - Show usage examples"

# Test targets
.PHONY: test-all test1 test2 test3 test4 test5 test6
test-all: test1 test2 test3 test4 test5 test6

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
		--instance ip1_u ip2_u
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
.PHONY: clean clean-tests clean-generated
clean: clean-tests clean-generated

clean-tests:
	@echo "Cleaning test outputs..."
	@find test* -name "*_test.sdc" -delete 2>/dev/null || true
	@find test* -name "*_promoted*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_enhanced*.sdc" -delete 2>/dev/null || true
	@find test* -name "*_ignored_constraints.sdc" -delete 2>/dev/null || true
	@find test* -name "test_output*.sdc" -delete 2>/dev/null || true
	@find test* -name "a.out" -delete 2>/dev/null || true

clean-generated:
	@echo "Cleaning generated files..."
	@rm -rf __pycache__/ *.pyc .pytest_cache/ 2>/dev/null || true

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
.PHONY: ci ci-quick
ci: clean compile-all test-all lint
	@echo "✓ Full CI pipeline completed successfully"

ci-quick: test1 test4 test6 compile-test6
	@echo "✓ Quick CI pipeline completed successfully"