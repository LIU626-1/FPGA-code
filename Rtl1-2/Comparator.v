module Comparator(
input A,
input B,

output led1,
output led2,
output led3
);

assign led1 = !(A < B);
assign led2 = !(A == B);
assign led3 = !(A > B);

endmodule