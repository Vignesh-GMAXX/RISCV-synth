# RISCV-synth

Synthesis-ready version of the 5-stage pipelined **RV32I** core, wrapped in an SCL 180 nm I/O pad ring (`microprocessor_pad_top`), together with the testbenches, the Cadence Genus synthesis script, and the Innovus floorplan/CTS setup used to take it to layout.

The full set of signoff results (GDS, timing/area/DRC reports, GLS, power, LVS) lives in [RISCV_RTL2GDS](https://github.com/Vignesh-GMAXX/RISCV_RTL2GDS).

## Repository layout

```
RISCV-synth/
├── rtl/                          # synthesisable Verilog
│   ├── Microprocessor.v          #   core top (module `microprocessor`)
│   ├── microprocessor_pad_top.v  #   chip top: core + SCL pad cells
│   ├── Core.v, Fetch.v, Decode.v, Execute.v, memory_stage.v, Write_back.v
│   ├── *_pipe.v                  #   pipeline registers
│   ├── execute_forwarding.v      #   data-hazard forwarding
│   └── alu.v, register_file.v, control_unit.v, ... memories and muxes
├── tb/                           # testbenches (most are self-checking and print PASS / FAIL)
├── synth/                        # Genus
│   ├── run.tcl                   #   synthesis script
│   ├── microprocessor_genus.sdc  #   constraints (20 ns clock)
│   ├── microprocessor_incremental.v  # synthesised gate-level netlist
│   └── stdcells_autostub.v       #   permissive std-cell stubs for netlist simulation
├── pnr/                          # Innovus
│   ├── microprocessor_floorplan/ #   I/O placement (.io) and MMMC view (.view)
│   ├── microprocessor_cts/       #   CTS script and config
│   ├── 8bit_FFT_DEMO/            #   course reference flow (its CapTbl is used by the MMMC view)
│   ├── project_flow_steps.txt    #   lab server project-setup notes
│   └── toolRC_scl_new            #   lab Cadence environment script
└── _archive_non_synth/           # earlier Basys3/FPGA files and testbenches kept for reference
```

## Simulating the RTL

Testbenches are plain Verilog; all except `Microprocessor_4reg_tb` and `netlist_smoke_tb` check their own results and print PASS / FAIL. With [Icarus Verilog](https://steveicarus.github.io/iverilog/) (run from the repository root; `microprocessor_pad_top.v` is left out because it instantiates SCL pad cells):

```bash
TB=Microprocessor_rtype_single_inst_tb
mkdir -p build
iverilog -g2012 -s $TB -o build/$TB.vvp $(ls rtl/*.v | grep -v pad_top) tb/$TB.v
vvp build/$TB.vvp
```

Swap `TB` for any file in `tb/` (the module name matches the file name). Two special cases:

| Testbench | Compile with |
|---|---|
| `microprocessor_pad_top_tb` | all of `rtl/*.v` plus the testbench — it carries its own behavioural pad-cell models |
| `netlist_smoke_tb` | `synth/microprocessor_incremental.v synth/stdcells_autostub.v tb/netlist_smoke_tb.v` (gate-level smoke test of the synthesised netlist) |

### Testbench coverage

| Group | Testbenches |
|---|---|
| Instruction classes | `rtype`, `itype`, `load`, `stype`, `btype`, `utype`, `jtype`, `jalr` single-instruction benches |
| Full ISA | `Microprocessor_rv32i_all37_tb`, `Microprocessor_rv32i_all37_single_run_tb` |
| Hazards | RAW adjacent / one-gap, load-use (`lw_add`), store data, ALU→branch (`add_beq`), WAR-like ordering, hazard-free reference, stress mix, combined `hazards_all` |
| Integration | `Microprocessor_4reg_tb`, `microprocessor_pad_top_tb`, `netlist_smoke_tb` |

### Last recorded regression (10 April 2026)

The `temp/` folder used to hold the compiled simulations and CSV summaries from two Icarus runs; those generated files have been removed and the results are recorded here.

| Result | Testbenches |
|---|---|
| PASS | all eight single-instruction benches, `rv32i_all37`, `hazard_raw_adj`, `hazard_raw_gap1`, `hazard_store_data`, `hazard_add_beq`, `hazard_war_like` |
| FAIL | `rv32i_all37_single_run`, `hazard_free`, `hazard_lw_add`, `hazard_stress`, `hazards_all` |
| No PASS token printed | `4reg` |

The later post-cleanup rerun of the instruction-class benches matched: all pass except `rv32i_all37_single_run`.

## Synthesis (Cadence Genus)

On a machine with the SCL 180 nm PDK installed at the path in `run.tcl`:

```bash
cd synth
genus -files run.tcl
```

`run.tcl` reads every `rtl/*.v` and `microprocessor_genus.sdc` relative to the repository, so it works from any checkout location. Outputs go to `synth/outputs/`, `synth/reports/` and `synth/logs*/` (git-ignored). The library paths under `/opt/tools/Cadence/...` are specific to the lab server; edit them if your PDK lives elsewhere.

## Place and route (Cadence Innovus)

Start Innovus from `pnr/microprocessor_floorplan/` so the relative paths in `microprocessor.view` resolve (`../../synth/microprocessor_genus.sdc` and the FFT demo's CapTbl), load the synthesised netlist with the `.io` file, then source `pnr/microprocessor_cts/cts.tcl` after placement. `pnr/project_flow_steps.txt` has the lab's project-setup steps.

## Notes

- Target: `tsl18fs120` standard cells and `tsl18cio150` I/O pads, 6-metal stack, 20 ns clock.
- `_archive_non_synth/` holds the earlier FPGA-oriented files (Basys3 top, XDC, Vivado notes, instruction-memory images). Its notes refer to an older `design/` folder layout.
