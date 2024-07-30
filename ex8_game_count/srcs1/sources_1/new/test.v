`timescale 1ns/1ns

module game_count
    (
		input rst_n, //异位复位信号，低电平有效
        input clk, 	//时钟信号
        input [9:0]money,
        input set,
		input boost,
        
		output reg[9:0]remain,
		output reg yellow,
		output reg red
    );
    
    always @(posedge clk or negedge rst_n)begin
          if(~rst_n)begin
            remain <= 9'b0;
          end
          else begin
            if(set == 1)begin
                remain <= money+remain;
            end
            else begin
                if(remain == 0)
                    remain <= 0;
                else if(boost == 0 )
                    remain <= remain - 1;
                else if(boost == 1 )
                    remain <= remain -2;
            end
         end
    end


    always @(posedge clk or negedge rst_n)begin
         if(~rst_n)begin
            yellow <= 0;
            red <= 1;
        end
        else begin 
            
            if(remain > 1 && remain <=10  )begin 
                 yellow <= 1;
                 red <=0;
            end
            else if(remain <= 1 && boost == 1)begin 
                red <=1;
                yellow <= 0;
             end
            else if(remain == 0 && boost == 0)begin 
                 yellow <= 0;
                 red <=1;
            end
            else begin
                yellow <= 0;
                red <= 0;
            end
            
        end
    end
    
            
    
    
    
endmodule