# Placement and pre-CTS optimization stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $RUN_DIR ${TOP}_powerplan.enc]]} {
    source [file join $SCRIPT_DIR powerplan.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_powerplan.enc] $TOP
}

placeDesign
optDesign -preCTS

timeDesign -preCTS -outDir [file join $RPT_DIR preCTS]
report_timing > [file join $RPT_DIR preCTS_timing.rpt]
report_area > [file join $RPT_DIR preCTS_area.rpt]
report_power > [file join $RPT_DIR preCTS_power.rpt]

saveDesign [file join $RUN_DIR ${TOP}_place.enc]
