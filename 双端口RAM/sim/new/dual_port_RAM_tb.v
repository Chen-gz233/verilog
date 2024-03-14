`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 21:51:58
// Design Name: 
// Module Name: dual_port_RAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module dual_port_RAM_tb();

parameter	WIDTH = 8;
parameter 	DEPTH = 16;

reg				clk;
reg 			rst_n;
reg 			winc;
reg 			rinc;
reg 		    [WIDTH-1:0]	wdata;

wire				wfull;
wire				rempty;
wire                [WIDTH-1:0]	rdata;
	
	
	 sfifo   #(
	.WIDTH  (WIDTH),
	.DEPTH(DEPTH)
)sfifo_1(
	.clk	(clk)	, 
	.rst_n(rst_n)	,
	.winc(winc)	,
	.rinc(rinc)	,
	.wdata(wdata)	,

	.wfull(wfull)	,
	.rempty(rempty)	,
	.rdata(rdata)
);
   real         CYCLE_200MHz = 5 ; //
    always begin
        clk = 0 ; #(CYCLE_200MHz/2) ;
        clk = 1 ; #(CYCLE_200MHz/2) ;
    end
     initial begin
     
     rst_n = 0; rinc = 0; winc = 0; wdata = 8'd0;
     #5 rst_n = 1; rinc = 1; winc = 1; wdata = 8'd1;    
     
     #5 rst_n = 1; rinc = 0; winc = 1; wdata = 8'd2;
     #5 rst_n = 1; rinc = 0; winc = 1; wdata = 8'd6;
     #5 rst_n = 1; rinc = 0; winc = 1; wdata = 8'd3;
     #5 rst_n = 1; rinc = 0; winc = 1; wdata = 8'd4;
     #5 rst_n = 1; rinc = 0; winc = 1; wdata = 8'd5;                   
     #5 rst_n = 1; rinc = 1; winc = 1; wdata = 8'd4;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 1;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 0;
     #5 rst_n = 1; rinc = 1; winc = 1;
      $stop;
 end
    
endmodule
