`timescale 1ns / 1ps

module max_min_tb();
/*---------------------------------------------------------------------------------------------*/
reg  [3:0] in_a,in_b,in_c,in_d;
wire [3:0] out_max1,out_max2;
/*---------------------------------------------------------------------------------------------*/
max_min max_min_tb
(
    .in_a   (in_a ),
    .in_b   (in_b ),
    .in_c   (in_c),
    .in_d   (in_d ),

     .out_max1(out_max1),  
     .out_max2(out_max2) 
     
); 

initial begin
    in_a = 4'd1 ;
    in_b = 4'd2 ;
    in_c = 4'd3 ;
    in_d = 4'd4 ;
    #20;
    in_a = 4'd8 ;
    in_b = 4'd7 ;
    in_c = 4'd6 ;
    in_d = 4'd5 ;
    #20;
    in_a = 4'd9 ;
    in_b = 4'd11 ;
    in_c = 4'd10 ;
    in_d = 4'd12 ;
    #20;
    $stop;
end   
endmodule