# Quick Start - Hardcoded instr_max5 (Simplified Approach)

✓ **All 32 instructions from `instr_max5.mem` are now hardcoded in `instruction_memory.v`**

## Changes Made
- Modified `design/instruction_memory.v`
- Replaced 4 hardcoded dummy instructions with all 32 max5 instructions
- No more generic parameters needed
- No more file path configuration needed

---

## Build & Deploy (3 Simple Steps)

### Step 1: Synthesize
```
Right-click synth_1 → Run Synthesis
```
(Just click Run - no special configuration needed!)

### Step 2: Place & Route  
```
Right-click impl_1 → Run Implementation
```

### Step 3: Generate Bitstream & Program
```
Right-click impl_1 → Generate Bitstream
```

Then program your Basys3 board - **DONE!** 🎉

---

## What Changed in instruction_memory.v

**Before (4 dummy instructions):**
```verilog
else begin
    mem[0] = 32'h00500093;
    mem[1] = 32'h00900113;
    mem[2] = 32'h002081B3;
    mem[3] = 32'h40118233;
end
```

**Now (32 max5 instructions):**
```verilog
else begin
    // Hardcoded instr_max5.mem (32 instructions from max5 algorithm)
    mem[0]  = 32'h00E00293;  // addi x5,x0,14
    mem[1]  = 32'h00502023;  // sw x5,0(x0)
    mem[2]  = 32'h01B00293;  // addi x5,x0,27
    mem[3]  = 32'h00502223;  // sw x5,4(x0)
    // ... (28 more instructions)
    mem[31] = 32'h0000006F;  // jal x0,0 (halt)
end
```

---

## Expected Behavior on FPGA

1. Loads 5 values: 14, 27, 9, 31, 18 into data memory
2. Finds maximum: **31**
3. Stores result to memory[5]
4. LEDs display: **0x1F** (binary 11111, decimal 31 = the max)
5. Halts

---

## Advantages of This Approach

✓ **No generic parameter configuration**  
✓ **No Vivado Tcl scripts needed**  
✓ **No path resolution issues**  
✓ **Instructions baked into FPGA permanently**  
✓ **Works on any Vivado version**  
✓ **Same result: full 32-instruction program runs on FPGA**

---

## If You Need Different Instructions Later

Simply edit `design/instruction_memory.v`:
1. Generate new hex values (use your Python encoder script)
2. Replace the `mem[X]` hex values in the else block
3. Re-synthesize and reprogram

---

## Verification

After programming FPGA:
- **Success:** LEDs show **0x1F** (max of 14,27,9,31,18)
- **Failure:** LEDs show something else (only 4 old instructions running)

Enjoy! 🚀
