//快时钟到慢时钟域：握手协议

module shake_sync(

  input clk1,
  input clk2,
  input rst_n,
  input read,

  output read_sync_pulse

);

reg reg_in1;
reg ack_in1;
reg ack_in1_delay1;

//1、clk1时钟域下的reg_in1信号生成(展宽)

always@(posedge clk1 or negedge rst_n) begin

  if(!rst_n)
    reg_in1 <= 1'b0;
  else if(read) //遇到read信号一直拉高
    reg_in1 <= 1'b1;
  else if(ack_in1_delay1) //直到遇到ack_in1_delay1拉低
    reg_in1 <= 1'b0;
  else
    reg_in1 <= 1'b0;

end


reg reg_in2;
reg reg_in2_delay1;

//2、clk2时钟域下的reg信号采样+打1拍

always@(posedge clk2 or negedge rst_n)begin
  if(!rst_n) begin
    reg_in2 <= 1'b0;
    reg_in2_delay1 <= 1'b0;
  end else begin
    reg_in2 <= reg_in1;
    reg_in2_delay1 <= reg_in2;
  end
end

//3、clk1时钟下直接采样reg_in2_delay1，得到ack+并打1拍

always@(posedge clk1 or negedge rst_n) begin

  if(!rst_n) begin
    ack_in1 <= 1'b0;
    ack_in1_delay1 <= 1'b0;
  end else begin
    ack_in1 <= reg_in2_delay1;
    ack_in1_delay1 <= ack_in1;
  end

end

//4、dout信号产生

assign read_sync_pulse = reg_in2 & ~reg_in2_delay1;

endmodule