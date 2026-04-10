module basys3_top #(
    parameter USE_SIMULATION_CLOCK = 0,
    parameter integer IMPLEMENTATION_TOGGLE_COUNT = 50_000_000,
    parameter INSTR_MEM_FILE = ""
) (
    input  wire        CLK100MHZ,
    input  wire        rst, // R2 switch for reset
    output wire [15:0] LED
);
    wire [31:0] dbg_out;

    microprocessor #(
        .INSTR_MEM_FILE(INSTR_MEM_FILE)
    ) u_microprocessor0 (
        .clk(CLK100MHZ),
        .rst(rst),
        .mem_bank_sel(2'b00),
        .dbg_sel(2'b00),
        .CLKOUT(),
        .dbg_out(dbg_out)
    );

    assign LED = dbg_out[15:0];

endmodule

// MODULE_BRIEF: Board-level wrapper: handles clock/reset and exposes register nibble debug on LEDs.
