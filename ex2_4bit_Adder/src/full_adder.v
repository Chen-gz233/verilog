`timescale 1ns/1ns

module full_adder(
    input   A         ,
    input   B         ,
    input   C_in      ,

    output  S         ,
    output  C_out     ,      
);
    assign S = A ^ B ^ C_in;
    assign C_out = ((A ^ B)&C_in) | (A&B) ;



endmodule