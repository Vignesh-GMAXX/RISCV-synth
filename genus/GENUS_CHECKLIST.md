# Genus Run Checklist

## Pre-run

- Confirm top module is `microprocessor`.
- Confirm constraints file exists: `design/microprocessor_genus.sdc`.
- Confirm RTL list exists: `genus/filelist_microprocessor.f`.
- Confirm library paths:
  - `LIB_MAX` points to valid slow/max .lib
  - `LIB_MIN` points to valid fast/min .lib

## Run

- `cd genus`
- `genus -no_gui -files run_microprocessor_genus.tcl`

## Post-run required checks

- Open `genus/reports/check_design_final.rpt` and ensure no unresolved errors.
- Open `genus/reports/timing_final.rpt` and check WNS/TNS.
- Open `genus/reports/area_final.rpt` for final cell area.
- Open `genus/reports/power_final.rpt` for leakage/dynamic estimate.
- Ensure netlist exists: `genus/outputs/microprocessor_final.v`.

## Known risk in current RTL

- `design/instruction_memory.v` uses `initial` and `$readmemh`.
- Decide and lock one ASIC-compatible instruction-memory implementation before tape-in.
