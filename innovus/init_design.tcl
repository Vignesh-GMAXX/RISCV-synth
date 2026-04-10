# Innovus initialization stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

set init_lef_file [list $LEF_TECH $LEF_CELL]
if {$LEF_MACRO ne ""} {
    lappend init_lef_file $LEF_MACRO
}

set init_verilog $NETLIST_FILE
set init_top_cell $TOP
set init_mmmc_file [file join $SCRIPT_DIR mmmc.tcl]
set init_pwr_net $POWER_NET
set init_gnd_net $GROUND_NET

init_design
checkDesign -all

saveDesign [file join $RUN_DIR ${TOP}_init.enc]
