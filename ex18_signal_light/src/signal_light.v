`timescale 1ns/1ns

module signal_light (
    input  clk     ,
    input  rst_n   ,  

    output [2:0] light1 , 
    output [2:0] light2 ,
    output [5:0] count 
);

parameter IDLE = 3'd0 ;
parameter s1   = 3'd1 ;
parameter s2   = 3'd2 ;
parameter s3   = 3'd3 ;
parameter s4   = 3'd4 ;

reg [2:0] current_stage ;
reg [2:0] next_stage ;

reg [5:0] count_reg ;
assign  count = count_reg;
//计数器
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count_reg <= 6'd0 ;
    end else if (count_reg == 6'd59) begin
        count_reg <= 6'd0 ;
    end else begin
        count_reg <= count_reg + 1'd1;
    end 
    
end

//状态机
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_stage <= s0 ;
        next_stage <= s0 ;
    end else begin
        current_stage <= next_stage ;
    end 
    
end

always @(posedge clk or negedge rst_n) begin
    case (current_stage)
            IDLE : if(!rst_n             ) begin next_stage = s1 ; light1 = 3'b010 ; light2 = 3'b010 ; end
            s1   : if(count_reg == 6'd25 ) begin next_stage = s2 ; light1 = 3'd100 ; light2 = 3'd001 ; end
            s2   : if(count_reg == 6'd30 ) begin next_stage = s3 ; light1 = 3'd100 ; light2 = 3'd010 ; end
            s3   : if(count_reg == 6'd55 ) begin next_stage = s4 ; light1 = 3'd001 ; light2 = 3'd100 ; end
            s4   : if(count_reg == 6'd0  ) begin next_stage = s1 ; light1 = 3'd010 ; light2 = 3'd100 ; end
    endcase

end



endmodule //signal_light