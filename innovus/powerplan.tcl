# Power planning stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $RUN_DIR ${TOP}_floorplan.enc]]} {
    source [file join $SCRIPT_DIR floorplan.tcl]
} else {
    restoreDesign [file join $RUN_DIR ${TOP}_floorplan.enc] $TOP
}

# Global power/ground connections.
globalNetConnect $POWER_NET -type pgpin -pin VDD -all
globalNetConnect $GROUND_NET -type pgpin -pin VSS -all
globalNetConnect $POWER_NET -type tiehi
globalNetConnect $GROUND_NET -type tielo

# Core ring.
setAddRingMode -stacked_via_top_layer $ROUTING_TOP -stacked_via_bottom_layer $ROUTING_BOTTOM
addRing -nets [list $POWER_NET $GROUND_NET] -type core_rings -follow core \
    -layer [list top $PWR_RING_LAYER_H bottom $PWR_RING_LAYER_H left $PWR_RING_LAYER_V right $PWR_RING_LAYER_V] \
    -width $PWR_RING_WIDTH -spacing $PWR_RING_SPACING -offset $PWR_RING_OFFSET

# Stripes.
setAddStripeMode -stacked_via_top_layer $ROUTING_TOP -stacked_via_bottom_layer $ROUTING_BOTTOM
addStripe -nets [list $POWER_NET $GROUND_NET] -layer $STRIPE_LAYER -direction vertical \
    -width $STRIPE_WIDTH -spacing $STRIPE_SPACING -set_to_set_distance $STRIPE_PITCH \
    -start_offset $STRIPE_OFFSET

sroute -nets [list $POWER_NET $GROUND_NET] -connect {corePin blockPin floatingStripe padPin padRing coreRing}

saveDesign [file join $RUN_DIR ${TOP}_powerplan.enc]
