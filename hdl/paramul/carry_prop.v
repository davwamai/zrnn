`timescale 1ns / 1ps

module carry_prop (
	input wire Pi, Pki,
	output wire P
);

	and (P, Pi, Pki);

endmodule