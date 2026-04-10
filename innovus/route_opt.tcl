# Routing and post-route optimization stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $RUN_DIR ${TOP}_cts.enc]]} {
    source [file join $SCRIPT_DIR cts.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_cts.enc] $TOP
}

setNanoRouteMode -routeWithSiDriven true
routeDesign
optDesign -postRoute

extractRC
timeDesign -postRoute -outDir [file join $RPT_DIR postRoute]
report_timing > [file join $RPT_DIR postRoute_timing.rpt]
report_area > [file join $RPT_DIR postRoute_area.rpt]
report_power > [file join $RPT_DIR postRoute_power.rpt]

saveDesign [file join $RUN_DIR ${TOP}_route.enc]
