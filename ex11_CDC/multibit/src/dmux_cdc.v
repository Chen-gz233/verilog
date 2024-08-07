module dmux_cdc #(
    parameter tx_clk = 100,
    parameter rx_clk = 50 ,
    parameter DATA_WIDTH = 8
)
(
    input clk_f ,
    input clk_s ,
    input rst_n  ,
    input [DATA_WIDTH-1:0] data_in ,
    input valid_in ,

    output [DATA_WIDTH-1 :0] data_out,
    output valid_out
);
    reg [DATA_WIDTH-1:0] data_in_ff1;
    reg valid_in_ff1;

    //在快时钟域打一拍
    always @(posedge clk_f or negedge rst_n)begin
        if(!rst_n)begin
            data_in_ff1 <= 'd0;
            valid_in_ff1 <= 'd0;
        end else begin
            data_in_ff1 <= data_in;
            valid_in_ff1 <= valid_in ;
        end
    end

    reg valid_in_ff2;
    reg valid_in_ff3;

    //valid信号在慢时钟域打两拍
    always @(posedge clk_s)begin
        if(!rst_n)begin
            valid_in_ff2<= 'd0;
            valid_in_ff3<= 'd0;
        end else begin
            valid_in_ff2<= valid_in_ff1 ;
            valid_in_ff3<= valid_in_ff2 ;
        end
    end

    //选择器(MUX)
    reg [DATA_WIDTH-1 : 0] data_out_ff1;
    reg valid_out_ff1;
    
    always @(posedge clk_s)begin
        if(!rst_n)begin
            data_out_ff1<= 'd0;
            valid_out_ff1 <= 'd0;
        end else if(valid_in_ff3) begin
            data_out_ff1 <= data_in_ff1;
            valid_out_ff1 <= 'd1;
        end else begin
            data_out_ff1 <= data_out_ff1;
            valid_out_ff1 <= 'd0;
        end
    end
    assign data_out = data_out_ff1;
    assign valid_out = valid_out_ff1 ;

endmodule