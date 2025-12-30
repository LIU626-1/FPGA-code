module Counter
#(
parameter T=25'b1011111010111100000111111
)
(
input sys_clk,
input sys_rst_n,
output reg led_out
);
reg [24:0] cnt;
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    cnt <= 25'd0;
    led_out <= 1'b0;
  end else begin
    if (cnt < T) begin
      cnt <= cnt + 1'b1;
    end else begin
      cnt <= 25'd0;
      led_out <= ~led_out;
    end
  end
end
endmodule