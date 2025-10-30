`timescale 1ns/1ns
module tb_Comparator();

reg A;
reg B;

wire led1;
wire led2;
wire les3;

/*
initial begin
A <= 1'b0;
B <= 1'b0;
end

always #10 A <= {$random} % 2;

always #10 B <= {$random} % 2;
*/

initial begin
    A = 0; B = 0; #20;
    A = 0; B = 1; #20;
    A = 1; B = 0; #20;
    A = 1; B = 1; #20;
end


Comparator Comparator_instance
(
.A(A),
.B(B),
.led1(led1),
.led2(led2),
.led3(led3)
);

endmodule