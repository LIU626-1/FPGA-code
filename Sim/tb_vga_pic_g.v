`timescale 1ns/1ps

module tb_vga_pic_g;

  reg vga_clk;
  reg rst_n;

  reg btn_left;
  reg btn_right;
  reg btn_ok;
  reg btn_back;

  wire [9:0]  pix_x;
  wire [9:0]  pix_y;
  wire        hsync;
  wire        vsync;
  wire [15:0] rgb;

  wire [15:0] pix_data;
  wire        game_over;

  initial begin
    vga_clk = 1'b0;
    forever #20 vga_clk = ~vga_clk;
  end

  initial begin
    rst_n     = 1'b0;
    btn_left  = 1'b0;
    btn_right = 1'b0;
    btn_ok    = 1'b0;
    btn_back  = 1'b0;

    #200;
    rst_n = 1'b1;
  end

  initial begin
    wait(rst_n == 1'b1);

    #5_000_000;
    btn_right = 1'b1;
    #20_000_000;
    btn_right = 1'b0;
    #5_000_000;
    btn_left = 1'b1;
    #20_000_000;
    btn_left = 1'b0;
  end

  initial begin
    $dumpfile("tb_vga_pic_g.vcd");
    $dumpvars(0, tb_vga_pic_g);
    #100_000_000;
    $finish;
  end

  reg game_over_d;
  always @(posedge vga_clk or negedge rst_n) begin
    if(!rst_n) game_over_d <= 1'b0;
    else begin
      game_over_d <= game_over;
      if(!game_over_d && game_over) begin
        $display("[%0t] GAME OVER asserted!", $time);
      end
    end
  end

  vga_ctrl u_vga_ctrl (
    .vga_clk    (vga_clk),
    .sys_rst_n  (rst_n),
    .pix_data   (pix_data),

    .pix_x      (pix_x),
    .pix_y      (pix_y),
    .hsync      (hsync),
    .vsync      (vsync),
    .rgb        (rgb)
  );

  vga_pic_g u_vga_pic_g (
    .vga_clk    (vga_clk),
    .sys_rst_n  (rst_n),
    .pix_x      (pix_x),
    .pix_y      (pix_y),
    .btn_left   (btn_left),
    .btn_right  (btn_right),
    .btn_ok     (btn_ok),
    .btn_back   (btn_back),
    .pix_data   (pix_data),
    .game_over  (game_over)
  );

endmodule

