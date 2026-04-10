# Microprocessor Innovus Input Package

This folder contains the stage scripts and configuration needed to run PnR for `microprocessor`.

## Required external inputs

Provide these files (or set env vars pointing to them):
- Technology LEF (`LEF_TECH`)
- Standard-cell LEF (`LEF_CELL`)
- Optional macro LEF (`LEF_MACRO`)
- Max timing liberty (`LIB_MAX`)
- Min timing liberty (`LIB_MIN`)
- QRC tech file (`QRC_TECH_FILE`)
- Streamout map (`STREAMOUT_MAP`)
- Synthesized netlist (`PNR_NETLIST`) from Genus (default: `../genus/outputs/microprocessor_final.v`)
- SDC (`PNR_SDC`) from Genus or design (default fallback: `../design/microprocessor_genus.sdc`)

## Script order

1. `init_design.tcl`
2. `floorplan.tcl`
3. `powerplan.tcl`
4. `place_opt.tcl`
5. `cts.tcl`
6. `route_opt.tcl`
7. `signoff_export.tcl`
8. `streamout.tcl`

Use `run_microprocessor_innovus.tcl` to run all stages.

## Run command

```powershell
cd innovus
innovus -no_gui -init run_microprocessor_innovus.tcl
```

## Notes

- Layer names/site names are template defaults; adapt them to your PDK.
- `config.tcl` includes hard checks for required input files.
- Output files are intentionally not pre-created, per your request.
