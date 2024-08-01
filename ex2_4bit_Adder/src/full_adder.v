`timescale 1ns/1ns

module full_adder(
    input   A         ,
    input   B         ,
    input   C_in      ,

    output  S         ,
    output  C_out           
);
    assign S = A ^ B ^ C_in;//相同为0不同为1
    assign C_out = (A & B)|(A & C_in)| (B & C_in) ; //有一个1就是满足进位



endmodule