`timescale 1ns/1ns
module DevelopmentBoard(
    input  wire        clk,
    input  wire        reset,
    input  wire        B2,
    input  wire        B3,
    input  wire        B4,
    input  wire        B5,
    output wire        h_sync,
    output wire        v_sync,
    output wire [15:0] rgb,
    output wire        led1,
    output wire        led2,
    output wire        led3,
    output wire        led4,
    output wire        led5
);

    Breakout_top u_breakout (
        .sys_clk   (clk),
        .sys_rst_n (reset),
        .B2        (B2),
        .B3        (B3),
        .B4        (B4),
        .B5        (B5),
        .h_sync    (h_sync),
        .v_sync    (v_sync),
        .rgb       (rgb)
    );

    assign led1 = 1'b1;
    assign led2 = 1'b1;
    assign led3 = 1'b1;
    assign led4 = 1'b1;
    assign led5 = 1'b1;
    
endmodule