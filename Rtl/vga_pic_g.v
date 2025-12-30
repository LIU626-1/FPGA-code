`timescale 1ns/1ns
module vga_pic_g(
  input  wire        vga_clk,
  input  wire        sys_rst_n,
  input  wire [9:0]  pix_x,
  input  wire [9:0]  pix_y,
  input  wire        btn_left,
  input  wire        btn_right,
  input  wire        btn_ok,
  input  wire        btn_back,
  output reg  [15:0] pix_data,
  output wire        game_over
);

  localparam [10:0] H_RES = 11'd640, V_RES = 11'd480;
  localparam [10:0] H_MAX = H_RES-11'd1, V_MAX = V_RES-11'd1;
  localparam [15:0] C_BLACK=16'h0000,
                    C_WHITE=16'hFFFF,
                    C_GREEN=16'h07E0,
                    C_YEL  =16'hFFE0,
                    C_MAG  =16'hFD20,
                    C_RED  =16'hF800;

  localparam [10:0] PAD_W=11'd80, PAD_H=11'd10, PAD_Y=V_RES-11'd30;
  localparam [10:0] PAD_STEP = 11'd2;

  localparam [10:0] BALL_R = 11'd4;
  localparam integer BALL_R2 = BALL_R*BALL_R;

  localparam integer VCLK_HZ = 25_000_000;
  localparam integer BALL_V  = 14;
  localparam integer GAME_HZ = 60*BALL_V;
  localparam integer GAME_DIV= VCLK_HZ / GAME_HZ;

  reg  [15:0] game_div;
  wire        game_ce;
  assign game_ce = (game_div == GAME_DIV-1);

  always @(posedge vga_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) game_div <= 16'd0;
    else if(game_ce) game_div <= 16'd0;
    else game_div <= game_div + 16'd1;
  end

  localparam integer BRK_COLS=8, BRK_ROWS=5;
  localparam [10:0] BRK_W   = 11'd64;
  localparam [10:0] BRK_H   = 11'd27;
  localparam [10:0] BRK_TOP = 11'd80;
  localparam [10:0] BRK_TW  = 11'd512;
  localparam [10:0] BRK_TH  = 11'd135;
  localparam [10:0] BRK_LEFT = (H_RES - BRK_TW)>>1;

  reg [10:0] pad_x;
  reg [10:0] ball_x, ball_y;
  reg        dir_x, dir_y;
  reg [BRK_COLS*BRK_ROWS-1:0] brk_on;

  reg [1:0] life_cnt;
  reg [5:0] brick_left;

  wire life_empty;
  wire bricks_empty;
  assign life_empty   = (life_cnt   == 2'd0);
  assign bricks_empty = (brick_left == 6'd0);
  assign game_over    = life_empty | bricks_empty;

  localparam [10:0] PAD_X0=(H_RES-PAD_W)>>1,
                    BALL_X0=11'd320,
                    BALL_Y0=(V_RES>>1)+11'd20;

  integer nx, ny, rx1, ry1, rx2, ry2, idx;
  integer bx, by;
  reg     tdx, tdy;
  reg     brick_removed;

  integer xr_px, yr_px, cc_px, rr_px, ii_px;

  function circle_rect_hit;
    input integer cx, cy;
    input integer rx1, ry1, rx2, ry2;
    integer px, py, dx, dy, d2;
    begin
      px = (cx < rx1) ? rx1 : ((cx > rx2) ? rx2 : cx);
      py = (cy < ry1) ? ry1 : ((cy > ry2) ? ry2 : cy);
      dx = cx - px;
      dy = cy - py;
      d2 = dx*dx + dy*dy;
      circle_rect_hit = (d2 <= BALL_R2);
    end
  endfunction

  function integer row_from_y;
    input integer y_rel;
    begin
      if      (y_rel < 27)  row_from_y = 0;
      else if (y_rel < 54)  row_from_y = 1;
      else if (y_rel < 81)  row_from_y = 2;
      else if (y_rel < 108) row_from_y = 3;
      else                  row_from_y = 4;
    end
  endfunction

  function [5:0] brick_index;
    input integer x, y;
    integer c, r, xr, yr;
    begin
      brick_index = 6'd63;
      if( (y >= BRK_TOP) && (y < BRK_TOP+BRK_TH) &&
          (x >= BRK_LEFT) && (x < BRK_LEFT+BRK_TW) ) begin
        xr = x - BRK_LEFT;
        yr = y - BRK_TOP;
        c  = xr >> 6;
        r  = row_from_y(yr);
        brick_index = r*BRK_COLS + c;
      end
    end
  endfunction

  always @(posedge vga_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
      pad_x   <= PAD_X0;
      ball_x  <= BALL_X0; ball_y <= BALL_Y0;
      dir_x   <= 1'b1;    dir_y  <= 1'b0;
      brk_on  <= {(BRK_COLS*BRK_ROWS){1'b1}};
      life_cnt   <= 2'd3;
      brick_left <= 6'd40;
    end else if(game_ce) begin
      if(btn_left) begin
        if(pad_x > PAD_STEP) pad_x <= pad_x - PAD_STEP;
        else                 pad_x <= 11'd0;
      end else if(btn_right) begin
        if(pad_x + PAD_W + PAD_STEP < H_RES) pad_x <= pad_x + PAD_STEP;
        else                                 pad_x <= H_RES - PAD_W;
      end

      if(!game_over) begin
        bx = ball_x; by = ball_y;
        tdx = dir_x; tdy = dir_y;
        brick_removed = 1'b0;

        nx = tdx ? (bx + 1) : (bx - 1);

        if(nx <= BALL_R) begin
          nx  = BALL_R;
          tdx = 1'b1;
        end else if(nx >= H_MAX - BALL_R) begin
          nx  = H_MAX - BALL_R;
          tdx = 1'b0;
        end else begin
          rx1 = pad_x; ry1 = PAD_Y;
          rx2 = pad_x + PAD_W; ry2 = PAD_Y + PAD_H;
          if(circle_rect_hit(nx, by, rx1, ry1, rx2, ry2)) begin
            tdx = ~tdx; nx = bx;
          end else begin
            idx = brick_index(nx, by);
            if((idx < BRK_COLS*BRK_ROWS) && brk_on[idx]) begin
              rx1 = BRK_LEFT + (((nx - BRK_LEFT) >> 6) << 6);
              ry1 = BRK_TOP  + BRK_H*row_from_y(by - BRK_TOP);
              rx2 = rx1 + BRK_W; ry2 = ry1 + BRK_H;
              if(circle_rect_hit(nx, by, rx1, ry1, rx2, ry2)) begin
                tdx = ~tdx; nx = bx;
                if(!brick_removed) begin
                  brick_removed = 1'b1;
                  brk_on[idx]   <= 1'b0;
                  if(brick_left > 0)
                    brick_left <= brick_left - 1'b1;
                end
              end
            end
          end
        end
        bx = nx;

        ny = tdy ? (by + 1) : (by - 1);

        if(ny <= BALL_R) begin
          ny  = BALL_R;
          tdy = 1'b1;
        end else if(ny >= V_MAX - BALL_R) begin
          if(life_cnt > 0)
            life_cnt <= life_cnt - 1'b1;
          bx  = pad_x + (PAD_W>>1);
          by  = PAD_Y - BALL_R - 1;
          nx  = bx;
          ny  = by;
          tdy = 1'b0;
        end else begin
          rx1 = pad_x; ry1 = PAD_Y;
          rx2 = pad_x + PAD_W; ry2 = PAD_Y + PAD_H;
          if(circle_rect_hit(bx, ny, rx1, ry1, rx2, ry2)) begin
            tdy = ~tdy; ny = by;
          end else begin
            idx = brick_index(bx, ny);
            if((idx < BRK_COLS*BRK_ROWS) && brk_on[idx]) begin
              rx1 = BRK_LEFT + (((bx - BRK_LEFT) >> 6) << 6);
              ry1 = BRK_TOP  + BRK_H*row_from_y(ny - BRK_TOP);
              rx2 = rx1 + BRK_W; ry2 = ry1 + BRK_H;
              if(circle_rect_hit(bx, ny, rx1, ry1, rx2, ry2)) begin
                tdy = ~tdy; ny = by;
                if(!brick_removed) begin
                  brick_removed = 1'b1;
                  brk_on[idx]   <= 1'b0;
                  if(brick_left > 0)
                    brick_left <= brick_left - 1'b1;
                end
              end
            end
          end
        end
        by = ny;

        ball_x <= bx[10:0];
        ball_y <= by[10:0];
        dir_x  <= tdx;
        dir_y  <= tdy;
      end
    end
  end

  wire [10:0] X;
  wire [10:0] Y;
  assign X = {1'b0, pix_x};
  assign Y = {1'b0, pix_y};

  wire signed [12:0] dx_pix;
  wire signed [12:0] dy_pix;
  wire [25:0]        d2_pix;
  wire               ball_on;

  assign dx_pix = $signed({1'b0,X}) - $signed({1'b0,ball_x});
  assign dy_pix = $signed({1'b0,Y}) - $signed({1'b0,ball_y});
  assign d2_pix  = dx_pix*dx_pix + dy_pix*dy_pix;
  assign ball_on = (d2_pix <= BALL_R2);

  wire pad_on;
  assign pad_on = (Y >= PAD_Y) && (Y < PAD_Y + PAD_H) &&
                  (X >= pad_x) && (X < pad_x + PAD_W);

  reg brick_on_px;
  reg [15:0] brick_col_px;

  always @* begin
    brick_on_px  = 1'b0;
    brick_col_px = C_YEL;

    if( (Y >= BRK_TOP) && (Y < BRK_TOP + BRK_TH) &&
        (X >= BRK_LEFT) && (X < BRK_LEFT + BRK_TW) ) begin
      xr_px = X - BRK_LEFT;
      yr_px = Y - BRK_TOP;
      cc_px = xr_px >> 6;
      rr_px = row_from_y(yr_px);
      ii_px = rr_px*BRK_COLS + cc_px;

      if(brk_on[ii_px]) begin
        brick_on_px  = 1'b1;
        brick_col_px = (rr_px[0]==1'b0) ? C_MAG : C_YEL;
      end
    end
  end

  wire life1_area, life2_area, life3_area;
  wire life1_show, life2_show, life3_show;

  assign life1_area = (X >= 20  && X < 40  && Y >= 20 && Y < 35);
  assign life2_area = (X >= 45  && X < 65  && Y >= 20 && Y < 35);
  assign life3_area = (X >= 70  && X < 90  && Y >= 20 && Y < 35);

  assign life1_show = life1_area && (life_cnt >= 2'd1);
  assign life2_show = life2_area && (life_cnt >= 2'd2);
  assign life3_show = life3_area && (life_cnt == 2'd3);

  always @* begin
    if(ball_on)
      pix_data = C_GREEN;
    else if(pad_on)
      pix_data = C_WHITE;
    else if(brick_on_px)
      pix_data = brick_col_px;
    else
      pix_data = C_BLACK;

    if (life1_show || life2_show || life3_show)
      pix_data = C_RED;
  end

endmodule

