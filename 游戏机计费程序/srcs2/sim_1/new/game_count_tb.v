`timescale 1ns/1ns

module testbench();

	reg clk,rst_n;
	reg set,boost;
	reg [9:0]money;
	wire red,yellow;
	wire [9:0]remain;

	
initial begin
     #10;
	clk = 1; #10;
	rst_n = 0; #10;
    #10;
    rst_n = 1; #10;
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