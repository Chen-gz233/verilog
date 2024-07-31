`timescale 1ns/1ns

module max_min(
    input  [3:0] in_a     ,
    input  [3:0] in_b     ,
    input  [3:0] in_c     ,
    input  [3:0] in_d     ,    

    output [3:0] out_max1  ,
    output [3:0] out_max2
);
wire  [3:0] max_ab = in_a >= in_b ? in_a : in_b ;
wire  [3:0] min_ab = in_a >= in_b ? in_b : in_a ;

wire [3:0]  max_cd = in_c >= in_d ? in_c : in_d ;
wire [3:0]  min_cd = in_c >= in_d ? in_d : in_c ;

wire [3:0] max_temp1= max_ab >= max_cd ? max_ab: max_cd ;
wire [3:0] max_temp2= max_ab >= max_cd ? max_cd: max_ab ;



assign out_max1 = max_temp1 ; //最大

assign out_max2 = max_temp2 > min_ab ? (max_temp2 > min_cd ? max_temp2 : min_cd ) : (min_ab> min_cd ? min_ab : min_cd );
 ; //最小

endmodule