`timescale 1ns/1ns
//同步fifo

module sync_fifo (
    input clk ,
    input rst_n ,
    input [7:0]data_in ,
    input wr_en ,

    input rd_en ,
    output reg [7:0]data_out ,
    output reg wr_full ,
    output reg rd_empty 
);

    reg [7:0]RAM [7:0];

    reg [3:0] wr_ptr ;
    reg [3:0] rd_ptr ;

    wire [2:0] wr_addr ;
    wire [2:0] rd_addr ;
    assign  wr_addr = wr_ptr[2:0];
    assign  rd_addr = rd_ptr[2:0];
    
    //写地址自增
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            wr_ptr <= 4'd0 ;
        end else if(!wr_full && wr_en )begin
            wr_ptr <= wr_ptr +1'd1 ;
        end else begin
            wr_ptr <= wr_ptr ;
        end
    end

    //读地址自增
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            rd_ptr <= 4'd0 ;
        end else if (!rd_empty && rd_en)begin
            rd_ptr <= rd_ptr +1'd1 ;
        end else begin
            rd_ptr <= rd_ptr ;
        end
    end
    
    //从FIFO 读数据
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            data_out  <= 8'd0;
        end else if(!rd_empty && rd_en)begin
            data_out <= RAM[rd_addr];
        end else begin
            RAM[wr_addr] <= RAM[wr_addr];
        end 
    end

    //数据写入FIFO 
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            RAM[wr_addr] <= 8'd0;
        end else if(!wr_full && wr_en)begin
            RAM[wr_addr] <= data_in;
        end else begin
            RAM[wr_addr] <= RAM[wr_addr];
        end 
    end

    //判断: 写满
    always @(*) begin
        if(!rst_n)begin
            wr_full <= 1'd0;
        end else if((wr_ptr[3] != rd_ptr[3]) && (wr_addr == rd_addr))begin
            wr_full <= 1'd1;
        end else begin
            wr_full <= 1'd0;
        end 
    end

    ////判断: 读空
    always @(*) begin
        if(!rst_n)begin
            rd_empty <= 1'd0;
        end else if(wr_ptr === rd_ptr)begin
            rd_empty <= 1'd1;
        end else begin
            rd_empty <= 1'd0;
        end 
    end

endmodule