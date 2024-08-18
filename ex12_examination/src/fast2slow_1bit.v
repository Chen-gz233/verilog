/*
快到慢 
方法1：展宽+打拍同步
*/
`timescale  1ns/1ns

module fast2slow_1bit 
(
    input clk_f,
    input rst_n,
    input data_in,

    input clk_s,
    output data_out     
);

    reg data_in_ff1;
    reg data_in_ff2;
    reg data_in_ff3;
    reg data_in_or;

    always @(posedge clk_f or negedge rst_n) begin
        if(!rst_n)begin
            data_in_ff1 <= 1'b0;
            data_in_ff2 <= 1'b0;
            data_in_ff3 <= 1'b0;
        end else begin
            data_in_ff1 <= data_in;
            data_in_ff2 <= data_in_ff1;
            data_in_ff3 <= data_in_ff2;
        end
    end

    always @(posedge clk_f or negedge rst_n) begin
        if(!rst_n)begin
            data_in_or <= 1'b0;
        end else begin
            data_in_or <= data_in_ff1 | data_in_ff2 | data_in_ff3 ; 
        end
    end 

    reg data_out_ff1;
    reg data_out_ff2;
    reg data_out_ff3;

    always @(posedge clk_s or rst_n) begin
        if(!rst_n) begin
            data_out_ff1 <= 1'b0;
            data_out_ff2 <= 1'b0;
            data_out_ff3 <= 1'b0;
        end else begin
            data_out_ff1 <= data_in_or;
            data_out_ff2 <= data_out_ff1;
            data_out_ff3 <= data_out_ff2;
        end
    end
    assign  data_out = data_in_ff2 & ~data_in_ff3;
endmodule //fast2slow_1bit