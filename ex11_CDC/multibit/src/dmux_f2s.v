//快到慢时钟域:DMUX

//对有效信号而言，将两级D触发器换成脉冲同步，
//将脉冲信号展宽，再进行边沿检测

module mux_clkb2a(
    input clk_a ,           //慢
    input clk_b ,           //快
    input arstn ,
    input brstn ,
    input [3:0] data_in ,
    input data_en ,

    output reg [3:0] dataout
);

//快时钟域，寄存

reg data_en_reg;

always@(posedge clk_b or negedge brstn) begin
    if(!brstn)
        data_en_reg <= 1'b0;
    else
        data_en_reg <= data_en;
end


reg [3:0] data_in_reg;

always@(posedge clk_b or negedge brstn) begin
    if(!brstn)
        data_in_reg <= 4'b0;
    else
        data_in_reg <= data_in;
end

//单bit 慢时钟域 ->  快时钟域，脉冲转电平+ 翻转
reg flag ;

always@(posedge clk_b or negedge brstn) begin
    if(data_en_reg)
        flag <= ~flag;
    else
        flag <= flag;
end


reg [2:0] data_en_b_t;

always@(posedge clk_a or negedge arstn) begin
    if(!arstn)
        data_en_b_t <= 3'b000;
    else
        data_en_b_t <= {data_en_b_t[1:0],flag};
end

//展宽后的信号进行：边沿检测

wire data_en_b;

assign data_en_b = data_en_b_t[1] ^ data_en_b_t[2];


always@(posedge clk_a or negedge arstn) begin
    if(!arstn)
        dataout <= 'd0;
    else
        dataout <= (data_en_b)?data_in_reg:dataout;
    end

endmodule