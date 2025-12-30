module Running_light
#(
parameter T=25'b1011111010111100000111111
)
(
input sys_clk,
input sys_rst_n,
output led0,
output led1,
output led2,
output led3
);
reg [3:0] led;
assign {led3, led2, led1, led0} = led;
reg [24:0] cnt;
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    cnt<= 25'd0;
    led <= 4'b1110;
  end else begin
    if (cnt < T) begin
      cnt <= cnt + 1'b1;
    end else begin
      cnt<=25'd0;
      led<= (led<<1)+led3;
    end
  end
end
endmodule