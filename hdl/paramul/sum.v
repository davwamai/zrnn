`timescale 1ns / 1ps

module sum (
	input wire Pi, Gki,
	output wire Si	
);

	wire w1;

	xor (Si, Pi, Gki);

endmodule