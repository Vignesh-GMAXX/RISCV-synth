# Fill these with your PDK liberty paths before running Genus.
$env:LIB_MAX = "D:/PDK/lib/slow_max.lib"
$env:LIB_MIN = "D:/PDK/lib/fast_min.lib"

# Optional overrides.
$env:TOP = "microprocessor"
$env:CLOCK_NS = "10.0"

# Run from workspace root:
# cd genus
# genus -no_gui -files run_microprocessor_genus.tcl
