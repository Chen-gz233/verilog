//多bit 慢到快时钟。
// 对慢时钟域过来的有效(valid)信号 使用两级D触发器打2拍
module mux_clka2b(
        input clk_a ,           //慢
        input clk_b ,           //快
        input arstn ,
        input brstn ,
        input [3:0] data_in , //clk_a
        input data_en ,       //clk_a

        output reg [3:0] dataout //clk_b
);

//clk_a到来时对data_en进行缓存

reg data_en_reg;

always@(posedge clk_a or negedge arstn) begin
    if(!arstn)
        data_en_reg <= 1'b0;
    else
        data_en_reg <= data_en;
end

//clk_a到来时对data_in进行缓存

reg [3:0] data_in_reg;

always@(posedge clk_a or negedge arstn) begin
    if(!arstn)
        data_in_reg <= 4'b0;
    else
        data_in_reg <= data_in;
end

//对data_en_reg在B时钟域缓存2个周期，使得data_en总持续时间大于3个clk_b

reg [1:0] data_en_b_t;

always@(posedge clk_b or negedge brstn) begin
    if(!brstn)
        data_en_b_t <= 2'b00;
    else
        data_en_b_t <= {data_en_b_t[0],data_en_reg};
end

//在data_en满足条件时，对输出dataout赋值

always@(posedge clk_b or negedge brstn) begin
    if(!brstn)
        dataout <= 4'b0;
    else
        dataout <= (data_en_b_t[1])?data_in_reg:dataout;
end

endmodule