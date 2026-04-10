# Shared configuration for microprocessor Innovus flow.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set ROOT_DIR [file normalize [file join $SCRIPT_DIR ..]]

set TOP [expr {[info exists ::env(TOP)] ? $::env(TOP) : "microprocessor"}]

# Inputs from synthesis and constraints.
set NETLIST_DEFAULT [file join $ROOT_DIR genus outputs ${TOP}_final.v]
set NETLIST_FILE [expr {[info exists ::env(PNR_NETLIST)] ? $::env(PNR_NETLIST) : $NETLIST_DEFAULT}]

set SDC_DEFAULT [file join $ROOT_DIR genus outputs ${TOP}_final.sdc]
set SDC_FALLBACK [file join $ROOT_DIR design microprocessor_genus.sdc]
set SDC_FILE [expr {[info exists ::env(PNR_SDC)] ? $::env(PNR_SDC) : $SDC_DEFAULT}]
if {![file exists $SDC_FILE] && [file exists $SDC_FALLBACK]} {
    set SDC_FILE $SDC_FALLBACK
}

# PDK collateral (set these env vars before running Innovus).
set LEF_TECH [expr {[info exists ::env(LEF_TECH)] ? $::env(LEF_TECH) : [file join $SCRIPT_DIR inputs tech.lef]}]
set LEF_CELL [expr {[info exists ::env(LEF_CELL)] ? $::env(LEF_CELL) : [file join $SCRIPT_DIR inputs stdcell.lef]}]
set LEF_MACRO [expr {[info exists ::env(LEF_MACRO)] ? $::env(LEF_MACRO) : ""}]

set LIB_MAX [expr {[info exists ::env(LIB_MAX)] ? $::env(LIB_MAX) : [file join $SCRIPT_DIR inputs max.lib]}]
set LIB_MIN [expr {[info exists ::env(LIB_MIN)] ? $::env(LIB_MIN) : [file join $SCRIPT_DIR inputs min.lib]}]

set QRC_TECH_FILE [expr {[info exists ::env(QRC_TECH_FILE)] ? $::env(QRC_TECH_FILE) : [file join $SCRIPT_DIR inputs qrcTechFile.tch]}]
set STREAMOUT_MAP_FILE [expr {[info exists ::env(STREAMOUT_MAP)] ? $::env(STREAMOUT_MAP) : [file join $SCRIPT_DIR inputs streamout.map]}]

# Core-only flow defaults (update per your PDK/site name).
set SITE_NAME [expr {[info exists ::env(SITE_NAME)] ? $::env(SITE_NAME) : "core"}]
set CORE_UTIL [expr {[info exists ::env(CORE_UTIL)] ? $::env(CORE_UTIL) : 0.65}]
set CORE_ASPECT_RATIO [expr {[info exists ::env(CORE_ASPECT_RATIO)] ? $::env(CORE_ASPECT_RATIO) : 1.0}]

set CORE_MARGIN_L [expr {[info exists ::env(CORE_MARGIN_L)] ? $::env(CORE_MARGIN_L) : 20}]
set CORE_MARGIN_R [expr {[info exists ::env(CORE_MARGIN_R)] ? $::env(CORE_MARGIN_R) : 20}]
set CORE_MARGIN_B [expr {[info exists ::env(CORE_MARGIN_B)] ? $::env(CORE_MARGIN_B) : 20}]
set CORE_MARGIN_T [expr {[info exists ::env(CORE_MARGIN_T)] ? $::env(CORE_MARGIN_T) : 20}]

set POWER_NET [expr {[info exists ::env(POWER_NET)] ? $::env(POWER_NET) : "VDD"}]
set GROUND_NET [expr {[info exists ::env(GROUND_NET)] ? $::env(GROUND_NET) : "VSS"}]

# Default routing layers for power planning (adjust for your stack).
set ROUTING_BOTTOM [expr {[info exists ::env(ROUTING_BOTTOM)] ? $::env(ROUTING_BOTTOM) : "M1"}]
set ROUTING_TOP [expr {[info exists ::env(ROUTING_TOP)] ? $::env(ROUTING_TOP) : "M6"}]
set PWR_RING_LAYER_H [expr {[info exists ::env(PWR_RING_LAYER_H)] ? $::env(PWR_RING_LAYER_H) : "M6"}]
set PWR_RING_LAYER_V [expr {[info exists ::env(PWR_RING_LAYER_V)] ? $::env(PWR_RING_LAYER_V) : "M5"}]
set PWR_RING_WIDTH [expr {[info exists ::env(PWR_RING_WIDTH)] ? $::env(PWR_RING_WIDTH) : 2.0}]
set PWR_RING_SPACING [expr {[info exists ::env(PWR_RING_SPACING)] ? $::env(PWR_RING_SPACING) : 2.0}]
set PWR_RING_OFFSET [expr {[info exists ::env(PWR_RING_OFFSET)] ? $::env(PWR_RING_OFFSET) : 2.0}]

set STRIPE_LAYER [expr {[info exists ::env(STRIPE_LAYER)] ? $::env(STRIPE_LAYER) : "M5"}]
set STRIPE_WIDTH [expr {[info exists ::env(STRIPE_WIDTH)] ? $::env(STRIPE_WIDTH) : 1.2}]
set STRIPE_SPACING [expr {[info exists ::env(STRIPE_SPACING)] ? $::env(STRIPE_SPACING) : 1.2}]
set STRIPE_PITCH [expr {[info exists ::env(STRIPE_PITCH)] ? $::env(STRIPE_PITCH) : 40.0}]
set STRIPE_OFFSET [expr {[info exists ::env(STRIPE_OFFSET)] ? $::env(STRIPE_OFFSET) : 10.0}]

# Optional CTS cell restrictions. Keep empty unless needed.
set CTS_BUFFER_CELLS {}
set CTS_INVERTER_CELLS {}

set DO_STREAMOUT [expr {[info exists ::env(DO_STREAMOUT)] ? $::env(DO_STREAMOUT) : 1}]
set GDS_MERGE_FILES {}

# Working directories.
set RUN_DIR [file join $SCRIPT_DIR run]
set RPT_DIR [file join $SCRIPT_DIR reports]
set OUT_DIR [file join $SCRIPT_DIR outputs]
set LOG_DIR [file join $SCRIPT_DIR logs]

foreach d [list $RUN_DIR $RPT_DIR $OUT_DIR $LOG_DIR] {
    if {![file exists $d]} { file mkdir $d }
}

proc require_file {path label} {
    if {![file exists $path]} {
        puts "ERROR: Missing $label at $path"
        exit 2
    }
}

# Required inputs for initializing the design.
require_file $NETLIST_FILE "PNR_NETLIST"
require_file $SDC_FILE "PNR_SDC"
require_file $LEF_TECH "LEF_TECH"
require_file $LEF_CELL "LEF_CELL"
require_file $LIB_MAX "LIB_MAX"
require_file $LIB_MIN "LIB_MIN"
require_file $QRC_TECH_FILE "QRC_TECH_FILE"
