`timescale 1ns/1ns

module FSM_1001_tb();

reg clk ;
reg data_in ;
reg rst_n ;

wire data_out ;

always #10 clk = ~clk;

initial begin
    clk = 1'b0 ;
    rst_n = 1'b0 ;
    #20
    rst_n = 1'b1;

    #20 data_in = 1 ;
    #20 data_in = 0 ;
    #20 data_in = 0 ;
    #20 data_in = 0 ;
    #20 data_in = 0 ;
    #20 data_in = 1 ;
    #20 data_in = 0 ;
    #20 data_in = 1 ;
    #20 data_in = 0 ;
    #20 data_in = 0 ;
    #20 data_in = 1 ;
    #20 data_in = 1 ;
    #20 data_in = 1 ;
    #20 data_in = 0 ;
    #20 data_in = 0 ;
    #20 data_in = 1 ;


end
endmodule