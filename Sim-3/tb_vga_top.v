`timescale 1ns/1ps

module tb_vga_top();

 reg sys_clk ;
 reg sys_rst_n ;

wire h_sync ;
wire [15:0] rgb ;
wire v_sync ;

initial begin
    #30000000
    $finish;
end

 initial begin
	 sys_clk = 1'b1;
	 sys_rst_n <= 1'b0;
	 #200
	 sys_rst_n <= 1'b1;
 end

 always #10 sys_clk = ~sys_clk ;

 vga_top vga_top_inst
 (
 .sys_clk (sys_clk ), 
 .sys_rst_n (sys_rst_n ), 

 .h_sync (h_sync ), 
 .v_sync (v_sync ), 
 .rgb (rgb ) 
 );

 endmodule