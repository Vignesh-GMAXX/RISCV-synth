# SDC timing constraints for basys3_top
# Note: SDC covers timing only. Keep using XDC for pin/package/IOSTANDARD constraints.

# 100 MHz board oscillator on CLK100MHZ
create_clock -name clk100 -period 10.000 [get_ports {CLK100MHZ}]

# Generated CPU clock path in implementation mode:
# CLK100MHZ -> clock_divider (divide by 100,000,000) -> BUFG -> cpu_clk
# For IMPLEMENTATION_TOGGLE_COUNT=50_000_000, cpu_clk is 1 Hz.
create_generated_clock -name cpu_clk \
    -source [get_ports {CLK100MHZ}] \
    -divide_by 100000000 \
    [get_pins {u_cpu_clk_bufg/O}]

# Reset comes from a manual switch and is asynchronous to clk100/cpu_clk.
# Exclude reset timing from setup/hold analysis.
set_false_path -from [get_ports {rst}]
