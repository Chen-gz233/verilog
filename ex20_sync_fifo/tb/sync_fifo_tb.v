module sync_fifo_tb();
    reg clk ;
    reg rst_n ;
    reg [7:0] data_in ;
    reg wr_en ;
    reg rd_en ;
    wire wr_full ;
    wire rd_empty ;

    wire [7:0] data_out ;

always #5 clk = ~ clk ;

initial begin
    clk = 0 ;
    rst_n = 0 ;
    wr_en = 0 ;
    rd_en = 0 ;
    data_in = 8'd0 ;
    #20 rst_n  = 1;
    wr_en = 1 ;
    #200 rd_en = 1;
    
    #500 $finish ;
end

always @(posedge clk)begin
    	if(rst_n) begin
			if( wr_full == 1'b0 )
				data_in <= data_in + 1;
			else
				data_in <= data_in;
		end
		else begin
			data_in <= 'b0;
		end
end

//    always @(*) begin
//		if(rst_n) begin
//			// 读数据
//			if( rd_empty == 1'b1 )begin
//				rd_en = 0;
//			end
//			else begin
//				rd_en = 1;
//			end
//		end
//	end


//	always @(*) begin
//		if(rst_n) begin
//			// 写数据
//			if( wr_full == 1'b1 )begin
//				wr_en = 0;
//			end
//			else begin
//				wr_en = 1;
//			end
//		end
//	end


sync_fifo sync_fifo_tb(
        .clk(clk) ,
        .rst_n(rst_n) ,

        .wr_en(wr_en) ,
        .rd_en(rd_en) ,

        .data_in(data_in) ,

        .data_out(data_out) ,

        .wr_full  (wr_full),
        .rd_empty (rd_empty)

);

initial begin
	$fsdbDumpfile("test_tb.fsdb");
	$fsdbDumpvars;
end
endmodule