############# GENUS CONSTRAINTS ############
# Top module : microprocessor_pad_top
# Ports:
#   Inputs : clk_pad, rst_pad, mem_bank_sel_pad[1:0], dbg_sel_pad[1:0]
#   Outputs: CLKOUT_pad, dbg_out_pad[31:0]

##### PARAMETERS #####
set_units -time 1.0ns
set_units -capacitance 1.0pF

set CORE_CLOCK_PERIOD 20.000
set CORE_CLOCK_NAME clk_pad

set CORE_SKEW_SETUP [expr $CORE_CLOCK_PERIOD*0.025]
set CORE_SKEW_HOLD  [expr $CORE_CLOCK_PERIOD*0.025]
set CORE_MINRISE    [expr $CORE_CLOCK_PERIOD*0.125]
set CORE_MAXRISE    [expr $CORE_CLOCK_PERIOD*0.200]
set CORE_MINFALL    [expr $CORE_CLOCK_PERIOD*0.125]
set CORE_MAXFALL    [expr $CORE_CLOCK_PERIOD*0.200]

set MIN_PORT_TRANS 0.10
set MAX_PORT_TRANS 0.40

set IN_DELAY_MAX  2.50
set IN_DELAY_MIN  0.50
set OUT_DELAY_MAX 2.50
set OUT_DELAY_MIN 0.50

set CLK_OBJ [get_ports -quiet {clk_pad}]
if {[llength $CLK_OBJ] == 0} {
	error "Port clk_pad not found. This SDC is intended for top microprocessor_pad_top."
}

set RST_PORT [get_ports -quiet {rst_pad}]
if {[llength $RST_PORT] == 0} {
	error "Port rst_pad not found. This SDC is intended for top microprocessor_pad_top."
}

set MBSEL_PORTS [get_ports -quiet {mem_bank_sel_pad[*]}]
if {[llength $MBSEL_PORTS] == 0} {
	error "Port bus mem_bank_sel_pad[*] not found."
}

set DBGSEL_PORTS [get_ports -quiet {dbg_sel_pad[*]}]
if {[llength $DBGSEL_PORTS] == 0} {
	error "Port bus dbg_sel_pad[*] not found."
}

set DBGOUT_PORTS [get_ports -quiet {dbg_out_pad[*]}]
if {[llength $DBGOUT_PORTS] == 0} {
	error "Port bus dbg_out_pad[*] not found."
}

set CLKOUT_PORT [get_ports -quiet {CLKOUT_pad}]
if {[llength $CLKOUT_PORT] == 0} {
	error "Port CLKOUT_pad not found."
}

####### CLOCK CONSTRAINTS #########
create_clock -name "$CORE_CLOCK_NAME" \
	-period "$CORE_CLOCK_PERIOD" \
	-waveform "0 [expr $CORE_CLOCK_PERIOD/2.0]" \
	$CLK_OBJ

# Virtual IO reference clock for external interface timing budgets.
create_clock -name vir_clk_i -period $CORE_CLOCK_PERIOD

# Source latency assumptions (replace with clock-tree estimates when available).
set_clock_latency -source -max [expr $CORE_CLOCK_PERIOD*0.10] -late  [get_clocks $CORE_CLOCK_NAME]
set_clock_latency -source -min [expr $CORE_CLOCK_PERIOD*0.05] -late  [get_clocks $CORE_CLOCK_NAME]
set_clock_latency -source -max [expr $CORE_CLOCK_PERIOD*0.08] -early [get_clocks $CORE_CLOCK_NAME]
set_clock_latency -source -min [expr $CORE_CLOCK_PERIOD*0.04] -early [get_clocks $CORE_CLOCK_NAME]

