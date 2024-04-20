`timescale 1ns / 1ps

module paramul (
	input wire [31:0] multiplier,
	input wire [31:0] multiplicand,
	input wire sign,
	output wire [63:0] product
	//output wire [63:0] product_out
);

	wire [33:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, 
		PP8, PP9, PP10, PP11, PP12, PP13, PP14, PP15;
	wire [31:0] PP16;
	wire [15:0] error_correction;
	wire [63:0] C;
	wire [63:0] S;

	booth_alg booth (.multiplier(multiplier), .multiplicand(multiplicand), 
		.sign(sign), .error_correction(error_correction), .PP0(PP0), .PP1(PP1),
		.PP2(PP2), .PP3(PP3), .PP4(PP4), .PP5(PP5), .PP6(PP6), .PP7(PP7), .PP8(PP8),
		.PP9(PP9), .PP10(PP10), .PP11(PP11), .PP12(PP12), .PP13(PP13), .PP14(PP14),
		.PP15(PP15), .PP16(PP16));

	compress_tree compressor (.error_correction(error_correction), .PP0(PP0), .PP1(PP1),
		.PP2(PP2), .PP3(PP3), .PP4(PP4), .PP5(PP5), .PP6(PP6), .PP7(PP7), .PP8(PP8),
		.PP9(PP9), .PP10(PP10), .PP11(PP11), .PP12(PP12), .PP13(PP13), .PP14(PP14),
		.PP15(PP15), .PP16(PP16), .C(C), .S(S));


	variable_ksa adder (.A({C[62:0],1'b0}), .B(S[63:0]), .S(product));	

	//assign product_out = multiplier * multiplicand;
endmodule