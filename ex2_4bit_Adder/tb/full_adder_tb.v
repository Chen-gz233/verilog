`timescale 1ns/1ns

module full_adder_tb();
// module full_adder(
//    input   A         ,
//    input   B         ,
//    input   C_in      ,

//    output  S         ,
//    output  C_out       
// );
reg A,B,C_in;
wire S,CO;

full_adder full_adder_tb(
    .A  (A ),
    .B  (B ),
    .C_in(C_in),
    .S  (S ),
    .C_out (CO)
);

initial begin
    A    = 0 ;
    B    = 0 ;
    C_in = 0 ;
    # 10
    A    = 0 ;
    B    = 0 ;
    C_in = 1 ;
    # 10
    A    = 0 ;
    B    = 1 ;
    C_in = 0 ;
    # 10
    A    = 0 ;
    B    = 1 ;
    C_in = 1 ;
    # 10
    A    = 1 ;
    B    = 0 ;
    C_in = 0 ;
    # 10
    A    = 1 ;
    B    = 0 ;
    C_in = 1 ;
    # 10
    A    = 1 ;
    B    = 1 ;
    C_in = 0 ;
    # 10
    A    = 1 ;
    B    = 1 ;
    C_in = 1 ;
    # 10
    $finish;



    
end
endmodule
