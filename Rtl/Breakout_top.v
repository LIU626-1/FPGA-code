`timescale 1ns/1ns

module Breakout_top(
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    input  wire        B2,
    input  wire        B3,
    input  wire        B4,
    input  wire        B5,
    output wire        h_sync,
    output wire        v_sync,
    output wire [15:0] rgb
);

    wire vga_clk;

    pll pll_inst (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .vga_clk   (vga_clk)
    );

    wire [9:0]  pix_x, pix_y;
    wire [15:0] pix_data_mux;

    vga_ctrl u_vga (
        .vga_clk   (vga_clk),
        .sys_rst_n (sys_rst_n),
        .pix_data  (pix_data_mux),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .hsync     (h_sync),
        .vsync     (v_sync),
        .rgb       (rgb)
    );

    wire left_level;
    wire left_flag;

    key_filter #(
        .CNT_MAX   (500_000),
        .CNT_WIDTH (19)
    ) u_key_left (
        .clk       (vga_clk),
        .rst_n     (sys_rst_n),
        .key_n     (B2),
        .key_state (left_level),
        .key_flag  (left_flag)
    );

    wire right_level;
    wire right_flag;

    key_filter #(
        .CNT_MAX   (500_000),
        .CNT_WIDTH (19)
    ) u_key_right (
        .clk       (vga_clk),
        .rst_n     (sys_rst_n),
        .key_n     (B3),
        .key_state (right_level),
        .key_flag  (right_flag)
    );

    wire ok_level;
    wire ok_flag;

    key_filter #(
        .CNT_MAX   (500_000),
        .CNT_WIDTH (19)
    ) u_key_ok (
        .clk       (vga_clk),
        .rst_n     (sys_rst_n),
        .key_n     (B4),
        .key_state (ok_level),
        .key_flag  (ok_flag)
    );

    wire back_level;
    wire back_flag;

    key_filter #(
        .CNT_MAX   (500_000),
        .CNT_WIDTH (19)
    ) u_key_back (
        .clk       (vga_clk),
        .rst_n     (sys_rst_n),
        .key_n     (B5),
        .key_state (back_level),
        .key_flag  (back_flag)
    );

    reg  [1:0] state;
    reg  [1:0] state_n;
    wire       game_over;
    reg        game_rst_n;

    localparam [1:0] S_START = 2'd0,
                     S_GAME  = 2'd1,
                     S_END   = 2'd2;

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            state <= S_START;
        else
            state <= state_n;
    end

    always @* begin
        state_n = state;
        case (state)
            S_START: begin
                if (ok_flag)
                    state_n = S_GAME;
            end
            S_GAME: begin
                if (game_over)
                    state_n = S_END;
            end
            S_END: begin
                state_n = S_END;
            end
            default: state_n = S_START;
        endcase
    end

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            game_rst_n <= 1'b0;
        end else if (state == S_START && ok_flag) begin
            game_rst_n <= 1'b0;
        end else begin
            game_rst_n <= 1'b1;
        end
    end

    wire [15:0] pix_data_start;
    wire [15:0] pix_data_game;
    wire [15:0] pix_data_end;

    vga_pic_start u_start (
        .vga_clk   (vga_clk),
        .sys_rst_n (sys_rst_n),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .pix_data  (pix_data_start)
    );

    vga_pic_g u_game (
        .vga_clk   (vga_clk),
        .sys_rst_n (game_rst_n),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .btn_left  (left_level),
        .btn_right (right_level),
        .btn_ok    (1'b0),
        .btn_back  (1'b0),
        .pix_data  (pix_data_game),
        .game_over (game_over)
    );

    vga_pic_end u_end (
        .vga_clk   (vga_clk),
        .sys_rst_n (sys_rst_n),
        .pix_x     (pix_x),
        .pix_y     (pix_y),
        .pix_data  (pix_data_end)
    );

    vga_pic_ctrl u_pic_ctrl (
        .state     (state),
        .pix_start (pix_data_start),
        .pix_game  (pix_data_game),
        .pix_end   (pix_data_end),
        .pix_out   (pix_data_mux)
    );

endmodule
