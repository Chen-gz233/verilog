//需要同步的脉冲信号只能在原时钟域持续一个周期。
//clk_f是快时钟，clk_s是慢时钟，程序中是让快时钟的脉冲同步的慢时钟，
//先是在clk_f下把脉冲展成电平信号，但就是这里出了问题，
//一旦脉冲在clk_f下持续时间是两个clk_f周期，那么就不能展成电平信号，从而导致clk_s下可能采样不到信号

//脉冲信号跨时钟域-边缘检测法（快到慢 ；慢到快都适用）
module fsm(
    input clk_f,
    input rst_n ,
    input clk_s ,
    input data_in_f ,

    output data_out_s
);

reg data_flag ;     //标志寄存器

always @(posedge clk_f or negedge rst_n)begin
    if(!rst_n)begin
        data_flag <= 1'b0;
    end else if (data_in_f) begin   //来信号就反转
        data_flag <= ~data_flag;
    end else begin
        data_flag<= data_flag ;
    end 
end 

reg [2:0]data_in_ff;

always @(posedge clk_s or negedge rst_n)begin
    if(~rst_n)begin
        data_in_ff <= 3'b0;
    end else  begin
        data_in_ff <= {data_in_ff[2:1],data_flag};
    end
end 

assign data_out_s = data_in_ff[2] ^ data_in_ff[1]; //保证输出也是一个时钟周期


endmodule