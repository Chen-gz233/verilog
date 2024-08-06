`timescale  1ns/1ns

//格雷码+同步的方法只适合两种情况
// 1. 多bit的跨时钟域数值（地址or数据）必须依次变化（增大 or 减小） 
// 2. 必须是慢时钟域数据到快时钟域数据


module gray_cdc(
    input clk_s,
    input clk_f,
    input [3:0] data_in,
    
    output [3:0] data_out 
);

    //二进制2格雷码
    wire [3:0] gray_data;
    assign  gray_data = (data_in>>1) ^ data_in ;

    //跨时钟域处理
    reg [3:0] gray_data_ff1;
    reg [3:0] gray_data_ff2;

    //格雷码2二进制
    reg [3:0] out_data;

    //跨时钟域处理
    always @(posedge clk_f ) begin
        gray_data_ff1 <= gray_data ;
        gray_data_ff2 <= gray_data_ff1 ;
        
    end
    //格雷码2二进制
    integer i;
    always @(*) begin
        out_data[3] <= gray_data_ff2[3];
        for(i=2;i>=0;i=i-1) begin
         out_data[i] = (gray_data_ff2[i] ^ out_data[i+1]);
        end
    end
    assign data_out =out_data; 


endmodule