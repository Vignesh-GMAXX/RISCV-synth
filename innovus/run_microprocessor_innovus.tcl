# Master Innovus run script.
# Usage:
#   cd innovus
#   innovus -no_gui -init run_microprocessor_innovus.tcl

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

source [file join $SCRIPT_DIR init_design.tcl]
source [file join $SCRIPT_DIR floorplan.tcl]
source [file join $SCRIPT_DIR powerplan.tcl]
source [file join $SCRIPT_DIR place_opt.tcl]
source [file join $SCRIPT_DIR cts.tcl]
source [file join $SCRIPT_DIR route_opt.tcl]
source [file join $SCRIPT_DIR signoff_export.tcl]

if {$DO_STREAMOUT} {
    source [file join $SCRIPT_DIR streamout.tcl]
}

puts "INNOVUS_FLOW_DONE: TOP=$TOP"
exit
