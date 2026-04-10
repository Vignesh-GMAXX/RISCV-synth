module instruction_memory #(
    parameter INIT_FILE = ""
) (
    input wire        clk,
    input wire        request,
    input wire [7:0]  address,
    input wire [1:0]  bank_sel,
    output reg [31:0] data_out
);
    // Keep bank0 name as "mem" so existing testbenches can still poke instructions.
    reg [31:0] mem [0:127];
    reg [31:0] mem_bank1 [0:127];
    reg [31:0] mem_bank2 [0:127];
    reg [31:0] mem_bank3 [0:127];

    wire [4:0] addr_idx;
    wire addr_out_of_range;
    integer i;

    assign addr_idx = address[4:0];
    // Fabrication mode uses 32 words per bank; higher word addresses read NOP.
    assign addr_out_of_range = |address[7:5];

    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            mem[i]       = 32'h00000013; // NOP default
            mem_bank1[i] = 32'h00000013;
            mem_bank2[i] = 32'h00000013;
            mem_bank3[i] = 32'h00000013;
        end

        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
        else begin
            // Bank0: RV32I data-path coverage (R/I/S/U + memory readback).
            mem[0] = 32'h01000093;
            mem[1] = 32'h00500113;
            mem[2] = 32'h00900193;
            mem[3] = 32'h00310233;
            mem[4] = 32'h402202B3;
            mem[5] = 32'h00211333;
            mem[6] = 32'h003123B3;
            mem[7] = 32'h00313433;
            mem[8] = 32'h003144B3;
            mem[9] = 32'h00235533;
            mem[10] = 32'hFF000713;
            mem[11] = 32'h402755B3;
            mem[12] = 32'h00316633;
            mem[13] = 32'h003176B3;
            mem[14] = 32'h00710793;
            mem[15] = 32'h00211813;
            mem[16] = 32'h00612893;
            mem[17] = 32'h00613913;
            mem[18] = 32'h00314993;
            mem[19] = 32'h00235A13;
            mem[20] = 32'h40275A93;
            mem[21] = 32'h00816B13;
            mem[22] = 32'h0081FB93;
            mem[23] = 32'h12345C37;
            mem[24] = 32'h00001C97;
            mem[25] = 32'h0040A023;
            mem[26] = 32'h00509223;
            mem[27] = 32'h00308423;
            mem[28] = 32'h0000AD03;
            mem[29] = 32'h00409D83;
            mem[30] = 32'h00808E03;
            mem[31] = 32'h0000006F;
        end

        // Bank1: branch/jump + control-hazard stress.
        mem_bank1[0] = 32'h00500093;
        mem_bank1[1] = 32'h00500113;
        mem_bank1[2] = 32'h00100193;
        mem_bank1[3] = 32'h00000F93;
        mem_bank1[4] = 32'h00208663;
        mem_bank1[5] = 32'h001F8F93;
        mem_bank1[6] = 32'h001F8F93;
        mem_bank1[7] = 32'h00209463;
        mem_bank1[8] = 32'h002F8F93;
        mem_bank1[9] = 32'h0021C463;
        mem_bank1[10] = 32'h004F8F93;
        mem_bank1[11] = 32'h00115463;
        mem_bank1[12] = 32'h008F8F93;
        mem_bank1[13] = 32'h0021E463;
        mem_bank1[14] = 32'h010F8F93;
        mem_bank1[15] = 32'h00317463;
        mem_bank1[16] = 32'h020F8F93;
        mem_bank1[17] = 32'h00000717;
        mem_bank1[18] = 32'h00C0036F;
        mem_bank1[19] = 32'h040F8F93;
        mem_bank1[20] = 32'h040F8F93;
        mem_bank1[21] = 32'h04D00793;
        mem_bank1[22] = 32'h01C703E7;
        mem_bank1[23] = 32'h040F8F93;
        mem_bank1[24] = 32'h05800813;
        mem_bank1[25] = 32'h00000463;
        mem_bank1[26] = 32'h040F8F93;
        mem_bank1[27] = 32'h06300893;
        mem_bank1[28] = 32'h0000006F;
        mem_bank1[29] = 32'h00000013;
        mem_bank1[30] = 32'h00000013;
        mem_bank1[31] = 32'h00000013;

        // Bank2: load-use/RAW/store-forwarding hazard checks.
        mem_bank2[0] = 32'h00700093;
        mem_bank2[1] = 32'h00900113;
        mem_bank2[2] = 32'h002081B3;
        mem_bank2[3] = 32'h40118233;
        mem_bank2[4] = 32'h00520293;
        mem_bank2[5] = 32'h00502023;
        mem_bank2[6] = 32'h00002303;
        mem_bank2[7] = 32'h002303B3;
        mem_bank2[8] = 32'h00138413;
        mem_bank2[9] = 32'h003404B3;
        mem_bank2[10] = 32'h00902223;
        mem_bank2[11] = 32'h00402503;
        mem_bank2[12] = 32'h00950463;
        mem_bank2[13] = 32'h06300593;
        mem_bank2[14] = 32'h03700593;
        mem_bank2[15] = 32'h00300613;
        mem_bank2[16] = 32'h00B606B3;
        mem_bank2[17] = 32'h00D02423;
        mem_bank2[18] = 32'h00802703;
        mem_bank2[19] = 32'h001707B3;
        mem_bank2[20] = 32'h00078A13;
        mem_bank2[21] = 32'h00050A93;
        mem_bank2[22] = 32'h00030B13;
        mem_bank2[23] = 32'h0000006F;
        mem_bank2[24] = 32'h00000013;
        mem_bank2[25] = 32'h00000013;
        mem_bank2[26] = 32'h00000013;
        mem_bank2[27] = 32'h00000013;
        mem_bank2[28] = 32'h00000013;
        mem_bank2[29] = 32'h00000013;
        mem_bank2[30] = 32'h00000013;
        mem_bank2[31] = 32'h00000013;

        // Bank3: mixed algorithm program (iterative Fibonacci, n=10).
        mem_bank3[0] = 32'h00A00093;
        mem_bank3[1] = 32'h00000113;
        mem_bank3[2] = 32'h00100193;
        mem_bank3[3] = 32'h00000213;
        mem_bank3[4] = 32'h00120C63;
        mem_bank3[5] = 32'h003102B3;
        mem_bank3[6] = 32'h00018113;
        mem_bank3[7] = 32'h00028193;
        mem_bank3[8] = 32'h00120213;
        mem_bank3[9] = 32'hFEDFF06F;
        mem_bank3[10] = 32'h00202023;
        mem_bank3[11] = 32'h00010513;
        mem_bank3[12] = 32'h00018593;
        mem_bank3[13] = 32'h00020613;
        mem_bank3[14] = 32'h00008693;
        mem_bank3[15] = 32'h0000006F;
        mem_bank3[16] = 32'h00000013;
        mem_bank3[17] = 32'h00000013;
        mem_bank3[18] = 32'h00000013;
        mem_bank3[19] = 32'h00000013;
        mem_bank3[20] = 32'h00000013;
        mem_bank3[21] = 32'h00000013;
        mem_bank3[22] = 32'h00000013;
        mem_bank3[23] = 32'h00000013;
        mem_bank3[24] = 32'h00000013;
        mem_bank3[25] = 32'h00000013;
        mem_bank3[26] = 32'h00000013;
        mem_bank3[27] = 32'h00000013;
        mem_bank3[28] = 32'h00000013;
        mem_bank3[29] = 32'h00000013;
        mem_bank3[30] = 32'h00000013;
        mem_bank3[31] = 32'h00000013;
    end

    always @(*) begin
        if (request) begin
            if (addr_out_of_range) begin
                data_out = 32'h00000013;
            end
            else begin
                case (bank_sel)
                    2'b00: data_out = mem[addr_idx];
                    2'b01: data_out = mem_bank1[addr_idx];
                    2'b10: data_out = mem_bank2[addr_idx];
                    2'b11: data_out = mem_bank3[addr_idx];
                    default: data_out = mem[addr_idx];
                endcase
            end
        end
        else begin
            data_out = 32'b0;
        end
    end

endmodule