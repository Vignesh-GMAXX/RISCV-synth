# Floorplan and pin assignment stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

# Load initialized DB if needed.
if {![file exists [file join $RUN_DIR ${TOP}_init.enc]]} {
    source [file join $SCRIPT_DIR init_design.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_init.enc] $TOP
}

floorPlan -site $SITE_NAME -r $CORE_ASPECT_RATIO $CORE_UTIL \
    $CORE_MARGIN_L $CORE_MARGIN_B $CORE_MARGIN_R $CORE_MARGIN_T

setPinAssignMode -pinEditInBatch true
editPin -pin [all_inputs] -side LEFT -spreadType SIDE
editPin -pin [all_outputs] -side RIGHT -spreadType SIDE
setPinAssignMode -pinEditInBatch false

checkDesign -floorplan
saveDesign [file join $RUN_DIR ${TOP}_floorplan.enc]
