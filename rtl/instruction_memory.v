module instruction_memory #(
    parameter INIT_FILE = ""
) (
    input wire        request,
    input wire [7:0]  address,
    input wire [1:0]  bank_sel,
    output reg [31:0] data_out
);
    localparam [31:0] NOP = 32'h00000013;

    wire [4:0] addr_idx;
    // cadence translate_off
    wire [7:0] sim_addr_idx;
    // cadence translate_on
    wire addr_out_of_range;
    reg [31:0] bank_data;

    // cadence translate_off
    // Keep simulation-visible memory arrays for existing TB hierarchical pokes.
    reg [31:0] mem [0:255];
    reg [31:0] mem_bank1 [0:255];
    reg [31:0] mem_bank2 [0:255];
    reg [31:0] mem_bank3 [0:255];
    reg [31:0] sim_bank_data;
    integer i;
    // cadence translate_on

    assign addr_idx = address[4:0];
    // cadence translate_off
    assign sim_addr_idx = address;
    // cadence translate_on
    // Fabrication mode uses 32 words per bank; higher word addresses read NOP.
    assign addr_out_of_range = |address[7:5];

    function automatic [31:0] bank0_rom;
        input [4:0] idx;
        begin
            case (idx)
                5'd0: bank0_rom = 32'h01000093;
                5'd1: bank0_rom = 32'h00500113;
                5'd2: bank0_rom = 32'h00900193;
                5'd3: bank0_rom = 32'h00310233;
                5'd4: bank0_rom = 32'h402202B3;
                5'd5: bank0_rom = 32'h00211333;
                5'd6: bank0_rom = 32'h003123B3;
                5'd7: bank0_rom = 32'h00313433;
                5'd8: bank0_rom = 32'h003144B3;
                5'd9: bank0_rom = 32'h00235533;
                5'd10: bank0_rom = 32'hFF000713;
                5'd11: bank0_rom = 32'h402755B3;
                5'd12: bank0_rom = 32'h00316633;
                5'd13: bank0_rom = 32'h003176B3;
                5'd14: bank0_rom = 32'h00710793;
                5'd15: bank0_rom = 32'h00211813;
                5'd16: bank0_rom = 32'h00612893;
                5'd17: bank0_rom = 32'h00613913;
                5'd18: bank0_rom = 32'h00314993;
                5'd19: bank0_rom = 32'h00235A13;
                5'd20: bank0_rom = 32'h40275A93;
                5'd21: bank0_rom = 32'h00816B13;
                5'd22: bank0_rom = 32'h0081FB93;
                5'd23: bank0_rom = 32'h12345C37;
                5'd24: bank0_rom = 32'h00001C97;
                5'd25: bank0_rom = 32'h0040A023;
                5'd26: bank0_rom = 32'h00509223;
                5'd27: bank0_rom = 32'h00308423;
                5'd28: bank0_rom = 32'h0000AD03;
                5'd29: bank0_rom = 32'h00409D83;
                5'd30: bank0_rom = 32'h00808E03;
                5'd31: bank0_rom = 32'h0000006F;
                default: bank0_rom = NOP;
            endcase
        end
    endfunction

    function automatic [31:0] bank1_rom;
        input [4:0] idx;
        begin
            case (idx)
                5'd0: bank1_rom = 32'h00500093;
                5'd1: bank1_rom = 32'h00500113;
                5'd2: bank1_rom = 32'h00100193;
                5'd3: bank1_rom = 32'h00000F93;
                5'd4: bank1_rom = 32'h00208663;
                5'd5: bank1_rom = 32'h001F8F93;
                5'd6: bank1_rom = 32'h001F8F93;
                5'd7: bank1_rom = 32'h00209463;
                5'd8: bank1_rom = 32'h002F8F93;
                5'd9: bank1_rom = 32'h0021C463;
                5'd10: bank1_rom = 32'h004F8F93;
                5'd11: bank1_rom = 32'h00115463;
                5'd12: bank1_rom = 32'h008F8F93;
                5'd13: bank1_rom = 32'h0021E463;
                5'd14: bank1_rom = 32'h010F8F93;
                5'd15: bank1_rom = 32'h00317463;
                5'd16: bank1_rom = 32'h020F8F93;
                5'd17: bank1_rom = 32'h00000717;
                5'd18: bank1_rom = 32'h00C0036F;
                5'd19: bank1_rom = 32'h040F8F93;
                5'd20: bank1_rom = 32'h040F8F93;
                5'd21: bank1_rom = 32'h04D00793;
                5'd22: bank1_rom = 32'h01C703E7;
                5'd23: bank1_rom = 32'h040F8F93;
                5'd24: bank1_rom = 32'h05800813;
                5'd25: bank1_rom = 32'h00000463;
                5'd26: bank1_rom = 32'h040F8F93;
                5'd27: bank1_rom = 32'h06300893;
                5'd28: bank1_rom = 32'h0000006F;
                default: bank1_rom = NOP;
            endcase
        end
    endfunction

    function automatic [31:0] bank2_rom;
        input [4:0] idx;
        begin
            case (idx)
                5'd0: bank2_rom = 32'h00700093;
                5'd1: bank2_rom = 32'h00900113;
                5'd2: bank2_rom = 32'h002081B3;
                5'd3: bank2_rom = 32'h40118233;
                5'd4: bank2_rom = 32'h00520293;
                5'd5: bank2_rom = 32'h00502023;
                5'd6: bank2_rom = 32'h00002303;
                5'd7: bank2_rom = 32'h002303B3;
                5'd8: bank2_rom = 32'h00138413;
                5'd9: bank2_rom = 32'h003404B3;
                5'd10: bank2_rom = 32'h00902223;
                5'd11: bank2_rom = 32'h00402503;
                5'd12: bank2_rom = 32'h00950463;
                5'd13: bank2_rom = 32'h06300593;
                5'd14: bank2_rom = 32'h03700593;
                5'd15: bank2_rom = 32'h00300613;
                5'd16: bank2_rom = 32'h00B606B3;
                5'd17: bank2_rom = 32'h00D02423;
                5'd18: bank2_rom = 32'h00802703;
                5'd19: bank2_rom = 32'h001707B3;
                5'd20: bank2_rom = 32'h00078A13;
                5'd21: bank2_rom = 32'h00050A93;
                5'd22: bank2_rom = 32'h00030B13;
                5'd23: bank2_rom = 32'h0000006F;
                default: bank2_rom = NOP;
            endcase
        end
    endfunction

    function automatic [31:0] bank3_rom;
        input [4:0] idx;
        begin
            case (idx)
                5'd0: bank3_rom = 32'h00A00093;
                5'd1: bank3_rom = 32'h00000113;
                5'd2: bank3_rom = 32'h00100193;
                5'd3: bank3_rom = 32'h00000213;
                5'd4: bank3_rom = 32'h00120C63;
                5'd5: bank3_rom = 32'h003102B3;
                5'd6: bank3_rom = 32'h00018113;
                5'd7: bank3_rom = 32'h00028193;
                5'd8: bank3_rom = 32'h00120213;
                5'd9: bank3_rom = 32'hFEDFF06F;
                5'd10: bank3_rom = 32'h00202023;
                5'd11: bank3_rom = 32'h00010513;
                5'd12: bank3_rom = 32'h00018593;
                5'd13: bank3_rom = 32'h00020613;
                5'd14: bank3_rom = 32'h00008693;
                5'd15: bank3_rom = 32'h0000006F;
                default: bank3_rom = NOP;
            endcase
        end
    endfunction

    always @(*) begin
        case (bank_sel)
            2'b00: bank_data = bank0_rom(addr_idx);
            2'b01: bank_data = bank1_rom(addr_idx);
            2'b10: bank_data = bank2_rom(addr_idx);
            2'b11: bank_data = bank3_rom(addr_idx);
            default: bank_data = NOP;
        endcase
    end

    // cadence translate_off
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i]       = NOP;
            mem_bank1[i] = NOP;
            mem_bank2[i] = NOP;
            mem_bank3[i] = NOP;
        end

        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
        else begin
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
    end

    always @(*) begin
        case (bank_sel)
            2'b00: sim_bank_data = mem[sim_addr_idx];
            2'b01: sim_bank_data = mem_bank1[sim_addr_idx];
            2'b10: sim_bank_data = mem_bank2[sim_addr_idx];
            2'b11: sim_bank_data = mem_bank3[sim_addr_idx];
            default: sim_bank_data = mem[sim_addr_idx];
        endcase
    end
    // cadence translate_on

    always @(*) begin
        if (request) begin
            data_out = NOP;
            if (addr_out_of_range) begin
                data_out = NOP;
            end
            else begin
                data_out = bank_data;
            end
            // cadence translate_off
            data_out = sim_bank_data;
            // cadence translate_on
        end
        else begin
            data_out = 32'b0;
        end
    end

endmodule