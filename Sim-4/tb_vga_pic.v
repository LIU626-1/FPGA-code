`timescale 1ns/1ps

module tb_vga_pic;

  localparam integer H_ACTIVE   = 640;
  localparam integer V_ACTIVE   = 480;
  localparam integer CLK_PERIOD = 20;
  localparam integer H_BLANK    = 8;
  localparam integer V_BLANK    = 8;
  localparam integer N_FRAMES   = 1;

  reg         vga_clk;
  reg         sys_rst_n;
  reg  [9:0]  pix_x;
  reg  [9:0]  pix_y;
  wire [15:0] pix_data;

  vga_pic dut (
    .vga_clk  (vga_clk),
    .sys_rst_n(sys_rst_n),
    .pix_x    (pix_x),
    .pix_y    (pix_y),
    .pix_data (pix_data)
  );

  initial begin
    vga_clk = 1'b0;
    forever #(CLK_PERIOD/2) vga_clk = ~vga_clk;
  end

  initial begin
    pix_x     = 10'h3ff;
    pix_y     = 10'h3ff;
    sys_rst_n = 1'b0;
    repeat (5) @(posedge vga_clk);
    sys_rst_n = 1'b1;

    @(posedge vga_clk);

    repeat (N_FRAMES) drive_one_frame();

    pix_x = 10'h3ff;
    pix_y = 10'h3ff;
    repeat (V_BLANK) @(posedge vga_clk);

    $finish;
  end

  task drive_one_frame;
    integer y, x;
    begin
      for (y = 0; y < V_ACTIVE; y = y + 1) begin
        pix_y = y;
        for (x = 0; x < H_ACTIVE; x = x + 1) begin
          pix_x = x;
          @(posedge vga_clk);
        end
        pix_x = 10'h3ff;
        repeat (H_BLANK) @(posedge vga_clk);
      end
      pix_y = 10'h3ff;
      repeat (V_BLANK) @(posedge vga_clk);
    end
  endtask

endmodule