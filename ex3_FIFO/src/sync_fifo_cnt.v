`timescale 1ns / 1ps

module sync_fifo_cnt #(
    parameter DATA_WITH = 4'd8,     //FIFO 数据位宽
    parameter DATA_DEPTH = 5'd16    //FIFO 深度
)(
    input                             clk       ,
    input                             rst_n     ,
    input                             wr_en     ,
    input                             rd_en     ,
    input  [DATA_WITH-1:0]            buf_in    ,
    
    output reg [DATA_WITH-1:0]        buf_out   ,
    output                            empty     ,
    output                            full      ,
    output reg [$clog2(DATA_DEPTH):0] fifo_cnt      //$clog2() 以2为底取对数
    );

// 用二维数组实现RAM
reg [DATA_WITH - 1 : 0] fifo_buffer [DATA_DEPTH-1 : 0];
//  读指针 ，写指针
reg [$clog2(DATA_DEPTH)-1:0] rd_ptr;
reg [$clog2(DATA_DEPTH)-1:0] wr_ptr;


// 读操作，更新读地址
always @(posedge clk,negedge rst_n)begin
    if (!rst_n)begin
        rd_ptr <= 0;
        buf_out <= 0;
    end
    else if (!empty && rd_en)begin
         rd_ptr <= rd_ptr + 1'd1;
         buf_out <= fifo_buffer[rd_ptr];
    end
     
end

// 写操作,更新写地址
 always @(posedge clk,negedge rst_n)begin

    if (!rst_n)begin
        wr_ptr <= 0;
    end

    else if (!full && wr_en)begin
        wr_ptr <= wr_ptr + 1'd1;
        fifo_buffer[wr_ptr] <= buf_in;
    end
     
end

// 更新计数器
 always @(posedge clk,negedge rst_n)begin
    if (!rst_n)begin
        fifo_cnt <= 0;
    end
    else begin
        case({wr_en,rd_en})             //拼接读写使能信号进行判断
            2'b00:          //不读不写
                fifo_cnt <= fifo_cnt;    
            2'b01:          //只读
                if (fifo_cnt != 0)
                    fifo_cnt <= fifo_cnt - 1'b1;
            2'b10:          //只写
                if (fifo_cnt != DATA_DEPTH)
                    fifo_cnt <= fifo_cnt + 1'b1;
            2'b11:          //又读又写
                fifo_cnt <= fifo_cnt; 
            default:;
        endcase
    end

 end

assign full = (fifo_cnt == DATA_DEPTH) ? 1'b1 : 1'b0;
assign empty = (fifo_cnt == 0) ? 1'b1 : 1'b0; 
    
endmodule
