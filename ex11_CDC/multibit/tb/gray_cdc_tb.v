`timescale 1ns/1ns
`define clk_fast_period 35
`define clk_slow_period 100


module gray_cdc_tb();
    reg clk_f   ;
    reg clk_s   ;
    reg [3:0] data_in ;
    wire [3:0] data_out ;
    
    initial begin
        clk_s = 0;
        
        forever #(`clk_slow_period/2) clk_s = ~ clk_s;

    end
    
    initial begin
        clk_f = 0; 
    
        forever #(`clk_fast_period/2) clk_f = ~ clk_f;

    end
    
    initial begin
        data_in = 4'd0;
//        repeat(10) @(posedge clk_s);
        repeat(16) @(posedge clk_s)begin;
        data_in =data_in +1 ;
        end
        data_in = 4'd0;
        repeat(10) @(posedge clk_s);        
        $finish;

    end
    gray_cdc gray_cdc_tb(
//    input clk_s,
//    input clk_f,
//    input [3:0] data_in,
    
//    output [3:0] data_out 
        .clk_s   (clk_s),   
        .data_in (data_in),   
        .clk_f   (clk_f),   
        .data_out (data_out)
    );
 
endmodule