set init_top_cell microprocessor_pad_top
set_global report_timing_format {instance arc net cell slew delay arrival required} 

set script_dir [file dirname [file normalize [info script]]]
set report_dir [file join $script_dir reports]
set spec_dir [file join $script_dir run]
file mkdir $report_dir
file mkdir $spec_dir

source [file join $script_dir config.tcl]
set ccopt_spec_file [file join $spec_dir ${init_top_cell}_ccopt.spec]
create_ccopt_clock_tree_spec -file $ccopt_spec_file
source $ccopt_spec_file
ctd_win -id before_ccopt 

set_ccopt_property -delay_corner max_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type leaf  target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type leaf  target_max_trans 2 

set_ccopt_property  -delay_corner min_delay target_skew 0.5 

# Apply target skew to all discovered skew groups.
set skew_groups {}
if {[catch {set skew_groups [get_ccopt_skew_groups *]} _sg_err]} {
	puts "WARN: Unable to query skew groups; using global target_skew only."
} elseif {[llength $skew_groups] == 0} {
	puts "WARN: No skew groups discovered; using global target_skew only."
} else {
	foreach sg $skew_groups {
		set_ccopt_property -skew_group $sg -delay_corner min_delay target_skew 0.5
	}
}

# If clock trees are discovered, try to annotate source driver on each tree.
set clock_trees {}
if {![catch {set clock_trees [get_ccopt_clock_trees *]} _ct_err] && [llength $clock_trees] > 0} {
	foreach ct $clock_trees {
		catch {set_ccopt_property source_driver pc3d01/CIN -clock_tree $ct}
	}
}

set_ccopt_property balance_mode cluster 
ccopt_design -cts 
ctd_win -id cluster_mode 
set_ccopt_property balance_mode trial 
ccopt_design -cts 
ctd_win -id trial_mode 
set_ccopt_property balance_mode full 
ccopt_design -cts 
ctd_win -id full_mode 

report_ccopt_clock_trees -summary -file [file join $report_dir ${init_top_cell}_clock_trees.rpt]
report_ccopt_skew_groups -summary -file [file join $report_dir ${init_top_cell}_skew_group.rpt]
reportCongestion -overflow -hotSpot > [file join $report_dir ${init_top_cell}_congestion.rpt]
