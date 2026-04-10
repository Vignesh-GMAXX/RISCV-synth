# Signoff checks and database/netlist export stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $RUN_DIR ${TOP}_route.enc]]} {
    source [file join $SCRIPT_DIR route_opt.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_route.enc] $TOP
}

verifyConnectivity -type all -error 10000 > [file join $RPT_DIR connectivity.rpt]
verifyGeometry > [file join $RPT_DIR geometry.rpt]
report_timing > [file join $RPT_DIR signoff_timing.rpt]
report_power > [file join $RPT_DIR signoff_power.rpt]

saveNetlist [file join $OUT_DIR ${TOP}_postroute.v]
write_sdc [file join $OUT_DIR ${TOP}_postroute.sdc]
write_sdf [file join $OUT_DIR ${TOP}_postroute.sdf]
saveDesign [file join $OUT_DIR ${TOP}_postroute.enc]
