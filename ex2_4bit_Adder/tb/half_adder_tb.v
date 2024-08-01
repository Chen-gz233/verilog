`timescale 1ns/1ns

module half_adder_tb();
// module half_adder(
//     input   A   ,
//     input   B   ,
//     output  S   ,
//     output  Co

// );
reg A,B;
wire S,CO;

half_adder half_adder_tb(
    .A  (A ),
    .B  (B ),
    .S  (S ),
    .Co (CO)
);

initial begin
    A   = 0;
    B   = 0;
    # 10
    A   = 0;
    B   = 1;
    # 10
    A   = 1;
    B   = 0;
    # 10
    A   = 1;
    B   = 1;
    # 10
    $finish;



    
end
endmodule
