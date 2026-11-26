`timescale 1ns/1ps
module bank_smoke_tb;
    reg clk, rst;
    reg [1:0] mem_bank_sel;
    reg [1:0] dbg_sel;
    wire CLKOUT;
    wire [31:0] dbg_out;
    integer i;

    microprocessor dut(
        .clk(clk),
        .rst(rst),
        .VDDIO(1'b1),
        .VSSIO(1'b0),
        .mem_bank_sel(mem_bank_sel),
        .dbg_sel(dbg_sel),
        .CLKOUT(CLKOUT),
        .dbg_out(dbg_out)
    );

    always #5 clk = ~clk;

    task run_bank;
        input [1:0] bank;
        begin
            mem_bank_sel = bank;
            rst = 0;
            repeat (2) @(posedge clk);
            rst = 1;
            repeat (260) @(posedge clk);

            dbg_sel = 2'b00; #1;
            $display("BANK%0d DBG00=%h", bank, dbg_out);
            dbg_sel = 2'b01; #1;
            $display("BANK%0d DBG01=%h", bank, dbg_out);
            dbg_sel = 2'b10; #1;
            $display("BANK%0d DBG10=%h", bank, dbg_out);
            dbg_sel = 2'b11; #1;
            $display("BANK%0d DBG11=%h", bank, dbg_out);

            $display("BANK%0d REG x10=%h x11=%h x12=%h x13=%h x31=%h", bank,
                dut.u_core.u_decodestage.u_regfile0.register[10],
                dut.u_core.u_decodestage.u_regfile0.register[11],
                dut.u_core.u_decodestage.u_regfile0.register[12],
                dut.u_core.u_decodestage.u_regfile0.register[13],
                dut.u_core.u_decodestage.u_regfile0.register[31]);
            $display("BANK%0d MEM m0=%h m1=%h m2=%h", bank,
                dut.u_data_memory.u_memory.mem[0],
                dut.u_data_memory.u_memory.mem[1],
                dut.u_data_memory.u_memory.mem[2]);
        end
    endtask

    initial begin
        clk = 0;
        rst = 0;
        mem_bank_sel = 2'b00;
        dbg_sel = 2'b00;

        for (i = 0; i < 256; i = i + 1) begin
            dut.u_data_memory.u_memory.mem[i] = 32'b0;
        end

        run_bank(2'b00);
        run_bank(2'b01);
        run_bank(2'b10);
        run_bank(2'b11);

        $finish;
    end
endmodule
