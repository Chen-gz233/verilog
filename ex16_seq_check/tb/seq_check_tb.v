`timescale 1ns/1ns

module seq_check_tb();

reg clk ;
reg rst_n ;

reg data_in ;

wire flag ;

 
always #10 clk = ~ clk ;


initial begin
    rst_n = 0 ;
    clk = 0;
    #20
    rst_n = 1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b0 ;
    #20 data_in = 1'b1 ;
    $finish ;



end

initial begin
	$fsdbDumpfile("test_tb.fsdb");
	$fsdbDumpvars;
end


seq_check seq_check_tb(
    .clk  (clk),
    .rst_n  (rst_n),
    .data_in  (data_in),
    .flag    (flag)
);


endmodule