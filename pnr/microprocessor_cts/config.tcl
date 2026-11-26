## To enure that sufficient analysis views are active 
set_analysis_view -setup {worst_case} -hold {best_case} 

## GigaOpt technology for the postRoute flow. 
setAnalysisMode -analysisType onChipVariation -cppr both 
setNanoRouteMode -drouteUseMultiCutViaEffort "high"


## Configure library cells for CTS to use specified buffers/inverters 
set_ccopt_property buffer_cells {bufbd1 bufbd2 bufbd3 bufbd4 bufbd7 bufbda bufbdf bufbdk} 
set_ccopt_property inverter_cells {invbd2 invbd4 invbd7 invbda invbdf invbdk} 


#set_ccopt_property buffer_cells {bufbd1 bufbd2 bufbd3 bufbd4}
#set_ccopt_property inverter_cells {invbd2 invbd4}
#set_ccopt_property target_skew 0.1
#setOptMode -holdFixing true
#setOptMode -holdTargetSlack 0.05

setDesignMode -topRoutingLayer 6

## Define route types to binds NDR rules, preferred routing layers, and a shielding specifications together 
create_route_type -name leaf_rule  -top_preferred_layer 3 -bottom_preferred_layer 1 -preferred_routing_layer_effort high 
create_route_type -name trunk_rule -top_preferred_layer 6 -bottom_preferred_layer 4 -preferred_routing_layer_effort high

## Specify that the route types defined above will be used for leaf, trunk, and the top nets only 
set_ccopt_property -net_type leaf  route_type leaf_rule 
set_ccopt_property -net_type trunk  route_type trunk_rule 
set_ccopt_property -net_type top  route_type trunk_rule 

## sets the primary delay corner to be the maximum delay corner and disables the automatic trimming of route types 
set_ccopt_property primary_delay_corner max_delay 
set_ccopt_property route_type_autotrim false
