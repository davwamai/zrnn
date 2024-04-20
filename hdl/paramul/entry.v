module Entry (
	input Ai, Bi,
	output Pi, Gi	
);

	xor (Pi, Ai, Bi);
	and (Gi, Ai, Bi);

endmodule