`timescale 1ns/1ns

//异步FIFO
module async_fifo #(
    parameter DATA_WIDTH  = 4'd8,
    parameter DATA_DEPTH  = 5'd16
)(
    input                           wrclk      ,
    input                           rdclk      ,
    
    input                           rd_rst_n   ,
    input                           wr_rst_n   ,
    
    input      [DATA_WIDTH-1 : 0]   data_in    ,
    output reg [DATA_WIDTH-1 : 0]   data_out   , 
    
    input                           rd_en      ,
    input                           wr_en      ,


    output                       fifo_full  ,
    output                       fifo_empty


);
    //FIFO buffer
reg [DATA_WIDTH-1 : 0 ] fifo [DATA_DEPTH-1 :0];

    reg [$clog2(DATA_DEPTH):0]    wr_addr    ;          // 二进制写地址
    reg [$clog2(DATA_DEPTH):0]    rd_addr    ;
   
    reg [$clog2(DATA_DEPTH):0]    wr_addr_gray    ;      // 格雷码写地址
    reg [$clog2(DATA_DEPTH):0]    rd_addr_gray    ;
    
    reg [$clog2(DATA_DEPTH):0]    gray_addr_wr    ;
    reg [$clog2(DATA_DEPTH):0]    gray_addr_rd    ;         // 同步到写时钟域的二进制读地址

    reg [$clog2(DATA_DEPTH):0]    wr_addr_gray_ff1    ;     // 格雷码地址同步寄存器
    reg [$clog2(DATA_DEPTH):0]    wr_addr_gray_ff2    ;
   
    reg [$clog2(DATA_DEPTH):0]    rd_addr_gray_ff1    ;
    reg [$clog2(DATA_DEPTH):0]    rd_addr_gray_ff2    ;
    
    wire wd_ptr_hi   = wr_addr[$clog2(DATA_DEPTH)]          ; 
    wire rd_ptr_hi   = gray_addr_rd[$clog2(DATA_DEPTH)]     ; 
    wire wd_ptr_true = wr_addr[$clog2(DATA_DEPTH)-1:0]      ; 
    wire rd_ptr_true = gray_addr_rd[$clog2(DATA_DEPTH)-1:0] ; 
    
//读时钟域,更新读地址
always @(posedge rdclk or negedge rd_rst_n)begin
    if(!rd_rst_n) begin
        rd_addr  <= 0;
        data_out <= 0;
    end else if(!fifo_empty && rd_en)begin
        data_out <= fifo[rd_addr[$clog2(DATA_DEPTH)-1:0]];
        rd_addr  <= rd_addr + 1'd1;
    end
    else begin
        rd_addr <= rd_addr;
    end 
end

//写时钟域,更新写地址
always @(posedge wrclk or negedge wr_rst_n)begin
    if(!wr_rst_n) begin
        wr_addr <= 0;
    end else if(!fifo_full && wr_en)begin
        fifo[wr_addr[$clog2(DATA_DEPTH)-1:0]] <= data_in;
        wr_addr <= wr_addr + 1'd1;
    end
end

//写地址转格雷码
always @(posedge wrclk or negedge wr_rst_n)begin
    if(!wr_rst_n)begin
        wr_addr_gray <= 'd0;
    end
    else begin          //转格雷码 ： 最高位不变，从次高位开始，与前一位做异或(^)
    wr_addr_gray <= {wr_addr[$clog2(DATA_DEPTH)],wr_addr[$clog2(DATA_DEPTH):1] ^ wr_addr[$clog2(DATA_DEPTH)-1:0]};
    end
end

//读地址转格雷码
always @(posedge rdclk or negedge rd_rst_n)begin
    if(!rd_rst_n)begin
        rd_addr_gray <= 'd0;
    end
    else begin          //转格雷码 ： 最高位不变，从次高位开始，与前一位做异或(^)
    rd_addr_gray <= {rd_addr[$clog2(DATA_DEPTH)],rd_addr[$clog2(DATA_DEPTH):1] ^ rd_addr[$clog2(DATA_DEPTH)-1:0]};
    end
end


//格雷码跨时钟域——wr_addr2rd_clk
//写地址同步到读时钟域
always @(posedge rdclk or negedge rd_rst_n)begin
    if (!rd_rst_n) begin
        wr_addr_gray_ff1 <= 'b0;
        wr_addr_gray_ff2 <= 'b0; 
    end else begin
        wr_addr_gray_ff1 <= wr_addr_gray        ;
        wr_addr_gray_ff2 <= wr_addr_gray_ff1    ;
    end
end 



//格雷码跨时钟域——rd_addr2wr_clk
//读地址同步到写时钟域
always @(posedge wrclk or negedge wr_rst_n)begin
    if (!wr_rst_n) begin
        rd_addr_gray_ff1 <= 'b0;
        rd_addr_gray_ff2 <= 'b0; 
    end else begin
        rd_addr_gray_ff1 <= rd_addr_gray        ;
        rd_addr_gray_ff2 <= rd_addr_gray_ff1    ;
    end
end 

//格雷码转自然二进制
//$clog2(DATA_DEPTH)-1:0

integer i,j;

// 同步后的写地址解格雷
always @(*)begin
    gray_addr_wr[$clog2(DATA_DEPTH)] <= wr_addr_gray_ff2[$clog2(DATA_DEPTH)];
    for(i= $clog2(DATA_DEPTH)-1; i>=0 ;i=i-1)begin
        gray_addr_wr[i]= gray_addr_wr[i+1] ^ wr_addr_gray_ff2[i];
    end
end

// 同步后的读地址解格雷
always @(*)begin
    gray_addr_rd[$clog2(DATA_DEPTH)] <= rd_addr_gray_ff2[$clog2(DATA_DEPTH)];
    for(j= $clog2(DATA_DEPTH)-1; j>=0 ;j=j-1)begin
        gray_addr_rd[j]= gray_addr_rd[j+1] ^ rd_addr_gray_ff2[j];
    end
end


//同步到写时钟域的二进制读地址 = 同步到读时钟域的二进制写地址 ，FIFO被读空
assign fifo_empty = (gray_addr_wr == rd_addr ) ? 1'b1 : 1'b0;


//二进制读地址 ,  二进制写地址 ,当最高位不同但是其他位相等时，写指针超过读指针一圈，FIFO被写满

assign fifo_full = ((wd_ptr_hi != rd_ptr_hi) && (wd_ptr_true == rd_ptr_true))? 1'b1 : 1'b0;
endmodule