# Clock transition and uncertainty assumptions.
set_clock_transition -rise -min $CORE_MINRISE [get_clocks $CORE_CLOCK_NAME]
set_clock_transition -rise -max $CORE_MAXRISE [get_clocks $CORE_CLOCK_NAME]
set_clock_transition -fall -min $CORE_MINFALL [get_clocks $CORE_CLOCK_NAME]
set_clock_transition -fall -max $CORE_MAXFALL [get_clocks $CORE_CLOCK_NAME]

set_clock_uncertainty -setup $CORE_SKEW_SETUP [get_clocks $CORE_CLOCK_NAME]
set_clock_uncertainty -hold  $CORE_SKEW_HOLD  [get_clocks $CORE_CLOCK_NAME]

####### IO CONSTRAINTS #########
# Input transition assumptions.
if {[llength $RST_PORT] > 0} {
	set_input_transition -max $MAX_PORT_TRANS $RST_PORT
	set_input_transition -min $MIN_PORT_TRANS $RST_PORT
}
if {[llength $MBSEL_PORTS] > 0} {
	set_input_transition -max $MAX_PORT_TRANS $MBSEL_PORTS
	set_input_transition -min $MIN_PORT_TRANS $MBSEL_PORTS
}
if {[llength $DBGSEL_PORTS] > 0} {
	set_input_transition -max $MAX_PORT_TRANS $DBGSEL_PORTS
	set_input_transition -min $MIN_PORT_TRANS $DBGSEL_PORTS
}

# Input delays for mode-select pins.
if {[llength $RST_PORT] > 0} {
	set_input_delay -add_delay -clock vir_clk_i -max $IN_DELAY_MAX $RST_PORT
	set_input_delay -add_delay -clock vir_clk_i -min $IN_DELAY_MIN $RST_PORT
}
if {[llength $MBSEL_PORTS] > 0} {
	set_input_delay -add_delay -clock vir_clk_i -max $IN_DELAY_MAX $MBSEL_PORTS
	set_input_delay -add_delay -clock vir_clk_i -min $IN_DELAY_MIN $MBSEL_PORTS
}
if {[llength $DBGSEL_PORTS] > 0} {
	set_input_delay -add_delay -clock vir_clk_i -max $IN_DELAY_MAX $DBGSEL_PORTS
	set_input_delay -add_delay -clock vir_clk_i -min $IN_DELAY_MIN $DBGSEL_PORTS
}

# Output delays for debug bus capture at tester/chip boundary.
if {[llength $DBGOUT_PORTS] > 0} {
	set_output_delay -add_delay -clock vir_clk_i -max $OUT_DELAY_MAX $DBGOUT_PORTS
	set_output_delay -add_delay -clock vir_clk_i -min $OUT_DELAY_MIN $DBGOUT_PORTS
}

####### LOAD SPECIFICATIONS ########
if {[llength $DBGOUT_PORTS] > 0} {
	set_load 0.010 $DBGOUT_PORTS
}
if {[llength $CLKOUT_PORT] > 0} {
	set_load 0.005 $CLKOUT_PORT
}

########## FALSE PATHS ###########
# Reset is an asynchronous/static control.
if {[llength $RST_PORT] > 0} {
	set_false_path -from $RST_PORT -to [all_registers]
	set_false_path -from $RST_PORT -to [all_outputs]
}

# Do not time forwarded observation clock as a data output.
if {[llength $CLKOUT_PORT] > 0} {
	set_false_path -to $CLKOUT_PORT
}

# Decouple functional clock domain from virtual IO budgeting clock.
set_false_path -from [get_clocks $CORE_CLOCK_NAME] -to [get_clocks vir_clk_i]

########## GROUP PATHS #########
group_path -name I2R -from [all_inputs]    -to [all_registers]
group_path -name R2O -from [all_registers] -to [all_outputs]
group_path -name R2R -from [all_registers] -to [all_registers]
group_path -name I2O -from [all_inputs]    -to [all_outputs]

# Keep synthesis from creating excessively high fanout pre-CTS.
set_max_fanout 20 [current_design]
