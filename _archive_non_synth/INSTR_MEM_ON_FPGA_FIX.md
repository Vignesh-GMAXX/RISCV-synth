# FPGA Instruction Memory Fix - Running Full Program on Hardware

## Problem
- **Simulation works:** FPGA_tb runs the full max5 program (32 instructions from `instr_max5.mem`)
- **FPGA only runs 4 instructions:** The hardcoded fallback in `instruction_memory.v` executes instead

## Root Cause
The `INSTR_MEM_FILE` parameter is NOT being passed to Vivado synthesis. It defaults to empty string (`""`), so `instruction_memory.v` uses this fallback:

```verilog
else begin
    mem[0] = 32'h00500093;  // These 4 hardcoded instructions run on FPGA
    mem[1] = 32'h00900113;
    mem[2] = 32'h002081B3;
    mem[3] = 32'h40118233;
end
```

## Solution: Set the Generic in Vivado Synthesis

### Method 1: GUI (Easiest & Most Reliable) ⭐
**See detailed instructions in `VIVADO_GUI_GENERIC_FIX.md`**

Quick steps:
1. Right-click **synth_1** in Design Runs → **Edit Run Settings**
2. In **Other Options** field, add:
   ```
   -generic INSTR_MEM_FILE=design/instr_max5.mem
   ```
3. Click **OK** → **Run Synthesis**

### Method 2: Tcl Console (Fastest)
1. Open Vivado Tcl Console (Tools > Tcl Console)
2. Paste this command:
   ```tcl
   set_property STEPS.SYNTH_DESIGN.ARGS.GENERIC {INSTR_MEM_FILE=design/instr_max5.mem} [get_runs synth_1]
   ```
3. Press Enter
4. Run synthesis: `launch_runs synth_1 -to_step synth_design`

### Method 3: Autoconfigure Script
1. In Vivado Tcl Console, run:
   ```tcl
   source set_instr_mem_generic.tcl
   ```
   (This script is in your project root directory)
2. Then run synthesis normally

## Complete Workflow After Setting Generic

1. ✓ Set `INSTR_MEM_FILE=design/instr_max5.mem` generic (use any method above)
2. Run Synthesis
3. **VERIFY:** Use [VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md) to confirm file was loaded
4. Run Place & Route  
5. Generate Bitstream
6. Program FPGA
7. **Your full max5 program will now run on hardware!**

## Verification
After generating the bitstream:
- Synthesis log should show: "`$readmemh() call found with file design/instr_max5.mem`"
- No readmemh warnings about missing files
- All 32 instructions from `instr_max5.mem` execute on FPGA

## Why Simulation Works
Your testbenches (FPGA_TB, etc.) explicitly pass the parameter when instantiating the design:
```verilog
microprocessor #(
    .INSTR_MEM_FILE("design/instr_max5.mem")
) ...
```

The FPGA bitstream generation needs the same parameter set explicitly in synthesis.

## Parameter Path in Hierarchy
- `Basys3_top.v` (top): `parameter INSTR_MEM_FILE = ""`
  ↓ passes to:
- `Microprocessor.v`: `parameter INSTR_MEM_FILE = ""`
  ↓ passes to:
- `instruc_mem_top.v`: `parameter INIT_FILE = INSTR_MEM_FILE`
  ↓ passes to:
- `instruction_memory.v`: `parameter INIT_FILE = ""`
  ↓ uses:
- `$readmemh(INIT_FILE, mem)` ← Loads from file only if INIT_FILE is set
