`timescale 1ns/1ns
module tb_adder();
reg a;
reg b;
reg cin;
wire out;
wire cout;

adder adder_instance(
.a (a),
.b (b),
.cin (cin),
.out (out),
.cout (cout)
);
/*
initial begin
a <= 1'b0;
b <= 1'b0;
cin <= 1'b0;
end

always begin
	#10 a <= ($random) % 2;
	#10 b <= ($random) % 2;
	#10 cin <= ($random) % 2;
end
*/
initial begin
    a = 0; b = 0; cin = 0; #20;
    a = 0; b = 0; cin = 1; #20;
    a = 0; b = 1; cin = 0; #20;
    a = 0; b = 1; cin = 1; #20;
    a = 1; b = 0; cin = 0; #20;
    a = 1; b = 0; cin = 1; #20;
    a = 1; b = 1; cin = 0; #20;
    a = 1; b = 1; cin = 1; #20;
end
endmodule