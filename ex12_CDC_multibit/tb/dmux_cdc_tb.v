`timescale 1ns/1ns
// `define clk_fast_period 35
// `define clk_slow_period 100


module dmux_cdc_tb();
     parameter clk_fast_period = 10;
     parameter clk_slow_period = 20;
     parameter DATA_WIDTH = 8;

     reg clk_f ;
     reg clk_s ;
     reg rst_n ;
     reg [DATA_WIDTH-1:0] data_in ;
     reg valid_in ;
     wire  [DATA_WIDTH-1 :0] data_out;
     wire  valid_out ;
    
    initial begin
        clk_s = 0;
        
        forever #(clk_slow_period/2) clk_s = ~ clk_s;

    end
    
    initial begin
        clk_f = 0; 
    
        forever #(clk_fast_period/2) clk_f = ~ clk_f;

    end
    
    initial begin
        rst_n = 0;
        repeat(10) @(posedge clk_f);
        rst_n = 1;

    end

    initial begin
        data_in =0 ;
        valid_in = 1'd0;
        repeat(20) @(posedge clk_f);
            repeat(10) begin;
            data_in ={$random}%8'hff ;
            valid_in = 1'd1;
            repeat(10) @(posedge clk_f); 
            valid_in = 1'd0;
            repeat(4) @(posedge clk_f);      
            end
        repeat(20) @(posedge clk_f);
        $finish;

    end

    dmux_cdc dmux_cdc_tb(
//     parameter tx_clk = 100,
//     parameter rx_clk = 50 ,
//     parameter DATA_WIDTH = 8

//     input clk_f ,
//     input clk_s ,
//     input rst_n  ,
//     input [DATA_WIDTH-1:0] data_in ,
//     input valid_in ,

//     output [DATA_WIDTH-1 :0] data_out,
//     output valid_out

        .clk_s   (clk_s), 
        .rst_n (rst_n),  
        .data_in (data_in), 
        .valid_in (valid_in),  
        .clk_f   (clk_f),   
        .data_out (data_out),
        .valid_out(valid_out)
    );
 
endmodule