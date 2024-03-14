`timescale 1ns / 1ps
`define clock 20

module sequence_detect_tb( );
    reg clk,rst_n;
	reg data;
	reg data_valid;
	wire match;
	
sequence_detect sequence_detect01(
    .data(data),
    .clk(clk),
    .rst_n(rst_n),
    .data_valid(data_valid),
    .match(match)
    );	
    
     real         CYCLE_200MHz = 5 ; 
    always begin
        clk = 0 ; #(CYCLE_200MHz/2) ;
        clk = 1 ; #(CYCLE_200MHz/2) ;
    end
    
    initial begin
    rst_n = 0; data_valid = 0; data = 0;
    #5  rst_n = 1; data_valid = 0;   data = 0;
    #5  rst_n = 1; data_valid = 1;   data = 0;
    #5  rst_n = 1; data_valid = 1; data = 1;
    #5  rst_n = 1; data_valid = 1; data = 1;
    #5  rst_n = 1; data_valid = 1; data = 0;
    #5  rst_n = 1; data_valid = 1; data = 0;

    #5  rst_n = 1; data_valid = 1; data = 1;
    #5  rst_n = 1; data_valid = 1; data = 1;
    #5  rst_n = 1; data_valid = 1; data = 0;
    #5  rst_n = 1; data_valid = 1; data = 0;
    
 $stop;
 end
endmodule
