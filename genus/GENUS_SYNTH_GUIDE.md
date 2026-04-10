# Microprocessor Genus Synthesis Guide

This guide is tailored to this workspace and mirrors the same high-level split used in ICD_RTL2GDSII (inputs, scripts, reports, outputs).

## 1) Can these files be synthesized in Genus?

Short answer: Yes, the active RTL set is synthesizable as a logic design for top module `microprocessor`.

What was checked:
- Top-level compile sanity using all active RTL in `design/` passed.
- No unresolved module dependencies in the active Microprocessor closure.

Important caveat:
- `design/instruction_memory.v` contains an `initial` block with `$readmemh`.
- In ASIC synthesis, this pattern is usually simulation-only unless your memory strategy explicitly supports ROM/init inference.
- For production ASIC flow, replace it with one of:
  - a hard macro ROM,
  - a synthesized constant ROM strategy,
  - or a post-reset load mechanism via logic.

## 2) Required inputs for Genus

Minimum required files:
- RTL file list: `genus/filelist_microprocessor.f`
- Top module RTL and dependencies: `design/*.v` subset referenced in the file list
- Constraints: `design/microprocessor_genus.sdc`
- Standard-cell timing libraries:
  - one max (slow) .lib
  - one min (fast) .lib

Optional but recommended:
- Additional MMMC corners and derates
- Power intent (UPF/CPF), if used

## 3) Generated outputs you should expect

The run script writes outputs similar to reference project style:
- Netlists:
  - `genus/outputs/microprocessor_generic.v`
  - `genus/outputs/microprocessor_map.v`
  - `genus/outputs/microprocessor_final.v`
- Constraints/SDF:
  - `genus/outputs/microprocessor_final.sdc`
  - `genus/outputs/microprocessor_final.sdf`
- Reports:
  - `genus/reports/qor_final.rpt`
  - `genus/reports/area_final.rpt`
  - `genus/reports/timing_final.rpt`
  - `genus/reports/power_final.rpt`
  - `genus/reports/check_design_final.rpt`

## 4) How to run

From workspace root:

```powershell
$env:LIB_MAX = "D:/PDK/lib/slow.lib"
$env:LIB_MIN = "D:/PDK/lib/fast.lib"
cd genus
genus -no_gui -files run_microprocessor_genus.tcl
```

Optional overrides:

```powershell
$env:TOP = "microprocessor"
$env:CLOCK_NS = "10.0"
```

## 5) Important files for synthesis signoff handoff

Keep these as your core synthesis package:
- `design/Microprocessor.v`
- `design/microprocessor_genus.sdc`
- `genus/filelist_microprocessor.f`
- `genus/run_microprocessor_genus.tcl`
- `genus/outputs/microprocessor_final.v`
- `genus/outputs/microprocessor_final.sdc`
- `genus/reports/qor_final.rpt`
- `genus/reports/timing_final.rpt`
- `genus/reports/area_final.rpt`
- `genus/reports/power_final.rpt`

## 6) Notes mapped from ICD_RTL2GDSII reference

Borrowed flow patterns from the sample:
- Separate folders for `logs`, `reports`, and `outputs`
- staged synthesis (`syn_generic`, `syn_map`, `syn_opt`)
- post-stage report dumps
- SDC-driven run with explicit library setup

Not copied blindly from the sample:
- hardcoded absolute lab-server paths
- sample-specific pad libraries and top names

This workspace script is path-clean and local-project relative.
