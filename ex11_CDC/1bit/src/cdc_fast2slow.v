`timescale 1ns/1ns
//该模块只适合脉冲信号持续一个周期,如果信号持续两个周期就出问题啦
//ref : https://blog.csdn.net/qq_39485231/article/details/105378323
module cdc_fast2slow(
    input clk_f ,
    input clk_s ,
    input pulse_f,

    output pulse_s
);
    //在快时钟域下打两拍 
    //目的是为了将脉冲信号展宽，方便识别
    reg [2:0] pulse_f_ff;
    always @(posedge clk_f) begin
        pulse_f_ff <= {pulse_f_ff[1:0],pulse_f} ;
    end

    wire pulse_s_w ;//展宽信号：有1就拉高
    assign pulse_s_w =  | pulse_f_ff ;//按位或
    
    
    reg pulse_s_ff1;
    reg pulse_s_ff2;
    
    always @(posedge clk_s) begin
        pulse_s_ff1 <= pulse_s_w  ;
        pulse_s_ff2 <= pulse_s_ff1 ;
    end
    assign pulse_s = pulse_s_ff2;
endmodule