set init_top_cell microprocessor_pad_top
set_global report_timing_format {instance arc net cell slew delay arrival required} 

set script_dir [file dirname [file normalize [info script]]]
set report_dir [file join $script_dir reports]
set spec_dir [file join $script_dir run]
file mkdir $report_dir
file mkdir $spec_dir

source [file join $script_dir config.tcl]

# Reset is an asynchronous control; do not time it as a functional datapath.
if {[llength [get_ports -quiet {rst_pad}]] > 0} {
	set_false_path -from [get_ports {rst_pad}] -to [all_registers]
}

# Enforce pad-wrapper top context for this flow.
if {[llength [get_ports -quiet {clk_pad}]] == 0} {
	error "Port clk_pad not found. Ensure the loaded netlist top is microprocessor_pad_top."
}
if {[llength [get_ports -quiet {rst_pad}]] == 0} {
	error "Port rst_pad not found. Ensure the loaded netlist top is microprocessor_pad_top."
}

# Try to enable at least one interactive constraint mode for interactive SDC commands.
proc ensure_interactive_constraint_mode {} {
	# Common mode names seen across this project flows.
	foreach cm {functional CONSTRAINT_FUNC} {
		if {![catch {set_interactive_constraint_modes $cm} _err]} {
			puts "INFO: Interactive constraint mode enabled: $cm"
			return 1
		}
		if {![catch {set_interactive_constraint_mode $cm} _err_s]} {
			puts "INFO: Interactive constraint mode enabled: $cm"
			return 1
		}
	}

	# Fallback: try all discovered modes as returned by the tool.
	set cm_objs {}
	if {![catch {set cm_objs [all_constraint_modes]} _cm_err] && [llength $cm_objs] > 0} {
		if {![catch {set_interactive_constraint_modes $cm_objs} _set_err]} {
			puts "INFO: Interactive constraint modes enabled: $cm_objs"
			return 1
		}
		if {![catch {set_interactive_constraint_mode $cm_objs} _set_err_s]} {
			puts "INFO: Interactive constraint modes enabled: $cm_objs"
			return 1
		}

		# If the API returned objects, resolve to names and retry.
		set cm_names {}
		foreach cmo $cm_objs {
			set cm_name ""
			if {![catch {set cm_name [get_object_name $cmo]} _name_err] && $cm_name ne ""} {
				lappend cm_names $cm_name
			}
		}
		if {[llength $cm_names] > 0 && ![catch {set_interactive_constraint_modes $cm_names} _name_set_err]} {
			puts "INFO: Interactive constraint modes enabled: $cm_names"
			return 1
		}
		if {[llength $cm_names] > 0 && ![catch {set_interactive_constraint_mode $cm_names} _name_set_err_s]} {
			puts "INFO: Interactive constraint modes enabled: $cm_names"
			return 1
		}
	}

	return 0
}

set ccopt_spec_file [file join $spec_dir ${init_top_cell}_ccopt.spec]
create_ccopt_clock_tree_spec -file $ccopt_spec_file
source $ccopt_spec_file

# If no tree is inferred from SDC/MMMC, create a fallback real clock and regenerate spec.
set discovered_trees {}
catch {set discovered_trees [get_ccopt_clock_trees *]}
if {[llength $discovered_trees] == 0} {
	puts "WARN: No CCOpt clock trees discovered from current constraints."
	set fallback_src {}
	set port_try [get_ports -quiet {clk_pad}]
	if {[llength $port_try] > 0} {
		set fallback_src $port_try
	} else {
		set pin_try [get_pins -quiet {u_microprocessor_core/clk}]
		if {[llength $pin_try] > 0} {
			set fallback_src $pin_try
		}
	}

	if {[llength $fallback_src] == 0} {
		error "No fallback clock source found (tried clk_pad, u_microprocessor_core/clk)."
	}

	if {![ensure_interactive_constraint_mode]} {
		puts "WARN: Unable to explicitly enable interactive constraint mode; attempting fallback create_clock anyway."
	}

	puts "INFO: Creating fallback clock core_clk_fallback (20ns) and regenerating CCOpt spec."
	if {[catch {create_clock -name core_clk_fallback -period 20.000 -waveform {0 10} $fallback_src} _clk_err]} {
		error "Fallback create_clock failed. Enable an interactive constraint mode (for example: set_interactive_constraint_modes functional). Original error: $_clk_err"
	}
	create_ccopt_clock_tree_spec -file $ccopt_spec_file
	source $ccopt_spec_file
	catch {set discovered_trees [get_ccopt_clock_trees *]}
	if {[llength $discovered_trees] == 0} {
		error "CCOpt still has no clock trees after fallback clock creation."
	}
}
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
		if {[catch {set_ccopt_property source_driver pc3d01_clk/CIN -clock_tree $ct} _sd_err]} {
			catch {set_ccopt_property source_driver pc3d01/CIN -clock_tree $ct}
		}
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
