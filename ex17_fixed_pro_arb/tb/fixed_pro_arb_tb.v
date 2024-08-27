module fixed_pro_arb_tb();

reg clk ;
reg rst_n ;

reg [2:0] req ;
wire [2:0] resp ;

always #10 clk = ~clk ;

always (posedge clk)begin
    req = $random % 8 ;
end

initial begin
    clk = 0;
    rst_n = 0 ;
    req = 0 ;

    #20 

    rst_n = 1;

    #500
    $finish ;
end

initial begin
    $fsdbDumpfile(test.fsdb);
    $fsdbDumpvars;
end

fixed_pro_arb fixed_pro_arb_tb(
    .clk(clk) ,
    .rst_n(rst_n) ,
    .req(req) ,

    .resp(resp) 
);

endmodule