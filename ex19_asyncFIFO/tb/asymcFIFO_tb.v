module asyncFIFO_tb();

reg clk_a ;
reg clk_b ;
reg rst_n ;

reg wr_en ;
reg rd_en ;

reg [7:0] data_in ;
wire [7:0] data_out ;

wire wfull  ;
wire rempty ;

always #10 clk_a = ~clk_a ;
always #20 clk_b = ~clk_b ;

initial begin
rst_n = 0 ;
clk_a = 0 ;
clk_b = 0 ;
#10;

rst_n = 1 ;
#500;
$finish;


end

always @(posedge clk_a) begin
		if(rst_n) begin
			if( wfull == 1'b0 )
				data_in <= data_in + 1;
			else
				data_in <= data_in;
		end
		else begin
			data_in <= 'b0;
		end
	end


always @(*) begin
		if(rst_n) begin
			// 读数据
			if( rempty == 1'b1 )begin
				rd_en = 0;
			end
			else begin
				rd_en = 1;
			end
		end
	end


	always @(*) begin
		if(rst_n) begin
			// 写数据
			if( wfull == 1'b1 )begin
				wr_en = 0;
			end
			else begin
				wr_en = 1;
			end
		end
	end


asyncFIFO asyncFIFO_tb(
        .clk_a(clk_a) ,
        .clk_b(clk_b) ,
        .rst_n(rst_n) ,

        .wr_en(wr_en) ,
        .rd_en(rd_en) ,

        .data_in(data_in) ,

        .data_out(data_out) ,

        .wfull  (wfull),
        .rempty (rempty)

);




endmodule