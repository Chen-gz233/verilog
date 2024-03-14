`timescale 1ns/1ns

module testbench();

	reg clk,rst_n;
	reg set,boost;
	reg [9:0]money;
	wire red,yellow;
	wire [9:0]remain;

	real         CYCLE_50MHz = 20 ; 
    always begin
        clk = 0 ; #(CYCLE_50MHz/2) ;
        clk = 1 ; #(CYCLE_50MHz/2) ;
    end
    
    
    initial begin
        rst_n = 0;set = 0;boost = 0; #20;
        rst_n = 1; #20;
        money = 9'd15;set = 1;#20;
        set = 0;#320;
        money = 9'd50;set = 1;#20;
        set = 0;#200;
        boost = 1 ;#200;
        money = 9'd20;set = 1;#20;
         set = 0;#550;
         $stop;
    end
    

game_count dut
    (
		.rst_n(rst_n), 
        .clk(clk), 
        .set(set),
		.money(money),
        .boost(boost),
		.red(red),
		.yellow(yellow),
		.remain(remain)
    );

endmodule