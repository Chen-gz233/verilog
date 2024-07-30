`timescale 1ns / 1ps

module test_tb( );
    reg             E1_n    ;
    reg             E2_n    ;
    reg             E3  ;
    
    reg             A  ;
    reg             B  ;
    reg             C  ;
    
	wire       Y0_n   ;
    wire       Y1_n   ; 
    wire       Y2_n   ; 
    wire       Y3_n   ; 
    wire       Y4_n   ; 
    wire       Y5_n   ; 
    wire       Y6_n   ; 
    wire       Y7_n   ;
    wire       L;

decoder0 aaa01(

        .A (A),
        .B (B),
        .C (C),
        .L(L)
    );
    
    initial begin
   A=0;B=0;C=0;
   E1_n =1'b0;E2_n =1'b0;E3 =1'b1;
    #10 A=1;B=0;C=0;
    #10 A=0;B=1;C=0;
    #10 A=1;B=1;C=0;
    #10 A=0;B=0;C=1;
    #10 A=1;B=0;C=1;
    #10 A=0;B=1;C=1;
    #10 A=1;B=1;C=0;
    #10 A=1;B=1;C=1;
     $stop;
    end

endmodule
