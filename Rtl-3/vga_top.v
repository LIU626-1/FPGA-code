module vga_top (
  input  wire        sys_clk,
  input  wire        sys_rst_n,
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
  wire [15:0] pix_data;

  vga_pic vga_pic_inst (
    .vga_clk   (vga_clk),
    .sys_rst_n (sys_rst_n),
    .pix_x     (pix_x),
    .pix_y     (pix_y),
    .pix_data  (pix_data)
  );

  vga_ctrl vga_ctrl_inst (
    .vga_clk   (vga_clk),
    .sys_rst_n (sys_rst_n),
    .pix_data  (pix_data),
    .pix_x     (pix_x),
    .pix_y     (pix_y),
    .hsync     (h_sync),
    .vsync     (v_sync),
    .rgb       (rgb)
  );
endmodule