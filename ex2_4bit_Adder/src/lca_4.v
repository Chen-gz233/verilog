`timescale 1ns/1ns
//4bit 超前加法器
module lca_4(
	input		[3:0]       A_in  ,
	input	    [3:0]		B_in  ,
	input                   C_1   ,

	output	 wire			CO    ,
	output   wire [3:0]	    S
);
	// wire [3:0] G ;
	// wire [2:0] C ;
	// wire [3:0] P ;
	// assign G = A_in & B_in;
	// assign P = A_in ^ B_in;
	// //这里{C,C_1}和{CO,C} 值得思考
	// assign {CO,C} = G|(P&{C,C_1});
	// assign S = P ^ {C,C_1};
/*
			A	1001
			B	0101
			C      1
			--------
			G   0001
			P   1100
{C,C_1}     	0001
P&{C,C_1}		0000	
G|(P&{C,C_1})   0001
P ^ {C,C_1}     1101
ps: 太复杂
*/





// module full_adder(
//     input   A         ,
//     input   B         ,
//     input   C_in      ,

//     output  S         ,
//     output  C_out     ,      
// );

wire [3:0] C;

full_adder adder0(
	.A    (A_in[0]),
	.B    (B_in[0]),
	.C_in (C_1),
	.S    (S[0]),
	.C_out(C[0])
);

full_adder adder1(
	.A    (A_in[1]),
	.B    (B_in[1]),
	.C_in (C[0]),
	.S    (S[1]),
	.C_out(C[1])
);

full_adder adder2(
	.A    (A_in[2]),
	.B    (B_in[2]),
	.C_in (C[1]),
	.S    (S[2]),
	.C_out(C[2])
);

full_adder adder3(
	.A    (A_in[3]),
	.B    (B_in[3]),
	.C_in (C[2]),
	.S    (S[3]),
	.C_out(CO)
);

endmodule