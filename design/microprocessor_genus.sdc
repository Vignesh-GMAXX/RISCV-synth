############# GENUS CONSTRAINTS ############
# Top module : microprocessor
# Ports:
#   Inputs : clk, rst, mem_bank_sel[1:0], dbg_sel[1:0]
#   Outputs: CLKOUT, dbg_out[31:0]

##### PARAMETERS #####
set_units -time 1.0ns
set_units -capacitance 1.0pF

set CORE_CLOCK_PERIOD 10.000
set CORE_CLOCK_NAME clk

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

####### CLOCK CONSTRAINTS #########
create_clock -name "$CORE_CLOCK_NAME" \
	-period "$CORE_CLOCK_PERIOD" \
	-waveform "0 [expr $CORE_CLOCK_PERIOD/2.0]" \
	[get_ports {clk}]

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
set_input_transition -max $MAX_PORT_TRANS [get_ports {rst mem_bank_sel[*] dbg_sel[*]}]
set_input_transition -min $MIN_PORT_TRANS [get_ports {rst mem_bank_sel[*] dbg_sel[*]}]

# Input delays for mode-select pins.
set_input_delay -add_delay -clock vir_clk_i -max $IN_DELAY_MAX [get_ports {mem_bank_sel[*] dbg_sel[*]}]
set_input_delay -add_delay -clock vir_clk_i -min $IN_DELAY_MIN [get_ports {mem_bank_sel[*] dbg_sel[*]}]

# Output delays for debug bus capture at tester/chip boundary.
set_output_delay -add_delay -clock vir_clk_i -max $OUT_DELAY_MAX [get_ports {dbg_out[*]}]
set_output_delay -add_delay -clock vir_clk_i -min $OUT_DELAY_MIN [get_ports {dbg_out[*]}]

####### LOAD SPECIFICATIONS ########
set_load 0.010 [get_ports {dbg_out[*]}]
set_load 0.005 [get_ports {CLKOUT}]

########## FALSE PATHS ###########
# Reset is an asynchronous/static control.
set_false_path -from [get_ports {rst}]   -to [all_registers]

# Do not time forwarded observation clock as a data output.
set_false_path -to [get_ports {CLKOUT}]

# Decouple functional clock domain from virtual IO budgeting clock.
set_false_path -from [get_clocks $CORE_CLOCK_NAME] -to [get_clocks vir_clk_i]

########## GROUP PATHS #########
group_path -name I2R -from [all_inputs]    -to [all_registers]
group_path -name R2O -from [all_registers] -to [all_outputs]
group_path -name R2R -from [all_registers] -to [all_registers]
group_path -name I2O -from [all_inputs]    -to [all_outputs]

# Keep synthesis from creating excessively high fanout pre-CTS.
set_max_fanout 20 [current_design]
