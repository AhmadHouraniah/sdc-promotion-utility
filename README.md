# SDC Promotion Utility

Promote SDC (Synopsys Design Constraints) from IP-level to top-level designs with correct signal mapping, vector support, and conflict-free merging.

## Overview

When integrating IPs into a SoC/FPGA top, each IP ships its own SDC. This utility promotes those constraints to the top-level by:

- Mapping IP ports to the actual top-level signals and hierarchy
- Handling vectors: wildcards (`signal[*]`), ranges (`signal[7:0]`), and indexed bits
- Respecting escaped identifiers (Verilog `\escaped_name`)
- Keeping input/output delays only for ports that truly reach top-level I/O (connectivity-aware)
- Merging with an existing top-level SDC (optional) and removing duplicates/conflicts
- Producing readable, formatted output plus per-instance “ignored” constraints for review

## Features

- Multi-IP promotion in a single run (`--source_rtl`, `--source_sdc`, `--instance` accept lists)
- Vector handling: wildcard, ranges, and bit-level expansion
- Escaped identifier support across parsing and mapping
- Connectivity analysis: promote I/O delays only when ports are connected to top-level
- Initial SDC merge with conflict avoidance (`--initial_sdc`)
- Intelligent de-duplication of conflicting constraints
- Useful artifacts in the chosen output directory (`--ignored_dir`):
  - `mappings.txt`: IP port → top-level signal mapping
  - `<instance>_ignored_constraints.sdc`: constraints skipped due to no top-level connectivity
  - `debug.log`, `warnings.log`: detailed traces and warnings

## Requirements

- Python `3.7+`
- No external Python packages are required
- Optional: OpenSTA (`sta`) if you want timing-tool-backed SDC validation using `scripts/validate_sdc.py`

## Quick Start

```bash
git clone https://github.com/AhmadHouraniah/sdc-promotion-utility.git
cd sdc-promotion-utility

# Run a simple example (Test 1)
python3 scripts/promote_sdc.py \
  --source_rtl tests/test1/ip.v \
  --source_sdc tests/test1/ip.sdc \
  --target_rtl tests/test1/top.v \
  --target_sdc runs/test1_top_promoted.sdc \
  --instance ip_inst \
  --ignored_dir runs

cat runs/test1_top_promoted.sdc
```

## CLI Usage

Basic form:

```bash
python3 scripts/promote_sdc.py \
  --source_rtl <ip1.v> [<ip2.v> ...] \
  --source_sdc <ip1.sdc> [<ip2.sdc> ...] \
  --target_rtl <top.v> \
  --target_sdc <output_top.sdc> \
  --instance <ip1_inst> [<ip2_inst> ...] \
  [--initial_sdc <existing_top.sdc>] \
  [--ignored_dir <dir>] \
  [--verbose] [--debug]
```

Examples:

- Single IP:

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test9/peripheral_controller_v1_4_2.v \
  --source_sdc tests/test9/ip.sdc \
  --target_rtl tests/test9/top.v \
  --target_sdc runs/test9_top_promoted.sdc \
  --instance u_peripheral_controller_inst1 \
  --ignored_dir runs \
  --verbose
```

- Multiple IPs in one go:

```bash
python3 scripts/promote_sdc.py \
  --source_rtl tests/test4/ip1.v tests/test4/ip2.v \
  --source_sdc tests/test4/ip1.sdc tests/test4/ip2.sdc \
  --target_rtl tests/test4/top_two_ips.v \
  --target_sdc runs/test4_combined_promoted.sdc \
  --instance u_fifo u_alu \
  --ignored_dir runs
```

- Merge with existing top-level SDC (initial takes precedence on conflicts):

```bash
python3 scripts/promote_sdc.py \
  --source_rtl ip.v \
  --source_sdc ip.sdc \
  --target_rtl top.v \
  --target_sdc runs/top_promoted.sdc \
  --instance ip_inst \
  --initial_sdc top_existing.sdc \
  --ignored_dir runs
```

## Outputs

- `--target_sdc`: promoted top-level SDC (de-duplicated and formatted)
- `--ignored_dir` directory contains:
  - `mappings.txt`: port-to-signal map used during promotion
  - `<instance>_ignored_constraints.sdc`: constraints skipped because ports aren’t connected to top-level I/O
  - `debug.log` and `warnings.log`: detailed traces (especially useful with `--debug`)

## Tests and Validation

- Run tests via the `Makefile` targets. Validation is optional and uses `scripts/validate_sdc.py`.

```bash
# Run all tests (validation off by default)
make test-all

# Run a specific test
make test4

# Enable validation (uses OpenSTA if available, otherwise syntax checks)
make test9 VALIDATE=1

# Clean generated run artifacts
make clean
```

Validation helper:

```bash
# Check available validation tools
python3 scripts/validate_sdc.py --check-tools
```

## Project Structure

```
sdc-promotion-utility/
├── scripts/
│   ├── promote_sdc.py         # Main SDC promotion tool
│   └── validate_sdc.py        # Optional validation helper (OpenSTA/syntax)
├── tests/                     # Test cases (1–14)
├── runs/                      # Generated outputs (created at runtime)
├── docs/                      # Documentation
├── Makefile                   # Handy test/validate targets
└── README.md
```

## License

This project is licensed under the MIT License. See `LICENSE` for details.