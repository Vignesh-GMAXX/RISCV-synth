# Shared configuration for microprocessor Genus synthesis.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set ROOT_DIR [file normalize [file join $SCRIPT_DIR ..]]

set TOP [expr {[info exists ::env(TOP)] ? $::env(TOP) : "microprocessor"}]
set CLOCK_NS [expr {[info exists ::env(CLOCK_NS)] ? $::env(CLOCK_NS) : 10.0}]

set RTL_FILELIST [file join $SCRIPT_DIR filelist_microprocessor.f]
set SDC_FILE [file join $ROOT_DIR design microprocessor_genus.sdc]

set OUT_DIR [file join $SCRIPT_DIR outputs]
set RPT_DIR [file join $SCRIPT_DIR reports]
set LOG_DIR [file join $SCRIPT_DIR logs]

if {![info exists ::env(LIB_MAX)] || ![file exists $::env(LIB_MAX)]} {
    puts "ERROR: Set LIB_MAX to an existing max/slow .lib path"
    exit 2
}
if {![info exists ::env(LIB_MIN)] || ![file exists $::env(LIB_MIN)]} {
    puts "ERROR: Set LIB_MIN to an existing min/fast .lib path"
    exit 2
}

set LIB_MAX $::env(LIB_MAX)
set LIB_MIN $::env(LIB_MIN)
