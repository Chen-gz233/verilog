`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 18:35:58
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input  [7:0] buf_in,
    output reg [7:0] buf_out,
    output empty,
    output full,
    output reg [3:0] fifo_cnt
    );

// 创建存储数据的sram
reg [7:0] fifo_buffer[7:0];
// 读指针 & 写指针
reg [3:0] rd_ptr;
reg [3:0] wr_ptr;


// 读操作
always @(posedge clk,negedge rst_n)begin

    if (!rst_n)begin
        rd_ptr <= 0;
        buf_out <= 0;
    end
    else if (!empty && rd_en)begin
     
      if (rd_ptr == 4'd7)
         rd_ptr <= 4'd0; 
      else   
         rd_ptr <= rd_ptr + 1'd1;
       
      buf_out <= fifo_buffer[rd_ptr];
    end
     
end

// 写操作
 always @(posedge clk,negedge rst_n)begin

    if (!rst_n)begin
        wr_ptr <= 0;
    end

    else if (!full && wr_en)begin
        wr_ptr <= wr_ptr + 1'd1;
        if (wr_ptr == 4'd7)
            wr_ptr <= 4'd0;
        fifo_buffer[wr_ptr] <= buf_in;
    end
     
end

// 计数器更新
 always @(posedge clk,negedge rst_n)begin
    if (!rst_n)begin
        fifo_cnt <= 0;
    end
    else begin
        case({wr_en,rd_en})
            2'b00:
                fifo_cnt <= fifo_cnt;    //不读不写
            2'b01:                       // 只读
                if (fifo_cnt != 0)
                    fifo_cnt <= fifo_cnt - 1'b1;
            2'b10:                      // 只写
                if (fifo_cnt != 4'd7)
                    fifo_cnt <= fifo_cnt + 1'b1;
            2'b11:
                fifo_cnt <= fifo_cnt;  //读写同时
            default:;
        endcase
    end

 end

assign full = (fifo_cnt == 4'd7) ? 1'b1 : 1'b0;
assign empty = (fifo_cnt == 0) ? 1'b1 : 1'b0; 
    
endmodule
