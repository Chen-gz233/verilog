`timescale 1ns/1ns
//CDC 握手协议 ： 发送端模块
module data_driver (
	input clk_driver,
	input rst_n,
	input data_ack,	//从接收端返回的信号
	
	output reg [3:0] data_driver,
	output reg data_req
);

	reg data_ack_ff1;
	reg data_ack_ff2;
	
	wire data_ack_post;
	assign data_ack_post = data_ack_ff1 && ! data_ack_ff2 ; 
	

	//data_ack 信号是与接收端的时钟同步。跨时钟域处理
	always @(posedge clk_driver or negedge rst_n)begin
		if(!rst_n)begin
			data_ack_ff1 <= 1'd0;
			data_ack_ff2 <= 1'd0;
		end else begin
			data_ack_ff1 <= data_ack;
			data_ack_ff2 <= data_ack_ff1;
		end
	
	end
	
	reg [3:0] cnt;
	//计数器
	always @(posedge clk_driver or negedge rst_n)begin
		if(!rst_n)begin
			cnt <= 1'd0;
		end else if(data_ack_post) begin
			cnt <= 'd0;
		end else if (data_req)begin
			cnt <= cnt ;
		end else begin
			cnt <= cnt + 1;
		end
	
	end
	//产生请求信号： 计数器逢5传输一次
	always @(posedge clk_driver or negedge rst_n)begin
		if (!rst_n) begin
			data_req <= 1'd0;
		end else if (cnt == 3'd4)begin
			data_req <= 1'd1;
		end else if (data_ack_post)begin
			data_req <= 'd0;
		end else begin
			data_req <= data_req;
		end
	
	end
	//输出数据
	always @(posedge clk_driver or negedge rst_n) begin
		if(!rst_n)begin
			data_driver <= 1'd0;
		end else if(data_ack_post)begin
			data_driver <= data_driver +1 ;
		end else begin
			data_driver <= data_driver;
		end
	
	end

endmodule



module data_receiver(
	input clk_receiver,
	input rst_n ,
	input data_req,
	input [3:0] data_driver,
	
	output reg data_ack
	);

	reg data_req_ff1;
	reg data_req_ff2;
	wire data_req_post;
	//req上升沿检测
	assign data_req_post = data_req_ff1 && ! data_req_ff2 ;
	
	
	reg [3:0] data_reg;
	
	
	//同步data_req
	always @(posedge clk_receiver or negedge rst_n)begin
		if(!rst_n)begin
			data_req_ff1 <= 1'd0;
			data_req_ff2 <= 1'd0;
			
		end else begin
			data_req_ff1 <= data_req;
			data_req_ff2 <= data_req_ff1;
		end
	end

	//ack 反馈
	always @(posedge clk_receiver or negedge rst_n)begin
		if(!rst_n)begin
			data_ack <=1 'd0;	
		end else if(data_req_ff2)begin
			data_ack <= 1'd1;
		end else begin
			data_ack <= 1'd0;
		end
	end
	//接受数据
	always @(posedge clk_receiver or negedge rst_n)begin
		if(!rst_n)begin
			data_reg <= 1'd0;	
		end else if(data_req_post)begin
			data_reg <= data_driver;
		end else begin
			data_reg <= data_reg;
		end
	end



endmodule


module CDC_TOP(
	input clk_driver,
	input clk_receiver,
	input rst_n
);

	wire data_req;
	wire data_ack;
	wire [3:0] data;
	
	
	data_driver data_driver_1 (
	.clk_driver(clk_driver),
	.rst_n(rst_n),
	.data_ack(data_ack),
	.data_driver(data),
	.data_req(data_req)
	);
	
	data_receiver data_receiver_1 (
	.clk_receiver(clk_receiver),
	.rst_n(rst_n),
	.data_req(data_req),
	.data_driver(data),
	.data_ack(data_ack)
	
	);
endmodule