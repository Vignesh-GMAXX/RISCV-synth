# Vivado Tcl Script: Set Instruction Memory File Generic for Synthesis
# 
# Purpose: Configure synth_1 run to load instructions from instr_max5.mem
# 
# Usage in Vivado:
#   1. Tools > Run Tcl Script
#   2. Select this file
#   3. Or paste contents into Tcl Console
#
# Alternative - Direct Tcl Console:
#   source set_instr_mem_generic.tcl

# Try Method 1: Set generic as a property list
catch {
    set_property generic [list INSTR_MEM_FILE=design/instr_max5.mem] [get_runs synth_1]
    puts "✓ Method 1: Generic set successfully via property list"
} err1

# If Method 1 fails, try Method 2: Set as synthesis options
catch {
    set_property STEPS.SYNTH_DESIGN.ARGS.GENERIC "{INSTR_MEM_FILE=design/instr_max5.mem}" [get_runs synth_1]
    puts "✓ Method 2: Generic set successfully via STEPS.SYNTH_DESIGN.ARGS"
} err2

# If Method 2 fails, try Method 3: Direct string argument
catch {
    set_property -name {STEPS.SYNTH_DESIGN.ARGS.GENERIC} -value {INSTR_MEM_FILE=design/instr_max5.mem} -objects [get_runs synth_1]
    puts "✓ Method 3: Generic set successfully via named property"
} err3

# If all methods fail, provide instructions for manual GUI
if {[string length $err1] > 0 && [string length $err2] > 0 && [string length $err3] > 0} {
    puts "\n⚠ Automated Tcl methods failed. Use GUI instead:"
    puts "  1. Right-click synth_1 > Edit Run Settings"
    puts "  2. In Synthesis Options > Other Options field, add:"
    puts "     -generic INSTR_MEM_FILE=design/instr_max5.mem"
    puts "  3. Click OK and run synthesis"
} else {
    puts "\n✓ INSTR_MEM_FILE generic configured"
    puts "\nNext step: Run Synthesis"
    puts "  Right-click synth_1 > Run Synthesis"
    puts "  Or: launch_runs synth_1 -to_step synth_design"
}
