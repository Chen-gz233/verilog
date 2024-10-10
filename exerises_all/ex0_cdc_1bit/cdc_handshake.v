
//脉冲信号跨时钟域：握手协议（快到慢）


module handshake(
    input clk_f ,
    input clk_s ,
    input rst_n ,
    input data_in_f ,

    output data_out_s
);

reg req ;
reg resp ;

reg [2:0]req_ff ;
reg [1:0]resp_ff ;
//快时钟域对脉冲信号进行检测，检测为高电平时输出高电平信号 req。
//req 拉升逻辑 ： 有信号就拉升，resp到后拉低
always @(poedge clk_f or negedge rst_n) begin
    if(!rst_n)begin
        req <= 1'b0;
    end esle if(data_in_f)begin
        req <= 1'b1;
    end esle if(resp_ff[1])begin
        req <= 1'b0;
    end else begin
        req <= req ;
    end 
end 

//req f2s 跨时钟处理
//慢时钟域对快时钟域的信号 req 进行延迟打拍采样。
//因为此时的脉冲信号被快时钟域保持拉高状态，延迟打拍肯定会采集到该信号。
always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        req_ff <= 3'b0;
    end else begin
        req_ff <={req_ff[2:0],req};
    end 
end 
assign data_out_s = ~req_ff[2] & req_ff[1] ;

//慢时钟域确认采样得到高电平信号 req_r1 后，拉高反馈信号 ack 再反馈给快时钟域。
always @(poedge clk_f or negedge rst_n)begin
    if(!rst_n)begin
        resp_ff <= 2'b0;
    end else begin
        resp_ff <= {resp_ff[1],req_ff[1]};
    end 
end 

endmodule