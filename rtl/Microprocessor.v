`timescale 1ns/1ps
module microprocessor #(
    parameter INSTR_MEM_FILE = ""
) (
    input wire clk,
    input wire rst,
    input wire [1:0] mem_bank_sel,
    input wire [1:0] dbg_sel,

    output wire CLKOUT,
    output reg [31:0] dbg_out
    );

    wire [31:0] instruction_data;
    wire [31:0] pc_address;
    wire [31:0] load_data_out;
    wire [31:0] alu_out_address;
    wire [31:0] store_data;
    wire [3:0]  mask;
    wire instruction_mem_request;
    wire instruc_mem_valid;
    wire data_mem_valid;
    wire data_mem_we_re;
    wire data_mem_request;
    wire load_signal;
    wire [15:0] x1_to_x4_nibbles;
    wire [31:0] x10_to_x13_bytes;
    wire [7:0]  ifid_pc_word;
    wire [31:0] ifid_instruction;
    wire [23:0] control_status;
    wire [31:0] alu_mem_bytes;
    wire [31:0] control_pc_view;
    reg [31:0] dbg_out_next;
    reg [1:0] mem_bank_sel_safe;
    reg [1:0] dbg_sel_safe;

    // Export a buffered copy of the processor clock for package-level observability.
    assign CLKOUT = clk;

    assign control_pc_view = {control_status, ifid_pc_word};

    always @(*) begin
        case (mem_bank_sel)
            2'b00: mem_bank_sel_safe = 2'b00;
            2'b01: mem_bank_sel_safe = 2'b01;
            2'b10: mem_bank_sel_safe = 2'b10;
            2'b11: mem_bank_sel_safe = 2'b11;
            default: mem_bank_sel_safe = 2'b00;
        endcase
    end

    always @(*) begin
        case (dbg_sel)
            2'b00: dbg_sel_safe = 2'b00;
            2'b01: dbg_sel_safe = 2'b01;
            2'b10: dbg_sel_safe = 2'b10;
            2'b11: dbg_sel_safe = 2'b11;
            default: dbg_sel_safe = 2'b00;
        endcase
    end

    always @(*) begin
        case (dbg_sel_safe)
            2'b00: dbg_out_next = x10_to_x13_bytes;
            2'b01: dbg_out_next = control_pc_view;
            2'b10: dbg_out_next = ifid_instruction;
            2'b11: dbg_out_next = {x1_to_x4_nibbles, alu_mem_bytes[15:0]};
            default: dbg_out_next = 32'b0;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            dbg_out <= 32'b0;
        end
        else begin
            dbg_out <= dbg_out_next;
        end
    end

    // INSTRUCTION MEMORY
    instruc_mem_top #(
        .INIT_FILE(INSTR_MEM_FILE)
    )u_instruction_memory(
        .clk(clk),
        .rst(rst),
        .request(instruction_mem_request),
        .bank_sel(mem_bank_sel_safe),
        .address(pc_address[9:2]),
        .valid(instruc_mem_valid),
        .data_out(instruction_data)
    );

    //CORE
    core u_core(
        .clk(clk),
        .rst(rst),
        .instruction(instruction_data),
        .load_data_in(load_data_out),
        .mask_singal(mask),
        .load_signal(load_signal),
        .instruction_mem_request(instruction_mem_request),
        .data_mem_we_re(data_mem_we_re),
        .data_mem_request(data_mem_request),
        .instruc_mem_valid(instruc_mem_valid),
        .data_mem_valid(data_mem_valid),
        .store_data_out(store_data),
        .pc_address(pc_address),
        .alu_out_address(alu_out_address),
        .x1_to_x4_nibbles_out(x1_to_x4_nibbles),
        .x10_to_x13_bytes_out(x10_to_x13_bytes),
        .ifid_pc_word_out(ifid_pc_word),
        .ifid_instruction_out(ifid_instruction),
        .control_status_out(control_status),
        .alu_mem_bytes_out(alu_mem_bytes)
    );

    // DATA MEMORY
    data_memory_top u_data_memory(
        .clk(clk),
        .rst(rst),
        .we_re(data_mem_we_re),
        .request(data_mem_request),
        .address(alu_out_address[9:2]),
        .data_in(store_data),
        .mask(mask),
        .load(load_signal),
        .valid(data_mem_valid),
        .data_out(load_data_out)
    );
endmodule
// MODULE_BRIEF: Chip-level integration of core, instruction memory, and data memory blocks.
