# GDS streamout stage.

set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR config.tcl]

if {![file exists [file join $OUT_DIR ${TOP}_postroute.enc]]} {
    source [file join $SCRIPT_DIR signoff_export.tcl]
}

restoreDesign [file join $OUT_DIR ${TOP}_postroute.enc] $TOP

if {![file exists $STREAMOUT_MAP_FILE]} {
    puts "ERROR: Missing STREAMOUT_MAP at $STREAMOUT_MAP_FILE"
    exit 2
}

if {[llength $GDS_MERGE_FILES] > 0} {
    streamOut [file join $OUT_DIR ${TOP}.gds] -units 1000 -mapFile $STREAMOUT_MAP_FILE \
        -mode ALL -merge $GDS_MERGE_FILES
} else {
    streamOut [file join $OUT_DIR ${TOP}.gds] -units 1000 -mapFile $STREAMOUT_MAP_FILE \
        -mode ALL
}

puts "STREAMOUT_DONE: [file join $OUT_DIR ${TOP}.gds]"
