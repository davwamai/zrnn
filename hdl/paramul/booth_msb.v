`timescale 1ns / 1ps

module booth_msb (
	input wire [31:0] multiplicand,
	input wire MSB,
	input wire sign,
	output wire [31:0] PP
);

	assign PP = ((sign == 0) && (MSB == 1))? multiplicand : 32'b0;

endmodule