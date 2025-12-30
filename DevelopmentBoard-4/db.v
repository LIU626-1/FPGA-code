`timescale 1ns / 1ns

module DevelopmentBoard(
    input  wire clk,                 // 50MHz
    input  wire reset, B2, B3, B4, B5,
    // reset is "a"
    // B2 is "s"
    // B3 is "d"
    // B4 is "f"
    // B5 is "g"

    output wire h_sync, v_sync,
    output wire [15:0] rgb,

    output wire led1,
    output wire led2,
    output wire led3,
    output wire led4,
    output wire led5
);


    assign led1 = reset;
    assign led2 = B2;

    reg [25:0] hb = 26'd0;
    always @(posedge clk) hb <= hb + 1'b1;
    assign led3 = hb[25];
    assign led4 = h_sync;
    assign led5 = v_sync;

    vga_top u_vga_top (
        .sys_clk  (clk),
        .sys_rst_n(reset),
        .key_n    (B2),
        .h_sync   (h_sync),
        .v_sync   (v_sync),
        .rgb      (rgb)
    );

endmodule