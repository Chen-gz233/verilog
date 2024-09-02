`timescale 1ns/1ns
//dmux表示数据分配器，该方法适合带数据有效标志信号的多bit数据做跨时钟域传输。
module dmux (
    input clk_a ,
    input rst_n ,
    input clk_b ,
    input [7:0] data_in ,
    input data_in_valid ,

    output [7:0] data_out ,
    output data_out_valid
);

    reg data_in_valid_reg ;//输入输出控制信号reg
    reg data_out_valid_reg ;
    assign data_out_valid = data_out_valid_reg ;


    reg data_in_valid_reg_ff1;//慢时钟域到快时钟域打两拍
    reg data_in_valid_reg_ff2;

    reg [7:0] data_in_reg ;//慢时钟域下数据
    reg [7:0] data_out_reg ;//快时钟域下数据
    assign data_out = data_out_reg ;
    
    //慢时钟域下接受数据
    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            data_in_reg <= 8'b0 ;
        end else begin
            data_in_reg <= data_in ;
        end
    end

    //慢时钟下对valid数据做处理
    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            data_in_valid_reg <= 1'b0 ;
        end else begin
            data_in_valid_reg <= data_in_valid ;
        end
    end
    //慢时钟域下的控制下信号同步到快时钟域下
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            data_in_valid_reg_ff1 <= 1'b0 ;
            data_in_valid_reg_ff2 <= 1'b0 ;
        end else begin
            data_in_valid_reg_ff1 <= data_in_valid_reg ;
            data_in_valid_reg_ff2 <= data_in_valid_reg_ff1 ;
        end
    end

    //快时钟域下输出控制信号
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            data_out_valid_reg <= 1'b0 ;
        end else begin
            data_out_valid_reg <= data_in_valid_reg_ff2 ;
            
        end
    end

    //快时钟域下输出数据
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            data_out_reg <= 8'b0 ;
        end else if(data_in_valid_reg_ff2) begin
            data_out_reg <= data_in_reg ;
        end else begin
            data_out_reg <= data_out_reg ;
        end 
    end





endmodule //dmux