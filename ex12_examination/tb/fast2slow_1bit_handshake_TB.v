`timescale 1ns/1ns

module fast2slow_1bit_handshake_TB ();

reg clk_f ;
reg clk_s ;
reg rst_n ;
reg data_in ;
wire data_out;


always #10 clk_f = ~clk_f;

always #60 clk_s = ~clk_s ; 

initial begin
    clk_f = 1'b0;
    clk_s = 1'b0;
    rst_n = 1'b0;
    data_in = 1'b0;
    #100 

    rst_n = 1'b1;
    #100
    
    data_in = 1'b1;
    #20
    
    data_in = 1'b0;
    #100 
    
    data_in = 1'b1;
    #20

    data_in = 1'b0;
    #300
    $finish;


end

initial begin
	$fsdbDumpfile("cdc_tb.fsdb");
	$fsdbDumpvars(0);


end

fast2slow_1bit_handshake fast2slow_1bit_handshake_tb(
    .clk_f   (clk_f) ,
    .rst_n   (rst_n),
    .data_in (data_in),
    .clk_s   (clk_s),
    .data_out(data_out)
);

endmodule //fast2slow_1bit_handshake_TB