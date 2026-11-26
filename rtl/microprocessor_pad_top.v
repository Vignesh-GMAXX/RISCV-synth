`timescale 1ns/1ps

module microprocessor_pad_top (
    input  wire       clk_pad,
    input  wire       rst_pad,
    input  wire [1:0] mem_bank_sel_pad,
    input  wire [1:0] dbg_sel_pad,
    output wire       CLKOUT_pad,
    output wire [31:0] dbg_out_pad
);

    wire       clk;
    wire       rst;
    wire [1:0] mem_bank_sel;
    wire [1:0] dbg_sel;
    wire       CLKOUT;
    wire [31:0] dbg_out;

    // Input pads
    pc3d01 pc3d01_clk             (.PAD(clk_pad),            .CIN(clk));
    pc3d01 pc3d01_rst             (.PAD(rst_pad),            .CIN(rst));
    pc3d01 pc3d01_mem_bank_sel_0  (.PAD(mem_bank_sel_pad[0]),.CIN(mem_bank_sel[0]));
    pc3d01 pc3d01_mem_bank_sel_1  (.PAD(mem_bank_sel_pad[1]),.CIN(mem_bank_sel[1]));
    pc3d01 pc3d01_dbg_sel_0       (.PAD(dbg_sel_pad[0]),     .CIN(dbg_sel[0]));
    pc3d01 pc3d01_dbg_sel_1       (.PAD(dbg_sel_pad[1]),     .CIN(dbg_sel[1]));

    // Core
    microprocessor u_microprocessor_core (
        .clk(clk),
        .rst(rst),
        .mem_bank_sel(mem_bank_sel),
        .dbg_sel(dbg_sel),
        .CLKOUT(CLKOUT),
        .dbg_out(dbg_out)
    );

    // Output pads
    pc3o05 pc3o05_dbg_out_0  (.I(dbg_out[0]),  .PAD(dbg_out_pad[0]));
    pc3o05 pc3o05_dbg_out_1  (.I(dbg_out[1]),  .PAD(dbg_out_pad[1]));
    pc3o05 pc3o05_dbg_out_2  (.I(dbg_out[2]),  .PAD(dbg_out_pad[2]));
    pc3o05 pc3o05_dbg_out_3  (.I(dbg_out[3]),  .PAD(dbg_out_pad[3]));
    pc3o05 pc3o05_dbg_out_4  (.I(dbg_out[4]),  .PAD(dbg_out_pad[4]));
    pc3o05 pc3o05_dbg_out_5  (.I(dbg_out[5]),  .PAD(dbg_out_pad[5]));
    pc3o05 pc3o05_dbg_out_6  (.I(dbg_out[6]),  .PAD(dbg_out_pad[6]));
    pc3o05 pc3o05_dbg_out_7  (.I(dbg_out[7]),  .PAD(dbg_out_pad[7]));
    pc3o05 pc3o05_dbg_out_8  (.I(dbg_out[8]),  .PAD(dbg_out_pad[8]));
    pc3o05 pc3o05_dbg_out_9  (.I(dbg_out[9]),  .PAD(dbg_out_pad[9]));
    pc3o05 pc3o05_dbg_out_10 (.I(dbg_out[10]), .PAD(dbg_out_pad[10]));
    pc3o05 pc3o05_dbg_out_11 (.I(dbg_out[11]), .PAD(dbg_out_pad[11]));
    pc3o05 pc3o05_dbg_out_12 (.I(dbg_out[12]), .PAD(dbg_out_pad[12]));
    pc3o05 pc3o05_dbg_out_13 (.I(dbg_out[13]), .PAD(dbg_out_pad[13]));
    pc3o05 pc3o05_dbg_out_14 (.I(dbg_out[14]), .PAD(dbg_out_pad[14]));
    pc3o05 pc3o05_dbg_out_15 (.I(dbg_out[15]), .PAD(dbg_out_pad[15]));
    pc3o05 pc3o05_dbg_out_16 (.I(dbg_out[16]), .PAD(dbg_out_pad[16]));
    pc3o05 pc3o05_dbg_out_17 (.I(dbg_out[17]), .PAD(dbg_out_pad[17]));
    pc3o05 pc3o05_dbg_out_18 (.I(dbg_out[18]), .PAD(dbg_out_pad[18]));
    pc3o05 pc3o05_dbg_out_19 (.I(dbg_out[19]), .PAD(dbg_out_pad[19]));
    pc3o05 pc3o05_dbg_out_20 (.I(dbg_out[20]), .PAD(dbg_out_pad[20]));
    pc3o05 pc3o05_dbg_out_21 (.I(dbg_out[21]), .PAD(dbg_out_pad[21]));
    pc3o05 pc3o05_dbg_out_22 (.I(dbg_out[22]), .PAD(dbg_out_pad[22]));
    pc3o05 pc3o05_dbg_out_23 (.I(dbg_out[23]), .PAD(dbg_out_pad[23]));
    pc3o05 pc3o05_dbg_out_24 (.I(dbg_out[24]), .PAD(dbg_out_pad[24]));
    pc3o05 pc3o05_dbg_out_25 (.I(dbg_out[25]), .PAD(dbg_out_pad[25]));
    pc3o05 pc3o05_dbg_out_26 (.I(dbg_out[26]), .PAD(dbg_out_pad[26]));
    pc3o05 pc3o05_dbg_out_27 (.I(dbg_out[27]), .PAD(dbg_out_pad[27]));
    pc3o05 pc3o05_dbg_out_28 (.I(dbg_out[28]), .PAD(dbg_out_pad[28]));
    pc3o05 pc3o05_dbg_out_29 (.I(dbg_out[29]), .PAD(dbg_out_pad[29]));
    pc3o05 pc3o05_dbg_out_30 (.I(dbg_out[30]), .PAD(dbg_out_pad[30]));
    pc3o05 pc3o05_dbg_out_31 (.I(dbg_out[31]), .PAD(dbg_out_pad[31]));
    pc3o05 pc3o05_CLKOUT     (.I(CLKOUT),      .PAD(CLKOUT_pad));

    // Power pads and corners are physical-only anchors for IO ring planning.
    pvdi pvdi_VDD_CORE_1();
    pv0i pv0i_VSS_CORE_1();
    pvda pvda_VDDO_CORE_1();
    pv0a pv0a_VSSO_CORE_1();

    pvdi pvdi_VDD_CORE_2();
    pv0i pv0i_VSS_CORE_2();
    pvda pvda_VDDO_CORE_2();
    pv0a pv0a_VSSO_CORE_2();

    pvdi pvdi_VDD_CORE_3();
    pv0i pv0i_VSS_CORE_3();
    pvda pvda_VDDO_CORE_3();
    pv0a pv0a_VSSO_CORE_3();

    pvdi pvdi_VDD_CORE_4();
    pv0i pv0i_VSS_CORE_4();
    pvda pvda_VDDO_CORE_4();
    pv0a pv0a_VSSO_CORE_4();

    pfrelr corner_1();
    pfrelr corner_2();
    pfrelr corner_3();
    pfrelr corner_4();

endmodule
