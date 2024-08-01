`timescale 1ns/1ns

module lca_4_tb();
// module lca_4(
// 	input		[3:0]       A_in  ,
// 	input	    [3:0]		B_in  ,
// 	input                   C_1   ,

// 	output	 wire			CO    ,
// 	output   wire [3:0]	    S
// );
reg  [3:0] A_in;
reg  [3:0] B_in;
reg      C_1;
wire [3:0] S;
wire      CO;

lca_4 lca_4_tb(
    .A_in   (A_in),
    .B_in   (B_in),
    .C_1    (C_1 ),
    .CO     (CO  ),
    .S  (S)
);

initial begin
    A_in  = 4'd1;
    B_in  = 4'd1;
    C_1   = 1'b1;
    # 10
    A_in  = 4'd2;
    B_in  = 4'd3;
    C_1   = 1'b1;
    # 10
    A_in  = 4'd4;
    B_in  = 4'd5;
    C_1   = 1'b0;
    # 10
    A_in  = 4'd7;
    B_in  = 4'd8;
    C_1   = 1'b1;
    # 10
    $finish;



    
end
endmodule
