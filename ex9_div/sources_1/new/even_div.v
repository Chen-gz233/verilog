`timescale 1ns / 1ps


module even_div
    (
    input     wire rst ,
    input     wire clk_in,
    output    wire clk_out2,
    output    wire clk_out4,
    output    wire clk_out8
    );
//*************code***********//
    reg out2;//D触发器，信号取反
    reg out4;
    reg out8;
    
    always @(posedge clk_in or negedge rst) begin //二分频
        if(rst == 1'b0) 
            out2 <= 1'b0;
        else
            out2 <= ~out2;
    end
    
    always @(posedge out2 or negedge rst) begin //四分频
         if(rst == 1'b0) 
             out4 <= 1'b0;
         else
            out4 <= ~out4;
    end
    
    always @(posedge out4 or negedge rst) begin 
        if(rst == 1'b0) 
            out8 <= 1'b0;
        else
            out8 <= ~out8;
    end
    
    assign clk_out2 = out2;
    assign clk_out4 = out4;
    assign clk_out8 = out8;
            
//*************code***********//
endmodule
