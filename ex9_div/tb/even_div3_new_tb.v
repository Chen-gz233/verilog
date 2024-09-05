`timescale 1ns/1ns

module even_div3_new();

reg clk ;
reg rst_n ;

wire clk_out_1_3 ;
wire clk_out_2_3 ;
wire clk_out_1_2 ;

always #10 clk = ~clk ;


initial begin
    clk = 0 ;
    rst_n = 0 ;
    #20 ;

    rst_n = 1 ;
    #500
    $finish ;

end

div3_1_3 div3_1_3_tb(
    .clk(clk),
    .rst_n(rst_n),
    .clk_out_1_3(clk_out_1_3)
);

div3_2_3 div3_2_3_tb(
    .clk(clk),
    .rst_n(rst_n),
    .clk_out_2_3(clk_out_2_3)    
);

div3_1_2 ddiv3_1_2_tb(
    .clk(clk),
    .rst_n(rst_n),
    .clk_out_1_2(clk_out_1_2)    
);


endmodule