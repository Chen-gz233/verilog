`timescale 1ns/1ns
module seller1(
	input wire clk  ,
	input wire rst  ,
	input wire d1 ,
	input wire d2 ,
	input wire d3 ,
	
	output reg out1,
	output reg [1:0]out2
);
//*************code***********//
    parameter s0 = 3'd0;
    parameter s1 = 3'd1;
    parameter s2 = 3'd2;
    parameter s3 = 3'd3;
    parameter s4 = 3'd4;
    parameter s5 = 3'd5;
    parameter s6 = 3'd6;
    
    reg [2:0] cur;
    reg [2:0] nex;


    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            cur = s0;
            out1 = 0;
            out2 = 0;
        end
        else
            cur = nex;
    end
    
    always @(*) begin
        case(cur) 
            s0: begin
                if(d1) begin
                    nex = s1;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d2)  begin
                    nex = s2;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d3) begin
                    nex = s4;
                    out1 = 0;
                    out2 = 0;
                end
                else begin
                    nex = nex;
                    out1 = 0;
                    out2 = 0;
                end
            end
            s1: begin
                if(d1) begin
                    nex = s2;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d2) begin
                    nex = s3;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d3) begin
                    nex = s5;
                    out1 = 0;
                    out2 = 0;
                end
                else begin
                    nex = nex;
                    out1 = 0;
                    out2 = 0;
                end
            end
            s2:begin 
                if(d1) begin
                    nex = s3;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d2) begin
                    nex = s4;
                    out1 = 0;
                    out2 = 0;
                end
                else if(d3) begin
                    nex = s6;
                    out1 = 0;
                    out2 = 0;
                end
                else begin
                    nex = nex;
                    out1 = 0;
                    out2 = 0;
                end
            end
            s3:begin 
                nex = s0;
                out1 = 1;
                out2 = 0;
            end
            s4:begin 
                nex = s0;
                out1 = 1;
                out2 = 1;
            end
            s5: begin 
                nex = s0;
                out1 = 1;
                out2 = 2;
            end
            s6: begin 
                nex = s0;
                out1 = 1;
                out2 = 3;
            end
            default: begin 
                nex = s0;

                end
        endcase
    end

//*************code***********//
endmodule