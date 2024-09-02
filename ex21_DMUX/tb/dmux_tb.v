module dmux_tb ();

reg clk_a ;
reg clk_b ;
reg rst_n ;
reg [7:0] data_in ;
reg data_in_valid ;

wire  [7:0] data_out ;
wire data_out_valid ;


always #20 clk_a = ~clk_a ;
always #10 clk_b = ~clk_b ;

initial begin
    rst_n = 0 ;
    clk_a = 1 ;
    clk_b = 1 ;
    data_in_valid = 0 ;
    data_in = 0 ;
    #40 

    rst_n = 1 ;
    data_in = 8'd54 ;
    #40

    data_in_valid = 1 ;
    #40
    data_in_valid = 0 ;
    #100;

    $finish;

end

 dmux dmux_tb (
    .clk_a (clk_a),
    .rst_n (rst_n),
    .clk_b (clk_b),
    .data_in (data_in),
    .data_in_valid (data_in_valid),

    .data_out (data_out),
    .data_out_valid(data_out_valid)
);

endmodule //dmux_tb