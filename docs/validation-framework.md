# Validation Framework

This describes how to verify promoted SDCs using `scripts/validate_sdc.py`. Validation is optional in the `Makefile` and can be enabled per test with `VALIDATE=1`.

## What the validator does

The validator tries the best available method:

1. OpenSTA-backed validation (if the `sta` binary is found)
   - Reads the provided Verilog, links the design, then executes each SDC line inside OpenSTA and reports errors/warnings.
   - Saves an `*_opensta.log` next to the validated SDC for inspection.
2. Syntax/consistency validation (fallback when OpenSTA is not available)
   - Checks SDC syntax patterns, required flags (e.g., `-clock` for delays), balanced braces/brackets/quotes, undefined clock usage, etc.

The script picks OpenSTA when possible; otherwise, it runs the internal checks. Both modes print a summary and return a non-zero exit code on failure.

## Quick checks

```bash
# See which validators are available on your machine
python3 scripts/validate_sdc.py --check-tools
```

## Validating files

Validate a single SDC with design context:

```bash
python3 scripts/validate_sdc.py runs/test4_combined_promoted.sdc --verilog tests/test4/top_two_ips.v --verbose
```

Both input and output SDCs can be checked if you pass `--output-sdc`.

## Makefile integration

Each `make testX` target can run validation when `VALIDATE=1` is set. Example:

```bash
make test9 VALIDATE=1
```

Behind the scenes, the `Makefile` invokes:

```bash
python3 scripts/validate_sdc.py runs/test9_top_promoted.sdc --verilog tests/test9/top.v
```

## Interpreting results

- Success: “All SDC files are valid” or “SUCCESS: SDC file is valid” (OpenSTA mode)
- Failure: The script prints errors. In OpenSTA mode, also inspect the generated `*_opensta.log` for precise failing lines.
- Warnings: Not fatal by default but worth reviewing (e.g., undefined clocks or unreferenced clocks).

## Tips

- Prefer validating synthesized/netlist-style Verilog with OpenSTA.
- If OpenSTA is unavailable, syntax validation still catches many issues.
- Use `--verbose` during development for more context.