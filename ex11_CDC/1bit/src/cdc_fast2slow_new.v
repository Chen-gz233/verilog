`timescale 1ns/1ns

module cdc_fast2slow_new(
    input clk_f ,
    input clk_s ,
    input pulse_f,

    output pulse_s
);
    //标志寄存器： 检测快时钟域中的脉冲信号

    reg  pulse_f_flag = 0;  //核心思想就是：脉冲转电平

    always @(posedge clk_f) begin
        if(pulse_f)begin    //遇到一次脉冲信号就反转一次
            pulse_f_flag <= ~pulse_f_flag ;
        end else begin
            pulse_f_flag <= pulse_f_flag  ;
        end 
    end
    
    reg pulse_f_ff1;
    reg pulse_f_ff2;
    reg pulse_s_ff3;    //这里的第三拍为了异或操作
    //对标志寄存器做跨时钟域处理
    always @(posedge clk_s) begin
        pulse_f_ff1 <= pulse_f_flag  ;
        pulse_f_ff2 <= pulse_f_ff1 ;
        pulse_s_ff3 <= pulse_f_ff2 ;
    end

    assign pulse_s = pulse_s_ff3 ^ pulse_f_ff2;
endmodule