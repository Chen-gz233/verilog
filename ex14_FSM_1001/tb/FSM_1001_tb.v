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
data_in = 1'b0;
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
     #100
	$finish;

end

initial begin
	$fsdbDumpfile("test_tb.fsdb");
	$fsdbDumpvars;
end

FSM_1001 FSM_1001_tb(
	.clk(clk),
	.rst_n (rst_n),
	.data_in(data_in),
	.data_out(data_out)

);




endmodule