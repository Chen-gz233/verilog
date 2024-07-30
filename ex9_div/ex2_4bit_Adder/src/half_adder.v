`timescale 1ns/1ns


module half_adder(
    input   A   ,
    input   B   ,
    output  S   ,
    output  Co

);
    assign S = A ^ B;
    assign Co = A & B;



endmodule