module check_11011(
	input clk ,
	input rst_n ,
	input data ,
	
	output check
	);
	
	//11-0-11
	parameter S0 = 3'd0 ;
	parameter S1 = 3'd1 ;
	parameter S2 = 3'd2 ;
	parameter S3 = 3'd3 ;
	parameter S4 = 3'd4 ;
	parameter S5 = 3'd5 ;
	
	reg [2:0] current_stage ;
	reg [2:0] next_stage ;
	
	reg flag ;
	
	assign check = flag ;
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			current_stage <= S0;
		end else begin
			current_stage <= next_stage ;
		end 
	end 
	
	always @(*)begin
		case(current_stage)
			S0 : next_stage = data == 1 ? S1 : S0 ;
			S1 : next_stage = data == 1 ? S2 : S0 ;
			S2 : next_stage = data == 1 ? S1 : S3 ;
			S3 : next_stage = data == 1 ? S4 : S0 ;
			S4 : next_stage = data == 1 ? S5 : S0 ;
			S5 : next_stage = data == 1 ? S2 : S3 ;
			default : next_stage = next_stage ;
		endcase
	end 
	
	always @(posedge clk or negedge rst_n)begin
		if(~rst_n)begin
			flag <= 1'b0 ;
		end else if(next_stage == S5)begin
			flag <= 1'b1 ;
		end else begin
			flag <= 1'b0;
		end 
	end 

endmodule