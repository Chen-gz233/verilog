`timescale 1ns / 1ps

module even_div_tb();
     reg rst ;
     reg clk_in;
     wire clk_out3_or;
     wire clk_out3_xor;
     wire clk_out3_and;


  div3_or even_div_or(
  .rst_n(rst),
  .clk(clk_in),
  .clk_out3_or(clk_out3_or)
  );   
  

  div3_xor even_div_xor(
  .rst_n(rst),
  .clk(clk_in),
  .clk_out3_xor(clk_out3_xor)
  );   
  
  div3_and even_div_and(
  .rst_n(rst),
  .clk(clk_in),
  .clk_out3_and(clk_out3_and)
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
