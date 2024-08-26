`timescale 1ns/1ns

module sel2pal( //fast to slow 
    input clka    ,//fast
    input wra_n   ,
    input rst_n   ,
    input din     ,

    input clkb    ,//slow
    output wrb     ,
    output [7:0] db_out
);

    reg [7:0] din_pal ;  //串行 转 并行
    reg [7:0] db_buf  ;

    reg [2:0] wra_b ;
    reg wrb_reg ;

//串行数据转并行数据
always @(posedge clka or negedge rst_n) begin
    if(!rst_n)begin
        din_pal <= 8'd0 ;
    end else if (!wra_n) begin
        din_pal <= {din_pal[6:0],din};
    end else begin
        din_pal <= din_pal ;
    end 
end 

//使能信号 跨时钟域处理
always @(posedge clkb or negedge rst_n) begin
    if(!rst_n)begin
        wra_b <= 3'b0 ;
    end else begin
        wra_b <= {wra_b[1:0],wra_n} ;
    end 
end

// 使n能信号 使 寄存器数据交换
always @(posedge clkb or negedge rst_n) begin
    if(!rst_n)begin
        db_buf <= 8'd0 ;
        wrb_reg <= 1'b0 ;
    end else if (!wra_b[2] & wra_b[1])begin
        db_buf <= din_pal;
        wrb_reg <= 1'b1 ;
    end else begin
        db_buf <= 8'd0 ;
        wrb_reg <= 1'b0 ;
    end 
end
    

    assign  wrb   =   wrb_reg ;
    assign db_out =   db_buf  ;
endmodule