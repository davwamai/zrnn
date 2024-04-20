`timescale 1ns / 1ps

module compress_tree (
	input wire [15:0] error_correction,
	input wire [33:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, 
		PP8, PP9, PP10, PP11, PP12, PP13, PP14, PP15,
	input wire [31:0] PP16,
	output wire [62:0] C,
	output wire [63:0] S
);

wire ZERO_BIT;

assign ZERO_BIT = 0;

wire[33:0] C11; wire[33:0] S11;
wire[33:0] C12; wire[33:0] S12;
wire[33:0] C13; wire[33:0] S13;
wire[33:0] C14; wire[33:0] S14;

wire[33:0] C21; wire[33:0] S21;
wire[37:0] C22; wire[37:0] S22;
wire[33:0] C23; wire[33:0] S23;
wire[33:0] C24; wire[33:0] S24;

wire[39:0] C31; wire[39:0] S31;
wire[38:0] C32; wire[38:0] S32;

wire[45:0] C41; wire[45:0] S41;
wire[45:0] C42; wire[45:0] S42;

wire[46:0] C51; wire[46:0] S51;

wire[56:0] C61; wire[56:0] S61;

wire[63:0] C71; wire[63:0] S71;

assign C = C71;
assign S = S71;

cs_adder #34 CSA13(
	.a({{4{PP0[33]}}, PP0[33:4]}), 
	.b({{2{PP1[33]}}, PP1[33:2]}), 
	.Cin(PP2[33:0]), 
	.Cout(C13), .sum(S13));

cs_adder #34 CSA23(
	.a(PP3[33:0]), 
	.b({C13[33], C13[33:1]}), 
	.Cin({{2{S13[33]}}, S13[33:2]}), 
	.Cout(C23), .sum(S23));

cs_adder #34 CSA14(
	.a({{4{PP4[33]}}, PP4[33:4]}), 
	.b({{2{PP5[33]}}, PP5[33:2]}), 
	.Cin(PP6[33:0]), 
	.Cout(C14), .sum(S14));

cs_adder #34 CSA24(
	.a({{2{PP7[33]}}, PP7[33:2]}), 
	.b(PP8[33:0]), 
	.Cin({{3{C14[33]}}, C14[33:3]}), 
	.Cout(C24), .sum(S24));

cs_adder #34 CSA11(
	.a({{4{PP9[33]}}, PP9[33:4]}), 
	.b({{2{PP10[33]}}, PP10[33:2]}), 
	.Cin(PP11[33:0]), 
	.Cout(C11), .sum(S11));

cs_adder #34 CSA21(
	.a(PP12[33:0]), 
	.b({C11[33], C11[33:1]}), 
	.Cin({{2{S11[33]}}, S11[33:2]}), 
	.Cout(C21), .sum(S21));

cs_adder #34 CSA12(
	.a({{4{PP13[33]}}, PP13[33:4]}), 
	.b({{2{PP14[33]}}, PP14[33:2]}), 
	.Cin(PP15[33:0]), 
	.Cout(C12), .sum(S12));

cs_adder #38 CSA22(
	.a({PP16[31:0], ZERO_BIT, error_correction[15], {PP13[3:0]}}), 
	.b({C12[32:0], ZERO_BIT, {PP14[1:0], {2{ZERO_BIT}}}}), 
	.Cin({S12[33:0], ZERO_BIT, error_correction[14], ZERO_BIT, error_correction[13]}), 
	.Cout(C22), .sum(S22));

cs_adder #40 CSA31(
	.a({{6{S21[33]}}, S21[33:0]}), 
	.b({C22[36:0], {3{ZERO_BIT}}}), 
	.Cin({S22[37:0], ZERO_BIT, error_correction[12]}), 
	.Cout(C31), .sum(S31));

cs_adder #39 CSA32(
	.a({C24[33:0], ZERO_BIT, {PP7[1:0], ZERO_BIT}, ZERO_BIT}), 
	.b({S24[33], S24[33:0], {C14[2:0]}, ZERO_BIT}), 
	.Cin({{5{S14[33]}}, S14[33:0]}), 
	.Cout(C32), .sum(S32));

cs_adder #46 CSA41(
	.a({{5{C21[33]}}, C21[33:0], ZERO_BIT, {C11[0], ZERO_BIT}, {PP9[3:0]}}), 
	.b({C31[38:0], ZERO_BIT, {S11[1:0]}, {PP10[1:0], {2{ZERO_BIT}}}}), 
	.Cin({S31[39:0], ZERO_BIT, error_correction[11], ZERO_BIT, error_correction[10], ZERO_BIT, error_correction[9]}), 
	.Cout(C41), .sum(S41));

cs_adder #46 CSA42(
	.a({{11{C23[33]}}, C23[33:0], ZERO_BIT}), 
	.b({{12{S23[33]}}, S23[33:0]}), 
	.Cin({C32[38:0], error_correction[6], ZERO_BIT, error_correction[5], ZERO_BIT, error_correction[4], ZERO_BIT, error_correction[3]}), 
	.Cout(C42), .sum(S42));

cs_adder #47 CSA51(
	.a({C42[45:0], ZERO_BIT}), 
	.b({{2{S32[38]}}, S32[38:0], {6{ZERO_BIT}}}), 
	.Cin({S42[45], S42[45:0]}), 
	.Cout(C51), .sum(S51));

cs_adder #57 CSA61(
	.a({C41[44:0], {7{ZERO_BIT}}, {PP4[3:0]}, ZERO_BIT}), 
	.b({S41[45:0], ZERO_BIT, error_correction[8], ZERO_BIT, error_correction[7], {2{ZERO_BIT}}, {PP5[1:0], {2{ZERO_BIT}}}, ZERO_BIT}), 
	.Cin({{10{C51[46]}}, C51[46:0]}), 
	.Cout(C61), .sum(S61));

cs_adder #64 CSA71(
	.a({C61[55:0], {2{ZERO_BIT}}, {C13[0], ZERO_BIT}, {PP0[3:0]}}), 
	.b({S61[56:0], ZERO_BIT, {S13[1:0]}, {PP1[1:0], {2{ZERO_BIT}}}}), 
	.Cin({{11{S51[46]}}, S51[46:0], ZERO_BIT, error_correction[2], ZERO_BIT, error_correction[1], ZERO_BIT, error_correction[0]}), 
	.Cout(C71), .sum(S71));

endmodule