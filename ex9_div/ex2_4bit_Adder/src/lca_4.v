`timescale 1ns/1ns
//4bit 超前加法器
module lca_4(
	input		[3:0]       A_in  ,
	input	    [3:0]		B_in  ,
	input                   C_1   ,

	output	 wire			CO    ,
	output   wire [3:0]	    S
);
	wire [3:0] G ;
	wire [2:0] C ;
	wire [3:0] P ;

	assign G = A_in & B_in;
	assign P = A_in ^ B_in;
	//这里{C,C_1}和{CO,C} 值得思考
	assign {CO,C} = G|(P&{C,C_1});
	assign S = P ^ {C,C_1};
endmodule