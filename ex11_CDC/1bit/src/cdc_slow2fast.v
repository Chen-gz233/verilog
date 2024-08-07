`timescale 1ns/1ns

//慢时钟数据跨时钟域到快时钟域
module cdc_slow2fast(
    input clk_s     ,
    input pluse_s   ,
    input clk_f     ,
    output pluse_f
);

    reg pluse_s_ff1 ;
    reg pluse_s_ff2 ; 
    //慢时钟下的数据在快时钟下打两拍
    always @(posedge clk_f)begin
        pluse_s_ff1 <= pluse_s ;
        pluse_s_ff2 <= pluse_s_ff1 ;
    end

    assign pluse_f = pluse_s_ff2 ;
endmodule