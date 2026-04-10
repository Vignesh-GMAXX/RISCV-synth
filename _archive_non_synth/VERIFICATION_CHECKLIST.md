# Verification Checklist - INSTR_MEM_FILE Generic Applied Successfully

## ✓ Step 1: Confirm Generic Was Set (COMPLETED)
You successfully ran Method 1 and got "Output 1" - the generic is now configured on synth_1.

---

## Step 2: Run Synthesis and Verify File Loaded

### 2a. Run Synthesis
1. In Vivado, right-click **synth_1** in the Design Runs panel
2. Select **Run Synthesis**
3. Wait for it to complete (should say "Synthesis completed successfully")

### 2b. Check Synthesis Log for readmemh
1. After synthesis completes, expand **synth_1** in Design Runs
2. Expand the **Logs** folder
3. Open **synth_1_synth.log** (double-click)
4. Press Ctrl+F to search for: `readmemh`
5. Look for a line like:
   ```
   $readmemh("design/instr_max5.mem", mem)
   ```
   **If you see this:** ✓ Generic was passed correctly!
   
6. Search for: `Opening file`
   Look for: `design/instr_max5.mem`
   **If you see this:** ✓ File was successfully found and parsed!

### 2c. Check for Warnings
Search the log for warning keywords:
- `WARNING` - should not mention readmemh or file path issues
- If you see "File not found" or "readmemh failed" - the generic wasn't applied

---

## Step 3: Verify in Synthesized Design

1. Right-click **synth_1** in Design Runs
2. Select **Open Synthesized Design**
3. In the Hierarchy panel (left), find:
   - `basys3_top_i`
   - → `u_microprocessor0`
   - → `u_instruction_memory`
   - → `u_memory` (the actual instruction_memory instance)
4. Double-click **u_memory** to inspect it
5. In the Properties panel, check if **INIT_FILE** shows:
   ```
   design/instr_max5.mem
   ```
   **If yes:** ✓ Generic parameter was passed through hierarchy!

---

## Step 4: Memory Content Verification (Advanced)

1. With synthesized design open, select the **u_memory** module in hierarchy
2. In the Design panel (bottom-right), look for Memory content initialization
3. Verify it's NOT showing the 4 hardcoded values:
   - `mem[0] = 32'h00500093`
   - `mem[1] = 32'h00900113`
   - `mem[2] = 32'h002081B3`
   - `mem[3] = 32'h40118233`
4. If memory is blank or shows different values → ✓ Real instr_max5.mem was loaded!

---

## Step 5: Complete the Build

If verification passes (Steps 2-4), proceed:

1. **Run Implementation:**
   - Right-click **impl_1** (or create new Implementation run)
   - Select **Run Implementation**
   - Wait for Place & Route to complete

2. **Generate Bitstream:**
   - Right-click **impl_1**
   - Select **Generate Bitstream**
   - Wait for completion

3. **Program FPGA:**
   - Connect Basys3 board via USB
   - Click **Program Device** (or Ctrl+Shift+P)
   - Select your board and click **Program**

---

## Step 6: Test on FPGA

After programming:
1. **LED Output:** Observe the 16 LEDs on the Basys3 board
2. **Expected Result:** LEDs should show register values as the max5 program runs
3. **With generic applied:** Full 32-instruction program executes (max of 5 values = 31)
4. **Without generic:** Only 4 hardcoded instructions execute (different LED pattern)

---

## Troubleshooting

### Issue: Synthesis log doesn't show readmemh
**Cause:** Generic wasn't actually applied to synth_1
**Solution:** 
- In Vivado Tcl Console, run again:
  ```tcl
  set_property generic [list INSTR_MEM_FILE=design/instr_max5.mem] [get_runs synth_1]
  ```
- Then run synthesis

### Issue: "File not found" error in synthesis log
**Cause:** Path is wrong or file doesn't exist
**Solution:**
- Verify `instr_max5.mem` exists in `design/` folder
- Try absolute path in generic:
  ```tcl
  set_property generic [list INSTR_MEM_FILE=C:/Users/vigne/OneDrive\ -\ iitgn.ac.in/Desktop/FPGA_f/FPGA_f/design/instr_max5.mem] [get_runs synth_1]
  ```

### Issue: FPGA still runs only 4 instructions
**Causes (in order of likelihood):**
1. Bitstream generated from OLD synthesis (before generic was set)
   - Delete `instr_max5.mem` temporarily, regenerate bitstream, verify it fails
   - Restore the file, re-run synthesis and bitstream

2. Generic set but synthesis not re-run
   - Right-click synth_1 > **Reset Run**
   - Then right-click synth_1 > **Run Synthesis** (fresh run)

3. FPGA not properly programmed
   - Clear FPGA config, reprogram bitstream

---

## Success Indicators ✓

When everything is configured correctly:
- ✓ Synthesis log shows `readmemh("design/instr_max5.mem", mem)`
- ✓ Synthesized design shows INIT_FILE = design/instr_max5.mem
- ✓ No "File not found" warnings
- ✓ FPGA executes full 32-instruction max5 program
- ✓ LED pattern shows max of 5 values = 31 (0x1F = binary 11111)
