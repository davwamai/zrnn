`timescale 1ns / 1ps

module dot_ops (
	input wire Pi, Gi, Pki, Gki,
	output wire P, G
);

	carry_gen CG (.Pi(Pi), .Gi(Gi), .Gki(Gki), .G(G));
	carry_prop CP (.Pi(Pi), .Pki(Pki), .P(P));

endmodule