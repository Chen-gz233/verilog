`timescale 1ns / 1ps

module even_div_tb();
     reg rst ;
     reg clk_in;
     wire clk_out2;
     wire clk_out4;
     wire clk_out8;
  even_div even_div01(
  .rst(rst),
  .clk_in(clk_in),
  .clk_out2(clk_out2),
  .clk_out4(clk_out4),
  .clk_out8(clk_out8)
  );   
  
  real         CYCLE_200MHz = 5 ;
  always #CYCLE_200MHz clk_in = ~clk_in ;
 initial begin
  rst=0;clk_in=0;
  #40 rst=1;
  #400
  $finish;
    end
    
endmodule
