`define INPUTSIZE 64		//set the input size n
`define GROUPSIZE 1		//set the group size = 1, 2, 4 or 8

module variable_ksa(A,B,S);

	input	[`INPUTSIZE - 1:0]	A;
	input	[`INPUTSIZE - 1:0]	B;
	output	[`INPUTSIZE:0]		S;
	
	wire	[`INPUTSIZE / `GROUPSIZE:0]		cin;
	wire	[`INPUTSIZE / `GROUPSIZE * 2 - 1:0]	q;
	
	assign cin[0] = 1'b0;
	
	generate
	genvar i;
	for(i = 0;i < `INPUTSIZE / `GROUPSIZE;i = i + 1) begin: parallel_FA_CLA_prefix
		group_q_generation #(.Groupsize(`GROUPSIZE))
		f(.a(A[`GROUPSIZE * (i + 1) - 1:`GROUPSIZE * i]),
		  .b(B[`GROUPSIZE * (i + 1) - 1:`GROUPSIZE * i]),
		  .cin(cin[i]),
		  .s(S[`GROUPSIZE * (i + 1) - 1:`GROUPSIZE * i]),
		  .qg(q[i * 2 + 1:i * 2]));
	end
	endgenerate
	
	parallel_prefix_tree #(.Treesize(`INPUTSIZE / `GROUPSIZE))
	main(.q(q[`INPUTSIZE / `GROUPSIZE * 2 - 1:0]),
		 .cin(cin[`INPUTSIZE / `GROUPSIZE:1]));
	
	assign S[`INPUTSIZE] = cin[`INPUTSIZE / `GROUPSIZE];
	
endmodule

module parallel_prefix_tree #(parameter Treesize = `INPUTSIZE / `GROUPSIZE)(q,cin);

	input	[Treesize * 2 - 1:0]	q;
	output	[Treesize - 1:0]	cin;
	
	wire	[Treesize * 2 * ($clog2(Treesize) + 1) - 1:0]	r_temp;
	wire	[Treesize * 2 - 1:0]				r;
	
	//initialize r_temp
	assign r_temp[Treesize * 2 - 1:0] = q;
	
	//iteratively constructing the tree
	generate
	genvar i,j;
	for(i = 0;i < $clog2(Treesize);i = i + 1) begin: tree_level
		//pass the finished r_temp to the next level
		assign r_temp[Treesize * 2 * (i + 1) + (2 ** i) * 2 - 1:Treesize * 2 * (i + 1)] = r_temp[Treesize * 2 * i + (2 ** i) * 2 - 1:Treesize * 2 * i];
		//for each parallel prefix logic
		for(j = 2 ** i;j < Treesize;j = j + 1) begin: prefix_logic_group		
			prefix_logic f(.ql(r_temp[Treesize * 2 * i + (j - 2 ** i) * 2 + 1:Treesize * 2 * i + (j - 2 ** i) * 2]),
						   .qh(r_temp[Treesize * 2 * i + j * 2 + 1:Treesize * 2 * i + j * 2]),
						   .r(r_temp[Treesize * 2 * (i + 1) + j * 2 + 1:Treesize * 2 * (i + 1) + j * 2]));
		end
	end
	assign r = r_temp[Treesize * 2 * ($clog2(Treesize) + 1) - 1:Treesize * 2 * $clog2(Treesize)];
	for(i = 0;i < Treesize;i = i + 1) begin: cin_generation
		cin_generation_logic f(.r(r[2 * i + 1:2 * i]),
							   .c0(1'b0),
							   .cin(cin[i]));
	end
	endgenerate
	
endmodule

module group_q_generation #(parameter Groupsize = `GROUPSIZE)(a,b,cin,s,qg);

	input	[Groupsize - 1:0]	a;
	input	[Groupsize - 1:0]	b;
	input				cin;
	output	[Groupsize - 1:0]	s;
	output	[1:0]			qg;
	
	wire	[2 * Groupsize - 1:0]	q;
	wire	[Groupsize - 1:0]	c;
	
	assign c[0] = cin;
	
	generate
	genvar i;
	for(i = 0;i < Groupsize;i = i + 1) begin: parallel_FA_CLA_prefix
		FA_CLA_prefix f(.a(a[i]),
						.b(b[i]),
						.cin(c[i]),
						.s(s[i]),
						.q(q[i * 2 + 1:i * 2]));
		if(i != Groupsize - 1)begin: special_case
			assign c[i + 1] = q[i * 2 + 1] | q[i * 2] & c[i];
		end
	end
	
	//group q generation based on the Groupsize
	if(Groupsize == 1) begin: case_gs1
		assign qg[1] = q[1];
		assign qg[0] = q[0];
	end
	else if(Groupsize == 2) begin: case_gs2
		assign qg[1] = q[3] | (q[1] & q[2]);
		assign qg[0] = q[2] & q[0];
	end
	else if(Groupsize == 4) begin: case_gs4
		assign qg[1] = q[7] | (q[5] & q[6]) | (q[3] & q[6] & q[4]) | (q[1] & q[6] & q[4] & q[2]);
		assign qg[0] = q[6] & q[4] & q[2] & q[0];
	end
	else if(Groupsize == 8) begin: case_gs8
		assign qg[1] = q[15] | (q[13] & q[14]) | (q[11] & q[14] & q[12]) | (q[9] & q[14] & q[12] & q[10]) | (q[7] & q[14] & q[12] & q[10] & q[8]) | (q[5] & q[14] & q[12] & q[10] & q[8] & q[6]) | (q[3] & q[14] & q[12] & q[10] & q[8] & q[6] & q[4]) | (q[1] & q[14] & q[12] & q[10] & q[8] & q[6] & q[4] & q[2]);
		assign qg[0] = q[14] & q[12] & q[10] & q[8] & q[6] & q[4] & q[2] & q[0];
	end
	endgenerate
	
endmodule
//Cin_generation_logic
module cin_generation_logic(r,c0,cin);

	input	[1:0]	r;
	input		c0;
	output		cin;
	
	assign cin = (r[0] & c0) | r[1];
	
endmodule

//basic_logic
module prefix_logic(ql,qh,r);
	
	input	[1:0]	ql;
	input	[1:0]	qh;
	output	[1:0]	r;
	
	assign r[0] = qh[0] & ql[0];
	assign r[1] = (qh[0] & ql[1]) | qh[1];
	
endmodule

//FA_cell_CLA
module FA_CLA_prefix(a,b,cin,s,q);

	input 		a;
	input 		b;
	input 		cin;
	output 		s;
	output	[1:0]	q;
	
	assign q[0] = a ^ b;
	assign s = q[0] ^ cin;
	assign q[1] = a & b;

endmodule