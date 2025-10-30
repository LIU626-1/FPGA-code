`timescale 1ns/1ps

module tb_pll();

reg artificial_sys_clk;
reg artificial_sys_rst_n;

wire recoder_vga_clk;

initial begin
    #30000000
    $finish;
end

 initial begin
	 artificial_sys_clk <= 1'b1;
	 artificial_sys_rst_n <= 1'b0;
	 #200
	 artificial_sys_rst_n <= 1'b1;
 end

 always #10 artificial_sys_clk <= ~artificial_sys_clk ;

 pll pll_inst
 (
 .sys_clk(artificial_sys_clk),
 .sys_rst_n(artificial_sys_rst_n),

 .vga_clk(recoder_vga_clk)
 );

endmodule