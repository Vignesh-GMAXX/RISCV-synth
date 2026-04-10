`timescale 1ns/1ps
module FPGA_TB;
    reg CLK100MHZ = 0;
    reg rst = 0;
    wire [15:0] LED;

    integer pass_count = 0;
    integer fail_count = 0;

    // Use simulation clock during simulation and load instructions from tb/instr.mem.
    basys3_top #(
        .USE_SIMULATION_CLOCK(1),
        .IMPLEMENTATION_TOGGLE_COUNT(2),
        .INSTR_MEM_FILE("instr_max5.mem")
    ) uut (
        .CLK100MHZ(CLK100MHZ),
        .rst(rst),
        .LED(LED)
    );

    always #5 CLK100MHZ = ~CLK100MHZ;

    task automatic check_true;
        input cond;
        input [1023:0] msg;
        begin
            if (cond) begin
                pass_count = pass_count + 1;
                $display("PASS: %0s", msg);
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0s", msg);
            end
        end
    endtask

    initial begin
        // Hold reset
        rst = 0;
        repeat (3) @(posedge CLK100MHZ);

        // Release reset
        rst = 1;

        // Allow sort-5 program in instr.mem to execute fully.
        repeat (260) @(posedge CLK100MHZ);

        // Program seeds mem with [23,7,31,4,18], sorts ascending, then stores back.
        // Final registers x1..x5: [4,7,18,23,31]
        check_true(uut.u_microprocessor0.u_core.u_decodestage.u_regfile0.register[1] == 32'd4,
               "x1 should be sorted value 4");
        check_true(uut.u_microprocessor0.u_core.u_decodestage.u_regfile0.register[2] == 32'd7,
               "x2 should be sorted value 7");
        check_true(uut.u_microprocessor0.u_core.u_decodestage.u_regfile0.register[3] == 32'd18,
               "x3 should be sorted value 18");
        check_true(uut.u_microprocessor0.u_core.u_decodestage.u_regfile0.register[4] == 32'd23,
               "x4 should be sorted value 23");
        check_true(uut.u_microprocessor0.u_core.u_decodestage.u_regfile0.register[5] == 32'd31,
               "x5 should be sorted value 31");

        check_true(uut.u_microprocessor0.u_data_memory.u_memory.mem[0] == 32'd4,
               "mem[0] should be sorted value 4");
        check_true(uut.u_microprocessor0.u_data_memory.u_memory.mem[1] == 32'd7,
               "mem[1] should be sorted value 7");
        check_true(uut.u_microprocessor0.u_data_memory.u_memory.mem[2] == 32'd18,
               "mem[2] should be sorted value 18");
        check_true(uut.u_microprocessor0.u_data_memory.u_memory.mem[3] == 32'd23,
               "mem[3] should be sorted value 23");
        check_true(uut.u_microprocessor0.u_data_memory.u_memory.mem[4] == 32'd31,
               "mem[4] should be sorted value 31");

        // LED shows low nibbles of x1..x4 packed as {x4,x3,x2,x1} => {7,2,7,4}
        check_true(LED === 16'h7274, "LED nibble view should match sorted x4..x1");

        if (fail_count == 0) begin
            $display("RESULT: PASS (%0d checks)", pass_count);
        end
        else begin
            $display("RESULT: FAIL (%0d pass, %0d fail)", pass_count, fail_count);
        end

        $finish;
    end

endmodule
