`timescale 1ns/1ps
module Microprocessor_4reg_tb;
    reg CLK100MHZ = 0;
    reg rst = 0; // Reset (active high)
    reg [1:0] mem_bank_sel = 2'b00;
    reg [1:0] dbg_sel = 2'b00;
    wire [31:0] dbg_out;
    wire CLKOUT;

    // Instantiate microprocessor top directly.
    microprocessor uut (
        .clk(CLK100MHZ),
        .rst(rst),
        .mem_bank_sel(mem_bank_sel),
        .dbg_sel(dbg_sel),
        .CLKOUT(CLKOUT),
        .dbg_out(dbg_out)
    );

    // Clock generation (10ns period = 100MHz input clock)
    always #5 CLK100MHZ = ~CLK100MHZ;

    initial begin
        // Initialize reset
        rst = 0;
        #100;
        // Release reset
        rst = 1;
        // Run for enough cycles to execute all instructions
        #1_000_000;
        $finish;
    end
endmodule
