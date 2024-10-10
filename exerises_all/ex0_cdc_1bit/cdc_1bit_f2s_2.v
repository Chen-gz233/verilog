//脉冲信号：快到慢跨时钟域处理：脉冲展宽

module cdc_f2s_2(
    input clk_f ,
    input clk_s ,
    input rst_n ,
    input data_in_f ,
    output data_out_s
);
//展宽寄存器
reg [2:0] data_in_ff;

always @(posedge clk_f or negedge rst_n)begin
    if(~rst_n)begin
        data_in_ff <= 3'b0;
    end else begin
        data_in_ff <= {data_in_ff[2:0],data_in_f};
    end 

end


wire  data_in_flag ; //展宽后,有一个1 就变1
assign data_in_flag = | data_in_ff;

reg [1:0] data_out_ff ;
//跨时钟域
always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        data_out_ff <= 2'b0;
    end else begin
        data_out_ff <= {data_out_ff[1],data_in_flag};
    end 
end 


assign data_out_s = data_out_ff[1] ;
endmodule