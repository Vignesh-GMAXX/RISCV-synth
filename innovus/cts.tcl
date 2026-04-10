# Clock tree synthesis stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $RUN_DIR ${TOP}_place.enc]]} {
    source [file join $SCRIPT_DIR place_opt.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_place.enc] $TOP
}

source [file join $SCRIPT_DIR cts_config.tcl]

create_ccopt_clock_tree_spec -file [file join $RUN_DIR ${TOP}_ccopt.spec]
source [file join $RUN_DIR ${TOP}_ccopt.spec]

set_ccopt_property target_skew 0.20
ccopt_design -cts
optDesign -postCTS

timeDesign -postCTS -outDir [file join $RPT_DIR postCTS]
report_ccopt_clock_trees -summary -file [file join $RPT_DIR ${TOP}_clock_trees.rpt]
report_ccopt_skew_groups -summary -file [file join $RPT_DIR ${TOP}_skew_groups.rpt]
report_timing > [file join $RPT_DIR postCTS_timing.rpt]

saveDesign [file join $RUN_DIR ${TOP}_cts.enc]
