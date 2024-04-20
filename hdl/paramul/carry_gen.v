`timescale 1ns / 1ps

module carry_gen (
	input wire Pi, Gi, Gki,
	output wire G
);

	wire w1;

	and (w1, Pi, Gki);

	or (G, w1, Gi);

endmodule