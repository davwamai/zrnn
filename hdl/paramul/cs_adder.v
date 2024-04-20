`timescale 1ns / 1ps

module cs_adder(
	a, b, Cin, sum, Cout
);

parameter bits = 4;

input wire [bits-1:0] a;
input wire [bits-1:0] b;
input wire [bits-1:0] Cin;
output wire [bits-1:0] sum;
output wire [bits-1:0] Cout;

assign sum = a ^ b ^ Cin;
assign Cout = (a & b) | (a & Cin) | (b & Cin);

endmodule
