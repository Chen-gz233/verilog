`timescale 1ns/1ns

module sync_fifo_ptr #(
    parameter DATA_WIDTH  = 4'd8,
    parameter DATA_DEPTH  = 5'd16 
)(
    input                           clk        ,
    input                           rst_n      ,
    input      [DATA_WIDTH-1 : 0]   data_in    ,
    input                           rd_en      ,
    input                           wr_en      ,

    output reg [DATA_WIDTH-1 :0]   data_out   , 
    output                         empty      ,
    output                         full 

);
    //FIFO buffer
reg [DATA_WIDTH-1 : 0 ] fifo [DATA_DEPTH-1 :0];
//扩展后的位宽 地址
reg [$clog2(DATA_DEPTH):0] wr_ptr;
reg [$clog2(DATA_DEPTH):0] rd_ptr;

//真实位宽 地址
wire [$clog2(DATA_DEPTH)-1:0] wr_ptr_true;
wire [$clog2(DATA_DEPTH)-1:0] rd_ptr_true;
wire wd_ptr_hi;
wire rd_ptr_hi;

assign {wd_ptr_hi,wr_ptr_true} = wr_ptr;
assign {rd_ptr_hi,rd_ptr_true} = rd_ptr;

//读操作,更新读地址
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        rd_ptr <= 0;
        data_out<= 0;
    end else if(!empty && rd_en)begin
        data_out <= fifo[rd_ptr_true];
        rd_ptr <= rd_ptr + 1'd1;
    end
end

//写操作,更新写地址
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        wr_ptr <= 0;
    end else if(!full && rd_en)begin
        fifo[wr_ptr_true] <= data_in;
        wr_ptr <= wr_ptr + 1'd1;
    end
end

//当所有位相等时，读指针追到到了写指针，FIFO被读空
assign empty = (wr_ptr == rd_ptr ) ? 1'b1 : 1'b0;

//当最高位不同但是其他位相等时，写指针超过读指针一圈，FIFO被写满
assign full = ((wd_ptr_hi != rd_ptr_hi) && (wr_ptr_true == rd_ptr_true))? 1'b1 : 1'b0;
endmodule