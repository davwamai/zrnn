`timescale 1ns / 1ps

module kogge_stone_adder (
	input wire [63:0] A, B,
	input wire Ci,
	output wire [63:0] S
);

	wire [63:0] P0, P1, P2, P3, P4, P5;
	wire [63:0] G0, G1, G2, G3, G4, G5, G6;

	genvar i;


//Layer 0
	generate
		for (i = 0; i < 64; i = i + 1) begin: Layer_0
            Entry E (.Ai(A[i]), .Bi (B[i]), .Pi(P0[i]), .Gi(G0[i]));
		end
	endgenerate

//Layer 1
	generate
		for (i = 0; i < 64; i = i + 1) begin: Layer_1
			if (i==0) begin
				carry_gen CG1 (.Pi(P0[i]), .Gi(G0[i]), .Gki(Ci), .G(G1[i]));
			end
			else begin 
				dot_ops DO1 (.Pi(P0[i]), .Gi(G0[i]), .Pki(P0[i-1]), .Gki(G0[i-1]), .P(P1[i]), .G(G1[i]));
			end
		end
	endgenerate

//Layer 2
	generate
		for (i = 1; i < 64; i = i + 1) begin: Layer_2
			if (i==1) begin
				carry_gen CG2 (.Pi(P1[i]), .Gi(G1[i]), .Gki(Ci), .G(G2[i]));
			end
			else if (i==2) begin 
				carry_gen CG2 (.Pi(P1[i]), .Gi(G1[i]), .Gki(G1[i-2]), .G(G2[i]));
			end
			else begin 
				dot_ops DO2 (.Pi(P1[i]), .Gi(G1[i]), .Pki(P1[i-2]), .Gki(G1[i-2]), .P(P2[i]), .G(G2[i]));
			end
		end
	endgenerate

//Layer 3
	generate
		for (i = 3; i < 64; i = i + 1) begin: Layer_3
			if (i==3) begin
				carry_gen CG3 (.Pi(P2[i]), .Gi(G2[i]), .Gki(Ci), .G(G3[i]));
			end
			else if (i==4) begin 
				carry_gen CG3 (.Pi(P2[i]), .Gi(G2[i]), .Gki(G1[i-4]), .G(G3[i]));
			end
			else if (i==5 || 6) begin 
				carry_gen CG3 (.Pi(P2[i]), .Gi(G2[i]), .Gki(G2[i-4]), .G(G3[i]));
			end
			else begin 
				dot_ops DO3 (.Pi(P2[i]), .Gi(G2[i]), .Pki(P2[i-4]), .Gki(G2[i-4]), .P(P3[i]), .G(G3[i]));
			end
		end
	endgenerate

//Layer 4
	generate
		for (i = 7; i < 64; i = i + 1) begin: Layer_4
			if (i==7) begin
				carry_gen CG4 (.Pi(P3[i]), .Gi(G3[i]), .Gki(Ci), .G(G4[i]));
			end
			else if (i==8) begin 
				carry_gen CG4 (.Pi(P3[i]), .Gi(G3[i]), .Gki(G1[i-8]), .G(G4[i]));
			end
			else if (i==9 || 10 ) begin 
				carry_gen CG4 (.Pi(P3[i]), .Gi(G3[i]), .Gki(G2[i-8]), .G(G4[i]));
			end
			else if (i==11 || 12 || 13 || 14) begin 
				carry_gen CG4 (.Pi(P3[i]), .Gi(G3[i]), .Gki(G3[i-8]), .G(G4[i]));
			end
 			else begin 
 				dot_ops DO4 (.Pi(P3[i]), .Gi(G3[i]), .Pki(P3[i-8]), .Gki(G3[i-8]), .P(P4[i]), .G(G4[i]));
 			end
		end
	endgenerate

 //Layer 5
 	generate
 		for (i = 15; i < 64; i = i + 1) begin: Layer_5
 			if (i==15) begin
 				carry_gen CG5 (.Pi(P4[i]), .Gi(G4[i]), .Gki(Ci), .G(G5[i]));
 			end
 			else if (i==16) begin 
 				carry_gen CG5 (.Pi(P4[i]), .Gi(G4[i]), .Gki(G1[i-16]), .G(G5[i]));
 			end
 			else if (i==17 || 18) begin 
 				carry_gen CG5 (.Pi(P4[i]), .Gi(G4[i]), .Gki(G2[i-16]), .G(G5[i]));
 			end
 			else if (i==19 || 20 || 21 || 22) begin 
 				carry_gen CG5 (.Pi(P4[i]), .Gi(G4[i]), .Gki(G3[i-16]), .G(G5[i]));
 			end
 			else if (i==23 || 24 || 25 || 26 || 27 || 28 || 29 || 30) begin 
 				carry_gen CG5 (.Pi(P4[i]), .Gi(G4[i]), .Gki(G4[i-16]), .G(G5[i]));
 			end
 			else begin 
 				dot_ops DO5 (.Pi(P4[i]), .Gi(G4[i]), .Pki(P4[i-16]), .Gki(G4[i-16]), .P(P5[i]), .G(G5[i]));
 			end
 		end
 	endgenerate
	
 //Layer 6
 	generate
 		for (i = 31; i < 64; i = i + 1) begin: Layer_6
 			if (i==31) begin
 				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(Ci), .G(G6[i]));
 			end
 			else if (i==32) begin 
 				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(G1[i-32]), .G(G6[i]));
 			end
 			else if (i==33 || 34) begin 
 				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(G2[i-32]), .G(G6[i]));
 			end
 			else if (i==35 || 36 || 37 || 38) begin 
 				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(G3[i-32]), .G(G6[i]));
 			end
 			else if (i==39 || 40 || 41 || 42 || 43 || 44 || 45 || 46) begin 
 				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(G4[i-32]), .G(G6[i]));
 			end
 			else begin 
				carry_gen CG6 (.Pi(P5[i]), .Gi(G5[i]), .Gki(G5[i-32]), .G(G6[i]));
 			end
 		end
 	endgenerate

	sum S0  (.Pi(P0[0]),  .Gki(Ci),    .Si(S[0]));
	sum S1  (.Pi(P0[1]),  .Gki(G1[0]), .Si(S[1]));
	sum S2  (.Pi(P0[2]),  .Gki(G2[1]), .Si(S[2]));
	sum S3  (.Pi(P0[3]),  .Gki(G2[2]), .Si(S[3]));
	sum S4  (.Pi(P0[4]),  .Gki(G3[3]), .Si(S[4]));
	sum S5  (.Pi(P0[5]),  .Gki(G3[4]), .Si(S[5]));
	sum S6  (.Pi(P0[6]),  .Gki(G3[5]), .Si(S[6]));
	sum S7  (.Pi(P0[7]),  .Gki(G3[6]), .Si(S[7]));
	
	generate
		for (i = 8; i < 16; i = i + 1) begin: add_4
				sum S4 (.Pi(P0[i]), .Gki(G4[i-1]), .Si(S[i]));
		end
	endgenerate

	generate
		for (i = 16; i < 32; i = i + 1) begin: add_5
				sum S4 (.Pi(P0[i]), .Gki(G5[i-1]), .Si(S[i]));
		end
	endgenerate
	
	generate
		for (i = 32; i < 64; i = i + 1) begin: add_6
				sum S4 (.Pi(P0[i]), .Gki(G6[i-1]), .Si(S[i]));
		end
	endgenerate
	
endmodule