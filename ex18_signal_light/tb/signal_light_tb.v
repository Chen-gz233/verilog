module signal_light_tb();
    reg clk ;
    reg rst_n ;
    wire [2:0] light1 ;
    wire [2:0] light2 ;
    wire [5:0] count ;

    always #10 clk = ~clk ;

    initial begin
        rst_n =0 ;
        clk = 0 ;
        #20 
        rst_n =1;

        #1000
        $finish ;
    end

    initial begin
        $fsdbDumpfile("test_tb.fsdb");
        $fsdbDumpvars;
    end

signal_light signal_light_tb (
    .clk    (clk)  ,
    .rst_n  (rst_n)  ,  

    .light1 (light1) , 
    .light2 (light2) ,
    .count  (count)
);



endmodule