`timescale 1ns/1ps
module netlist_smoke_tb;
    reg clk;
    reg rst;
    reg [1:0] mem_bank_sel;
    reg [1:0] dbg_sel;
    wire CLKOUT;
    wire [31:0] dbg_out;

    microprocessor dut (
        .clk(clk),
        .rst(rst),
        .mem_bank_sel(mem_bank_sel),
        .dbg_sel(dbg_sel),
        .CLKOUT(CLKOUT),
        .dbg_out(dbg_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        mem_bank_sel = 2'b00;
        dbg_sel = 2'b00;

        #20 rst = 1'b1;
        #200;

        $display("SMOKE_DONE CLKOUT=%b DBG=%h", CLKOUT, dbg_out);
        $finish;
    end
endmodule
