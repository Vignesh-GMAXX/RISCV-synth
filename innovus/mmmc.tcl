# MMMC setup for microprocessor Innovus flow.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

create_library_set -name LIBSET_MAX -timing [list $LIB_MAX]
create_library_set -name LIBSET_MIN -timing [list $LIB_MIN]

create_rc_corner -name RC_TYP -qx_tech_file $QRC_TECH_FILE

create_delay_corner -name DC_MAX -library_set LIBSET_MAX -rc_corner RC_TYP
create_delay_corner -name DC_MIN -library_set LIBSET_MIN -rc_corner RC_TYP

create_constraint_mode -name CONSTRAINT_FUNC -sdc_files [list $SDC_FILE]

create_analysis_view -name VIEW_SETUP -constraint_mode CONSTRAINT_FUNC -delay_corner DC_MAX
create_analysis_view -name VIEW_HOLD -constraint_mode CONSTRAINT_FUNC -delay_corner DC_MIN

set_analysis_view -setup {VIEW_SETUP} -hold {VIEW_HOLD}
