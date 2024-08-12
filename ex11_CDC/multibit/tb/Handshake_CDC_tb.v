`timescale 1ns/1ns


module cdc_tb();

reg clk_driver ;

reg clk_receiver;

reg rst_n	;
initial begin
clk_driver = 0;

forever #30 clk_driver =~ clk_driver;

end 

initial begin

clk_receiver = 0;
forever #45 clk_receiver =~ clk_receiver;

end 


initial begin
rst_n = 0;

repeat (25) @(posedge clk_driver);

rst_n = 1;

repeat (250) @(posedge clk_driver);

$finish;
end

initial begin
	$fsdbDumpfile("cdc_tb.fsdb");
	$fsdbDumpvars(0);


end


CDC_TOP cdc_top_tb(
	.clk_driver(clk_driver),
	.clk_receiver(clk_receiver),
	.rst_n(rst_n)
);


endmodule 