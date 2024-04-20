`timescale 1ns / 1ps

module booth_alg (
	input wire [31:0] multiplicand,
	input wire [31:0] multiplier,
	input wire sign,

	output wire [15:0] error_correction,
	output wire [33:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, 
		PP8, PP9, PP10, PP11, PP12, PP13, PP14, PP15,
	output wire [31:0] PP16
);

	assign error_correction[15:0] = {
		multiplier[31], multiplier[29], multiplier[27], multiplier[25],
		multiplier[23], multiplier[21], multiplier[19], multiplier[17],
		multiplier[15], multiplier[13], multiplier[11], multiplier[9],
		multiplier[7], multiplier[5], multiplier[3], multiplier[1]
	};

	booth_norm PPG0 (.multiplicand(multiplicand), .booth_R4({multiplier[1:0],1'b0}), .sign(sign), .PP(PP0));
	booth_norm PPG1 (.multiplicand(multiplicand), .booth_R4(multiplier[3:1]),        .sign(sign), .PP(PP1));
	booth_norm PPG2 (.multiplicand(multiplicand), .booth_R4(multiplier[5:3]),        .sign(sign), .PP(PP2));
	booth_norm PPG3 (.multiplicand(multiplicand), .booth_R4(multiplier[7:5]),        .sign(sign), .PP(PP3));
	booth_norm PPG4 (.multiplicand(multiplicand), .booth_R4(multiplier[9:7]),        .sign(sign), .PP(PP4));
	booth_norm PPG5 (.multiplicand(multiplicand), .booth_R4(multiplier[11:9]),       .sign(sign), .PP(PP5));
	booth_norm PPG6 (.multiplicand(multiplicand), .booth_R4(multiplier[13:11]),      .sign(sign), .PP(PP6));
	booth_norm PPG7 (.multiplicand(multiplicand), .booth_R4(multiplier[15:13]),      .sign(sign), .PP(PP7));
	booth_norm PPG8 (.multiplicand(multiplicand), .booth_R4(multiplier[17:15]),      .sign(sign), .PP(PP8));
	booth_norm PPG9 (.multiplicand(multiplicand), .booth_R4(multiplier[19:17]),      .sign(sign), .PP(PP9));
	booth_norm PPG10(.multiplicand(multiplicand), .booth_R4(multiplier[21:19]),      .sign(sign), .PP(PP10));
	booth_norm PPG11(.multiplicand(multiplicand), .booth_R4(multiplier[23:21]),      .sign(sign), .PP(PP11));
	booth_norm PPG12(.multiplicand(multiplicand), .booth_R4(multiplier[25:23]),      .sign(sign), .PP(PP12));
	booth_norm PPG13(.multiplicand(multiplicand), .booth_R4(multiplier[27:25]),      .sign(sign), .PP(PP13));
	booth_norm PPG14(.multiplicand(multiplicand), .booth_R4(multiplier[29:27]),      .sign(sign), .PP(PP14));
	booth_norm PPG15(.multiplicand(multiplicand), .booth_R4(multiplier[31:29]),      .sign(sign), .PP(PP15));
	booth_msb  PPG16(.multiplicand(multiplicand), .MSB(multiplier[31]),                    .sign(sign), .PP(PP16));
    

endmodule