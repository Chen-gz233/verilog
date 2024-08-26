`timescale 1ns/1ns

module seq_check(
    input  clk ,
    input  rst_n ,
    input data_in ,

    output flag   
);

    parameter s0 = 3'd0;
    parameter s1 = 3'd1;
    parameter s2 = 3'd2;
    parameter s3 = 3'd3;
    parameter s4 = 3'd4;
    parameter s5 = 3'd5;
    parameter s6 = 3'd6;

    reg [2:0] current_stage ;
    reg [2:0] next_stage    ;
    reg flag_reg ;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            current_stage <= s0 ;
 		next_stage <= s0 ;
        end else begin
            current_stage <= next_stage ; 
        end
        
    end


    always @( * ) begin
        case(current_stage)
            s0 : next_stage = data_in ? s1 : s0 ;
            s1 : next_stage = data_in ? s1 : s2 ;
            s2 : next_stage = data_in ? s3 : s0 ;
            s3 : next_stage = data_in ? s1 : s4 ;
            s4 : next_stage = data_in ? s3 : s5 ;
            s5 : next_stage = data_in ? s6 : s0 ;
            s6 : next_stage = data_in ? s1 : s2 ;
            default : next_stage = s0 ;
                
        endcase
    end

     always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            flag_reg <= 1'b0;
        end else if(next_stage == s6) begin
            flag_reg <= 1'b1;
        end else begin
            flag_reg <= 1'b0;
        end 
     end

assign  flag = flag_reg;


endmodule