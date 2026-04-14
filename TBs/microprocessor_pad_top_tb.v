`timescale 1ns/1ps

`ifndef PC3D01_STUB
`define PC3D01_STUB
module pc3d01(input wire PAD, output wire CIN);
    assign CIN = PAD;
endmodule
`endif

`ifndef PC3O05_STUB
`define PC3O05_STUB
module pc3o05(input wire I, output wire PAD);
    assign PAD = I;
endmodule
`endif

`ifndef PVDI_STUB
`define PVDI_STUB
module pvdi(); endmodule
`endif

`ifndef PV0I_STUB
`define PV0I_STUB
module pv0i(); endmodule
`endif

`ifndef PVDA_STUB
`define PVDA_STUB
module pvda(); endmodule
`endif

`ifndef PV0A_STUB
`define PV0A_STUB
module pv0a(); endmodule
`endif

`ifndef PFRELR_STUB
`define PFRELR_STUB
module pfrelr(); endmodule
`endif

module microprocessor_pad_top_tb;
    reg clk_pad = 1'b0;
    reg rst_pad = 1'b0;
    reg [1:0] mem_bank_sel_pad = 2'b00;
    reg [1:0] dbg_sel_pad = 2'b00;

    wire CLKOUT_pad;
    wire [31:0] dbg_out_pad;

    integer errors;
    integer idx;

    reg seen_instr_req;
    reg seen_instr_valid;
    reg seen_data_req;
    reg seen_data_we;
    reg seen_load;
    reg seen_branch_or_jump;

    reg prev_instr_req;
    reg prev_instr_valid;
    reg prev_data_req;
    reg prev_data_we;
    reg prev_load;
    reg prev_branch_or_jump;

    microprocessor_pad_top dut (
        .clk_pad(clk_pad),
        .rst_pad(rst_pad),
        .mem_bank_sel_pad(mem_bank_sel_pad),
        .dbg_sel_pad(dbg_sel_pad),
        .CLKOUT_pad(CLKOUT_pad),
        .dbg_out_pad(dbg_out_pad)
    );

    always #5 clk_pad = ~clk_pad;

    always @(posedge clk_pad) begin
        if (rst_pad) begin
            if (dut.u_microprocessor_core.instruction_mem_request) seen_instr_req <= 1'b1;
            if (dut.u_microprocessor_core.instruc_mem_valid) seen_instr_valid <= 1'b1;
            if (dut.u_microprocessor_core.data_mem_request) seen_data_req <= 1'b1;
            if (dut.u_microprocessor_core.data_mem_we_re) seen_data_we <= 1'b1;
            if (dut.u_microprocessor_core.load_signal) seen_load <= 1'b1;
            if (dut.u_microprocessor_core.u_core.branch_result_execute ||
                dut.u_microprocessor_core.u_core.next_sel_execute ||
                dut.u_microprocessor_core.u_core.jalr_execute) begin
                seen_branch_or_jump <= 1'b1;
            end
        end

        prev_instr_req <= dut.u_microprocessor_core.instruction_mem_request;
        prev_instr_valid <= dut.u_microprocessor_core.instruc_mem_valid;
        prev_data_req <= dut.u_microprocessor_core.data_mem_request;
        prev_data_we <= dut.u_microprocessor_core.data_mem_we_re;
        prev_load <= dut.u_microprocessor_core.load_signal;
        prev_branch_or_jump <= (dut.u_microprocessor_core.u_core.branch_result_execute ||
                                dut.u_microprocessor_core.u_core.next_sel_execute ||
                                dut.u_microprocessor_core.u_core.jalr_execute);
    end

    task clear_data_mem;
        begin
            for (idx = 0; idx < 32; idx = idx + 1) begin
                dut.u_microprocessor_core.u_data_memory.u_memory.mem[idx] = 32'b0;
            end
        end
    endtask

    task clear_seen_flags;
        begin
            seen_instr_req = 1'b0;
            seen_instr_valid = 1'b0;
            seen_data_req = 1'b0;
            seen_data_we = 1'b0;
            seen_load = 1'b0;
            seen_branch_or_jump = 1'b0;
            prev_instr_req = 1'b0;
            prev_instr_valid = 1'b0;
            prev_data_req = 1'b0;
            prev_data_we = 1'b0;
            prev_load = 1'b0;
            prev_branch_or_jump = 1'b0;
        end
    endtask

    task check_dbg_mux;
        input [31:0] expected_dbg;
        input [8*24:1] tag;
        begin
            @(posedge clk_pad);
            #1;
            if (dbg_out_pad !== expected_dbg) begin
                $display("FAIL: %0s dbg_out_pad expected=%h actual=%h", tag, expected_dbg, dbg_out_pad);
                errors = errors + 1;
            end
            if (dbg_out_pad !== dut.u_microprocessor_core.dbg_out) begin
                $display("FAIL: %0s pad/core dbg mismatch pad=%h core=%h", tag, dbg_out_pad, dut.u_microprocessor_core.dbg_out);
                errors = errors + 1;
            end
            if (CLKOUT_pad !== clk_pad) begin
                $display("FAIL: %0s CLKOUT mismatch clk_pad=%b CLKOUT_pad=%b", tag, clk_pad, CLKOUT_pad);
                errors = errors + 1;
            end
        end
    endtask

    task require_flag;
        input flag_value;
        input [8*40:1] flag_name;
        input [1:0] bank;
        begin
            if (!flag_value) begin
                $display("FAIL: bank=%0d expected signal activity for %0s", bank, flag_name);
                errors = errors + 1;
            end
        end
    endtask

    task run_bank;
        input [1:0] bank;
        input [31:0] exp_dbg0;
        input [31:0] exp_dbg1;
        input [31:0] exp_dbg2;
        input [31:0] exp_dbg3;
        input req_data_path;
        input req_load;
        input req_ctrl_path;
        input check_mem0;
        input [31:0] exp_mem0;
        begin
            mem_bank_sel_pad = bank;
            dbg_sel_pad = 2'b00;
            rst_pad = 1'b0;
            clear_seen_flags();
            clear_data_mem();

            repeat (4) @(posedge clk_pad);
            rst_pad = 1'b1;

            repeat (220) @(posedge clk_pad);

            dbg_sel_pad = 2'b00;
            check_dbg_mux(exp_dbg0, "dbg_sel=00");
            dbg_sel_pad = 2'b01;
            check_dbg_mux(exp_dbg1, "dbg_sel=01");
            dbg_sel_pad = 2'b10;
            check_dbg_mux(exp_dbg2, "dbg_sel=10");
            dbg_sel_pad = 2'b11;
            check_dbg_mux(exp_dbg3, "dbg_sel=11");

            require_flag(seen_instr_req, "instruction_mem_request", bank);
            require_flag(seen_instr_valid, "instruc_mem_valid", bank);

            if (req_data_path) begin
                require_flag(seen_data_req, "data_mem_request", bank);
                require_flag(seen_data_we, "data_mem_we_re", bank);
            end

            if (req_load) begin
                require_flag(seen_load, "load_signal", bank);
            end

            if (req_ctrl_path) begin
                require_flag(seen_branch_or_jump, "branch/jump activity", bank);
            end

            if (check_mem0) begin
                if (dut.u_microprocessor_core.u_data_memory.u_memory.mem[0] !== exp_mem0) begin
                    $display("FAIL: bank=%0d mem[0] expected=%h actual=%h", bank, exp_mem0,
                        dut.u_microprocessor_core.u_data_memory.u_memory.mem[0]);
                    errors = errors + 1;
                end
            end

            $display("INFO: bank=%0d done dbg0=%h dbg1=%h dbg2=%h dbg3=%h", bank, exp_dbg0, exp_dbg1, exp_dbg2, exp_dbg3);
        end
    endtask

    initial begin
        errors = 0;

        // Bank 0: datapath + store/load mix
        run_bank(2'b00, 32'h00000000, 32'h0301C420, 32'h00000013, 32'hE9500000,
                 1'b1, 1'b1, 1'b0, 1'b0, 32'h00000000);

        // Bank 1: control-heavy branch/jump mix
        run_bank(2'b01, 32'h00000000, 32'h0301C41D, 32'h00000013, 32'h01550000,
                 1'b0, 1'b0, 1'b1, 1'b0, 32'h00000000);

        // Bank 2: data-memory and forwarding-heavy sequence
        run_bank(2'b10, 32'h3A033711, 32'h05018017, 32'h00000013, 32'h90970000,
                 1'b1, 1'b1, 1'b1, 1'b1, 32'h0000000E);

        // Bank 3: loop/control path with final store result
        run_bank(2'b11, 32'h0A0A5937, 32'h0501800F, 32'h00000013, 32'hA97A0000,
                 1'b1, 1'b0, 1'b1, 1'b1, 32'h00000037);

        if (errors == 0) begin
            $display("RESULT: PASS (microprocessor_pad_top all 4 hardwired banks)");
        end
        else begin
            $display("RESULT: FAIL (%0d checks failed)", errors);
        end

        $finish;
    end
endmodule
