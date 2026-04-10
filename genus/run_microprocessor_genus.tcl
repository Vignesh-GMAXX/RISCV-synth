# Genus synthesis run script for microprocessor top.
# Usage:
#   cd genus
#   genus -no_gui -files run_microprocessor_genus.tcl

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config_microprocessor_genus.tcl]

foreach d [list $OUT_DIR $RPT_DIR $LOG_DIR] {
    if {![file exists $d]} { file mkdir $d }
}

set_db init_lib_search_path [list [file dirname $LIB_MAX] [file dirname $LIB_MIN]]
set_db library [list $LIB_MAX $LIB_MIN]
read_libs -max_libs [list $LIB_MAX] -min_libs [list $LIB_MIN]

set_db hdl_error_on_latch true
set_db hdl_track_filename_row_col true
set_db information_level 7

read_hdl -f $RTL_FILELIST
elaborate $TOP
check_design -unresolved

if {[file exists $SDC_FILE]} {
    read_sdc $SDC_FILE
} else {
    puts "WARN: SDC not found at $SDC_FILE. Applying fallback create_clock on clk."
    create_clock -name clk -period $CLOCK_NS [get_ports clk]
}

report_timing -lint -verbose > [file join $RPT_DIR timing_lint_pre.rpt]
report_design_rules > [file join $RPT_DIR drc_pre.rpt]

set_db syn_generic_effort medium
syn_generic
write_hdl > [file join $OUT_DIR ${TOP}_generic.v]
write_sdc > [file join $OUT_DIR ${TOP}_generic.sdc]
report_qor > [file join $RPT_DIR qor_generic.rpt]
report_area > [file join $RPT_DIR area_generic.rpt]
report_timing -max_paths 20 > [file join $RPT_DIR timing_generic.rpt]

set_db syn_map_effort high
syn_map
write_hdl > [file join $OUT_DIR ${TOP}_map.v]
write_sdc > [file join $OUT_DIR ${TOP}_map.sdc]
report_qor > [file join $RPT_DIR qor_map.rpt]
report_area > [file join $RPT_DIR area_map.rpt]
report_timing -max_paths 20 > [file join $RPT_DIR timing_map.rpt]

set_db syn_opt_effort high
syn_opt
write_hdl > [file join $OUT_DIR ${TOP}_final.v]
write_sdc > [file join $OUT_DIR ${TOP}_final.sdc]
write_sdf -version 2.1 > [file join $OUT_DIR ${TOP}_final.sdf]

report_qor > [file join $RPT_DIR qor_final.rpt]
report_area > [file join $RPT_DIR area_final.rpt]
report_timing -max_paths 50 > [file join $RPT_DIR timing_final.rpt]
report_power > [file join $RPT_DIR power_final.rpt]
check_design > [file join $RPT_DIR check_design_final.rpt]

puts "SYNTHESIS_DONE: TOP=$TOP"
