# Testbench Usage Guide

This folder contains small, focused testbenches for instruction types and hazards.

## General Workflow

1. Open the testbench file for the scenario you want.
2. For single-instruction TBs:
   - Keep exactly one instruction assignment active at `mem[0]`.
   - Leave other instruction options commented.
   - Keep the matching expected-value check active.
3. Run simulation.
4. Read `PASS`/`FAIL` and `RESULT` lines in console.
5. Comment the instruction/check you completed and uncomment the next one.

## Instruction-Type Testbenches

- `Microprocessor_rtype_single_inst_tb.v`
  - R-type: `add, sub, sll, slt, sltu, xor, srl, sra, or, and`

- `Microprocessor_itype_single_inst_tb.v`
  - I-type: `addi, slli, slti, sltiu, xori, srli, srai, ori, andi`

- `Microprocessor_load_single_inst_tb.v`
  - Load-type: `lb, lh, lw, lbu, lhu`

- `Microprocessor_stype_single_inst_tb.v`
  - Store-type: `sb, sh, sw`

- `Microprocessor_btype_single_inst_tb.v`
  - Branch-type: `beq, bne, blt, bge, bltu, bgeu`

- `Microprocessor_jtype_single_inst_tb.v`
  - J-type: `jal`

- `Microprocessor_utype_single_inst_tb.v`
  - U-type: `lui, auipc`

- `Microprocessor_jalr_single_inst_tb.v`
  - JALR scenario tests

## Hazard Testbenches (Compact Scenarios)

- `Microprocessor_hazard_raw_adj_tb.v`
  - RAW dependency with adjacent instructions

- `Microprocessor_hazard_raw_gap1_tb.v`
  - RAW dependency with one instruction gap

- `Microprocessor_hazard_store_data_tb.v`
  - Producer-to-store data dependency

- `Microprocessor_hazard_war_like_tb.v`
  - WAR-like ordering check for in-order pipeline

- `Microprocessor_load_use_forwarding_tb.v`
  - Load-use forwarding focused checks

## Existing Integration/Reference TBs

- `Microprocessor_tb.v`
- `Microprocessor_hazard_free_tb.v`
- `Microprocessor_hazard_stress_tb.v`

## Running with Vivado

- Add the desired TB file to simulation sources.
- Set that TB module as top.
- Run behavioral simulation.

## Running with Icarus (Windows)

This project path contains spaces, so prefer quoted paths and a filtered flist if needed.

Example template:

```powershell
Set-Location "<project-root>"
iverilog -f flist -s <tb_top_module_name> "tb/<tb_file>.v" -o "temp/<tb_name>.out"
vvp "temp/<tb_name>.out"
```

If you see duplicate module errors from both `src/memory.v` and `src/Memory.v`, remove one from the compile list for that run.

## PASS/FAIL Interpretation

- `PASS: ...` means that check matched expected behavior.
- `FAIL: ...` prints actual observed value.
- `RESULT: PASS` means all checks in that TB passed.
- `RESULT: FAIL` means one or more checks failed.
](image.png);

00500093: ADDI x1, x0, 5
00900113: ADDI x2, x0, 9
002081B3: ADD x3, x1, x2
00302023: SW x3, 0(x0)
00002203: LW x4, 0(x0)
FFB20213: ADDI x4, x4, -5
00220463: BEQ x4, x2, +8
00108093: ADDI x1, x1, 1 (skipped by branch)
0080006F: JAL x0, +8
00000193: ADDI x3, x0, 0 (skipped by jump)
0000E093: ORI x1, x1, 0
00F17113: ANDI x2, x2, 0xF
00019193: SLLI x3, x3, 0
40025213: SRAI x4, x4, 0
0000006F: JAL x0, 0 (infinite hold loop)