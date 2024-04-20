`timescale 1ns / 1ps

module booth_norm (
	input wire [31:0] multiplicand,
	input wire [2:0] booth_R4,
	input wire sign,
	output wire [33:0] PP
);

	wire [32:0] w;

assign w[32:0] = (booth_R4[1]^booth_R4[0] === 0)?
    ((booth_R4[2]^booth_R4[0] === 0)?0:{multiplicand[31:0], 1'b0}):
    ((sign === 0)?{1'b0, multiplicand[31:0]}:{multiplicand[31], multiplicand[31:0]});

genvar i;
generate
    for(i = 0;i <= 32; i = i+1) begin: inverse
        assign PP[i] = w[i]^booth_R4[2];
    end
endgenerate

assign PP[33] = (sign === 0)?booth_R4[2]:PP[32];

endmodule