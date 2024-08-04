`timescale 1ns/1ns
`define clk_fast_period 35
`define clk_slow_period 100


module cdc_fast2slow_new_tb();
    reg clk_f   ;
    reg clk_s   ;
    reg pluse_f ;
    wire pluse_s ;
    
    initial begin
        clk_s = 0;
        
        forever #(`clk_slow_period/2) clk_s = ~ clk_s;

    end
    
    initial begin
        clk_f = 0; 
    
        forever #(`clk_fast_period/2) clk_f = ~ clk_f;

    end
    
    initial begin
        pluse_f = 0;
        repeat(10) @(posedge clk_f);
        pluse_f = 1;
         @(posedge clk_f);
        pluse_f = 0;
        repeat(10) @(posedge clk_f); 
        pluse_f = 1;
         @(posedge clk_f);
         pluse_f = 0;
        repeat(10) @(posedge clk_f);        
        $finish;

    end
    cdc_fast2slow_new cdc_fast2slowt_tb(
//    input clk_f ,
//    input clk_s ,
//    input pulse_f,

//    output pulse_s
        .clk_s   (clk_s),   
        .pulse_s (pluse_s),   
        .clk_f   (clk_f),   
        .pulse_f (pluse_f)
    );
 
endmodule