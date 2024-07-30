`timescale 1ns / 1ps


module seller1_tb();
    reg clk;
    reg rst;
    reg d1;
    reg d2;
    reg d3;
        
    wire out1;
    wire [1:0]out2;
    
 seller1 seller1_tb_1(
     .clk(clk),
     .rst(rst),
     .d1(d1),
     .d2(d2),
     .d3(d3),
     .out1(out1),
     .out2(out2)
 ); 
 real         CYCLE_200MHz = 5 ; //
    always begin
        clk = 0 ; #(CYCLE_200MHz/2) ;
        clk = 1 ; #(CYCLE_200MHz/2) ;
    end

initial begin
rst = 1'b0;
{d1,d2,d3}=3'b000;
#5;
rst = 1'b1;

@(posedge clk); {d1,d2,d3}=3'b100;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b010;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b100;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b100;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b001;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b100;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b010;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b010;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b001;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
@(posedge clk); {d1,d2,d3}=3'b001;
@(negedge clk); {d1,d2,d3}=3'b000;
#5
$finish;
end

endmodule
