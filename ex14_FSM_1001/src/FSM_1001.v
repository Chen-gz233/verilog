`timescale 1ns/1ns
        //时间单位/时间精度

module FSM_1001(
    input  clk  ,
    input  rst_n ,
    input  data_in ,

    output data_out 

);

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
parameter S4 = 3'd4;
    
reg [2:0] current_state ;
reg [2:0] next_state ;
reg detect;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        current_state <= S0;
    end else begin
    current_state <= next_state ;
    end 
    
end

always @(*) begin
    case(current_state)//1001
        S0 : next_state = data_in ? S1 : S0;
        S1 : next_state = data_in ? S1 : S2;
        S2 : next_state = data_in ? S1 : S3;
        S3 : next_state = data_in ? S4 : S0;
        S4 : next_state = data_in ? S1 : S0;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        detect <= 1'b0;
    end else if (next_state == S4) begin
        detect <= 1'b1;
    end else begin
        detect <= 1'b0;
    end 

end
assign data_out = detect;
endmodule