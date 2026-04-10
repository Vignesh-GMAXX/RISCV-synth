# Optional CCOpt controls.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

setAnalysisMode -analysisType onChipVariation -cppr both
setNanoRouteMode -drouteUseMultiCutViaEffort high

if {[llength $CTS_BUFFER_CELLS] > 0} {
    set_ccopt_property buffer_cells $CTS_BUFFER_CELLS
}
if {[llength $CTS_INVERTER_CELLS] > 0} {
    set_ccopt_property inverter_cells $CTS_INVERTER_CELLS
}

create_route_type -name leaf_rule -top_preferred_layer $PWR_RING_LAYER_V \
    -bottom_preferred_layer $ROUTING_BOTTOM -preferred_routing_layer_effort high
create_route_type -name trunk_rule -top_preferred_layer $ROUTING_TOP \
    -bottom_preferred_layer $PWR_RING_LAYER_V -preferred_routing_layer_effort high

set_ccopt_property -net_type leaf route_type leaf_rule
set_ccopt_property -net_type trunk route_type trunk_rule
set_ccopt_property -net_type top route_type trunk_rule
