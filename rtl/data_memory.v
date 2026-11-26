module data_memory (
    input wire        clk,
    input wire        we_re,
    input wire        request,
    input wire [7:0]  address,
    input wire [31:0] data_in,
    input wire [3:0]  mask,
    output reg [31:0] data_out
);

    reg [31:0] mem [0:31];
    wire [4:0] addr_idx;
    wire addr_out_of_range;

    assign addr_idx = address[4:0];
    assign addr_out_of_range = |address[7:5];

    always @(posedge clk) begin
        if (request && we_re && !addr_out_of_range) begin
            if (mask[0]) begin
                mem[addr_idx][7:0] <= data_in[7:0];
            end
            if (mask[1]) begin
                mem[addr_idx][15:8] <= data_in[15:8];
            end
            if (mask[2]) begin
                mem[addr_idx][23:16] <= data_in[23:16];
            end
            if (mask[3]) begin
                mem[addr_idx][31:24] <= data_in[31:24];
            end
        end
    end

    always @(*) begin
        if (request && !we_re && !addr_out_of_range) begin
            data_out = mem[addr_idx];
        end
        else begin
            data_out = 32'b0;
        end
    end

endmodule
// MODULE_BRIEF: Implements data memory array with masked write support.
