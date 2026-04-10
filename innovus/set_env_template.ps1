# Fill these environment variables before running Innovus.
$env:TOP = "microprocessor"

$env:PNR_NETLIST = "D:/work/FPGA_f/genus/outputs/microprocessor_final.v"
$env:PNR_SDC = "D:/work/FPGA_f/genus/outputs/microprocessor_final.sdc"

$env:LEF_TECH = "D:/PDK/lef/tech.lef"
$env:LEF_CELL = "D:/PDK/lef/stdcell.lef"
# Optional
$env:LEF_MACRO = ""

$env:LIB_MAX = "D:/PDK/lib/slow_max.lib"
$env:LIB_MIN = "D:/PDK/lib/fast_min.lib"
$env:QRC_TECH_FILE = "D:/PDK/qrc/qrcTechFile.tch"
$env:STREAMOUT_MAP = "D:/PDK/gds/streamout.map"

# Optional floorplan and power defaults
$env:SITE_NAME = "core"
$env:CORE_UTIL = "0.65"
$env:CORE_ASPECT_RATIO = "1.0"
$env:CORE_MARGIN_L = "20"
$env:CORE_MARGIN_R = "20"
$env:CORE_MARGIN_B = "20"
$env:CORE_MARGIN_T = "20"

$env:POWER_NET = "VDD"
$env:GROUND_NET = "VSS"

$env:ROUTING_BOTTOM = "M1"
$env:ROUTING_TOP = "M6"
$env:PWR_RING_LAYER_H = "M6"
$env:PWR_RING_LAYER_V = "M5"
$env:STRIPE_LAYER = "M5"

# Run:
# cd innovus
# innovus -no_gui -init run_microprocessor_innovus.tcl
