# Vivado GUI Method - Set INSTR_MEM_FILE Generic (Most Reliable)

## Error Encountered
```
ERROR: [Common 17-54] The object 'run' does not have a property 'STEPS.SYNTH_DESIGN.ARGS.GENERIC'.
```

This means the Tcl property path doesn't exist in your Vivado version. **Use the GUI method instead (100% reliable).**

---

## Step-by-Step GUI Instructions

### 1. Open Vivado Project
- Launch Vivado
- Open your FPGA project

### 2. Access Synthesis Run Settings
- In the left panel, find **Design Runs**
- Right-click on **synth_1**
- Select **Edit Run Settings...**

![Location: Design Runs > synth_1](https://docs.xilinx.com/r/en-US/ug892-vivado-design-flows/Synthesis-Run-Settings)

### 3. Configure Generic Parameter
- A dialog box opens: "Edit Runs Settings for synth_1"
- Click on the **Synthesis** tab (usually selected by default)
- Find the field labeled **Other Options** or **Additional Options**
- In that text field, add:
  ```
  -generic INSTR_MEM_FILE=design/instr_max5.mem
  ```
  
  **Note:** If there's already text in that field, add a space and then the above text.

### 4. Apply and Close
- Click **OK** button at the bottom
- The settings are saved

### 5. Run Synthesis
- Right-click **synth_1** in Design Runs
- Select **Run Synthesis**
- Wait for synthesis to complete
- Check the Synthesis Messages for any warnings about the .mem file

### 6. Continue Implementation
- After synthesis succeeds, run **Place & Route** (right-click Implementation in Design Runs)
- Then **Generate Bitstream**
- Program your FPGA

---

## Verification
After synthesis completes successfully:
1. Expand **synth_1** in Design Runs
2. Double-click **open_synth_design** to view the synthesized design
3. In the Synthesis Messages tab, you should NOT see errors about readmemh
4. The instruction_memory module should show as initialized with data from instr_max5.mem

---

## If You Still Get Errors

### Error: "File not found: design/instr_max5.mem"
- **Solution:** Use absolute path or verify file exists
- Try: `-generic INSTR_MEM_FILE=C:/Users/vigne/OneDrive\ -\ iitgn.ac.in/Desktop/FPGA_f/FPGA_f/design/instr_max5.mem`

### Error: Generic parameter not recognized
- **Solution:** Vivado may require different syntax. Try alternative:
  ```
  -generic {INSTR_MEM_FILE=design/instr_max5.mem}
  ```
  (with curly braces)

### Synthesis still uses hardcoded 4 instructions
- **Solution:** The parameter isn't being passed. Ensure:
  1. Generic field contains the -generic flag (not blank)
  2. synth_1 run is selected before editing settings
  3. You clicked OK to save settings
  4. You ran synthesis AFTER saving (not before)

---

## Alternative: Check Implementation Settings
If synthesis completes but bitstream still uses old instructions:

1. Right-click your **Implementation** run
2. Select **Edit Run Settings**
3. Check if there's a Generic field there too
4. Add the same generic parameter if present
5. Regenerate Bitstream

---

## Contact/Debug Info
If GUI method doesn't work:
1. Note your **Vivado version** (Help > About Vivado)
2. Check **Synthesis report** (open synth_1 > Logs > synth_1_synth.log)
3. Search for "readmemh" in the log to see what file path was used
