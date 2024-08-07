`timescale 1ns/1ns
`define clk_fast_period 35
`define clk_slow_period 100


module cdc_slow2fast_tb();
    reg clk_f   ;
    reg clk_s   ;
    reg pluse_s ;
    wire pluse_f ;
    initial begin
        clk_s = 0;
        
        forever #(`clk_slow_period/2) clk_s = ~ clk_s;

    end
    
    initial begin
        clk_f = 0; 
    
        forever #(`clk_fast_period/2) clk_f = ~ clk_f;

    end
    
    initial begin
        pluse_s = 0;
        repeat(2) @(posedge clk_s);
        pluse_s = 1;
        repeat(2) @(posedge clk_s);
        pluse_s = 0;
        repeat(2) @(posedge clk_s);        
        $finish;

    end
    cdc_slow2fast cdc_slow2fast_tb(

        .clk_s   (clk_s),   
        .pluse_s (pluse_s),   
        .clk_f   (clk_f),   
        .pluse_f (pluse_f)
    );
 
endmodule