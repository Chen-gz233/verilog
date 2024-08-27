`timescale 1ns/1ns

module fixed_pro_arb (
    input  clk ,
    input  rst_n ,
    input [2:0] req ,

    output [2:0] resp 
);
parameter s0 = 2'd0 ;
parameter s1 = 2'd1 ;
parameter s2 = 2'd2 ;
parameter s3 = 2'd3 ;

reg [1:0] current_stage;
reg [1:0] next_stage ;
reg [2:0] rssp_reg ;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        current_stage<= s0 ;
        next_stage <= s0 ;
    end esle begin
        current_stage <= next_stage ; 
    end 
end

always (*) begin
    case(current_stage) //优先级顺序  从低位到高位，优先级递减 ： 也就是0>1>2 
    s0 : next_stage =  reg[0] ? s1 : (reg[1] ? s2 : (reg[2] ? s3 : s0));
    s1 : next_stage =  reg[0] ? s1 : s0 ;
    s2 : next_stage =  reg[1] ? s2 : s0 ;
    s3 : next_stage =  reg[2] ? s3 : s0 ;
    endcase
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        rssp_reg <= 3'd000;
    end else if (next_stage == s0 )begin
        rssp_reg <= 3'd000;
    end else if (next_stage == s1 )begin
        rssp_reg <= 3'd001;
    end else if (next_stage == s2 )begin
        rssp_reg <= 3'd010;
    end else if (next_stage == s3 )begin
        rssp_reg <= 3'd100;
    end else begin
        rssp_reg <= 3'd000;
    end
end
assign  resp = rssp_reg;


endmodule //fixed_pro_arb