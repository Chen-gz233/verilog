/*
方法2 ： 握手协议(handshahe)
打两节拍的同步器是对信号有一定要求
只有数据data_in在快时钟域下很长一段时间内保持0/1，才能确保被慢时钟域采样到，这种情况下才能使用打两拍

如果快时钟域下数据data_in只有一个脉冲宽度，慢时钟就有几率采样不到data_in
这种情况下就需要使用握手协议


一般用在AB两个时钟关系不确定的时候，可能是快到慢，也可能是慢到快；

基本原理：双方电路在声明或终止各自的握手信号信号前都要等待对方的相应。完整的同步过程（A→B）可有以下4个步骤：

请求信号的产生：当同步器处于空闲状态时，在输入脉冲到来时，A声明它的请求信号sync_reg;
请求信号的跨越与应答信号的产生：sync_reg信号需要跨时钟域同步到B，与此同时，B产生同步脉冲，并产生应答信号sync_ack，此时，已经给出了要输出的脉冲
应答信号的跨越与请求信号的清除：sync_ack信号跨时钟域同步到A，与此同时，A清除之前产生的sync_reg；
应答信号的清除：在sync_reg信号清除之后，B清除sync_ack信号。此时，一次信号的跨时钟域完成，等待同步下一个脉冲。

缺点:延时大
*/


`timescale 1ns/1ns

module fast2slow_1bit_handshake(
    input clk_f,
    input rst_n,
    input data_in,

    input clk_s,
    input data_out
);

    reg req_in1;

    reg ack_in1;
    reg ack_in1_ff1;



    //快时钟域下产生请求信号
    always @(posedge clk_f or negedge rst_n) begin
        if(!rst_n) begin
            req_in1 <= 1'b0;
        end else if(data_in) begin
            req_in1 <= 1'b1;
        end else if(ack_in1_ff1) begin  //收到响应就可以把请求拉低
            req_in1 <= 1'b0;
        end else begin
            //req_in1 <= 1'b0;
		req_in1 <= req_in1;         //关键！！
        end
    end 

    reg req_in2; 
    reg req_in2_ff1; 
    reg req_in2_ff2; 

    //req跨时钟域同步 
    always @(posedge clk_s or negedge rst_n) begin
         if(!rst_n) begin
            req_in2 <= 1'b0;
            req_in2_ff1 <= 1'b0;
            req_in2_ff2 <= 1'b0;
         end else begin
            req_in2 <= req_in1;
            req_in2_ff1 <= req_in2;
            req_in2_ff2 <= req_in2_ff1;
         end
    end


    //响应信号跨时钟同步到快时钟
    always @(posedge clk_f or negedge rst_n) begin
        if(!rst_n) begin
            ack_in1 <= 1'b0;
            ack_in1_ff1 <= 1'b0;
        end else begin
            ack_in1 <= req_in2_ff1;
            ack_in1_ff1 <= ack_in1;
        end 
    end
 
    assign data_out = req_in2_ff1 & ~req_in2_ff2; //输出关键！！


endmodule