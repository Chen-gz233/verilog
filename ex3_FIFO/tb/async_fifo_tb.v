`timescale 1ns / 1ns

module async_fifo_tb();
	parameter WIDTH = 8;
	parameter PTR   = 4;
	// 写时钟域tb信号定义
	reg					wrclk		;
	reg					wr_rst_n	;
	reg	[WIDTH-1:0]		wr_data		;
	reg 				wr_en		;
	wire				wr_full		;
	// 读时钟域tb信号定义
	reg					rdclk		;
	reg					rd_rst_n	;
	wire [WIDTH-1:0]	rd_data		;
	reg					rd_en		;
	wire				rd_empty	;
	// testbench自定义信号
	reg					init_done	;		// testbench初始化结束
	// FIFO初始化
	initial	begin
		// 输入信号初始化
		wr_rst_n  = 1	;
		rd_rst_n  = 1	;
		wrclk 	  = 0	;
		rdclk 	  = 0	;
		wr_en 	  = 0	;
		rd_en 	  = 0	;
		wr_data   = 'b0 ;
		init_done = 0	;
 
		// FIFO复位
		#30 wr_rst_n = 0;
			rd_rst_n = 0;
		#30 wr_rst_n = 1;
			rd_rst_n = 1;
 
		// 初始化完毕
		#30 init_done = 1;
	end
 
 
 
	// 写时钟
	always
		#2 wrclk = ~wrclk;
 
	// 读时钟
	always
		#4 rdclk = ~rdclk;
 
 
 
	// 读写控制
	always @(*) begin
		if(init_done) begin
			// 写数据
			if( wr_full == 1'b1 )begin
				wr_en = 0;
			end
			else begin
				wr_en = 1;
			end
		end
	end
	always @(*) begin
		if(init_done) begin
			// 读数据
			if( rd_empty == 1'b1 )begin
				rd_en = 0;
			end
			else begin
				rd_en = 1;
			end
		end
	end
 
 
 
	// 写入数据自增
	always @(posedge wrclk) begin
		if(init_done) begin
			if( wr_full == 1'b0 )
				wr_data <= wr_data + 1;
			else
				wr_data <= wr_data;
		end
		else begin
			wr_data <= 'b0;
		end
	end
 
 
 
	// 异步fifo例化
//	module async_fifo #(
//    parameter DATA_WIDTH  = 4'd8,
//    parameter DATA_DEPTH  = 5'd16
//)(
//    input                           wrclk      ,
//    input                           rdclk      ,
    
//    input                           rd_rst_n   ,
//    input                           wr_rst_n   ,
    
//    input      [DATA_WIDTH-1 : 0]   data_in    ,
//    output reg [DATA_WIDTH-1 : 0]   data_out   , 
    
//    input                           rd_en      ,
//    input                           wr_en      ,


//    output reg                      fifo_full  ,
//    output reg                      fifo_empty


//);
	
	
	async_fifo
		# ( .DATA_WIDTH(8),
		    .DATA_DEPTH(16) )
		U_ASFIFO
		(
			.wrclk	 	(wrclk		),
			.wr_rst_n	(wr_rst_n	),
			.data_in	(wr_data	),
			.wr_en		(wr_en		),
			.fifo_full	(wr_full	),
 
			.rdclk		(rdclk		),
			.rd_rst_n	(rd_rst_n	),
			.data_out	(rd_data	),
			.rd_en		(rd_en		),
			.fifo_empty	(rd_empty	)
		);
 
 
endmodule