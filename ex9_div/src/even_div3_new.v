//三分频


//1/3占空比 

module div3_1_3(
    input clk ,
    input rst_n ,
    
    output clk_out_1_3  
 );
    parameter n= 3;
    reg [1:0] cnt ;
    reg clk_0 ;
    reg clk_1 ;

    //cnt 累加
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1)) ? 2'b0 : cnt + 1'b1 ;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_0 <= 1'b0 ;
        end else if (cnt == 1'b0)begin
            clk_0 <= ~clk_0 ;
        end else begin
            clk_0 <= clk_0 ;
        end 
    end

    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_1 <= 1'b0 ;
        end else if (cnt == 1'b1)begin
            clk_1 <= ~clk_1 ;
        end else begin
            clk_1 <= clk_1 ;
        end 
    end

    assign  clk_out_1_3 = clk_0 ^ clk_1 ;
endmodule



//2/3占空比 

module div3_2_3(
    input clk ,
    input rst_n ,
    
    output clk_out_2_3  
 );
    parameter n= 3;
    reg [1:0] cnt ;
    reg clk_0 ;
    reg clk_2 ;

    //cnt 累加
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1)) ? 2'b0 : cnt + 1'b1 ;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_0 <= 1'b0 ;
        end else if (cnt == 1'b0)begin
            clk_0 <= ~clk_0 ;
        end else begin
            clk_0 <= clk_0 ;
        end 
    end

    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_2 <= 1'b0 ;
        end else if (cnt == 2'd2)begin
            clk_2 <= ~clk_2 ;
        end else begin
            clk_2 <= clk_2 ;
        end 
    end

    assign  clk_out_2_3 = clk_0 ^ clk_2 ;
endmodule


//1/2占空比 

module div3_1_2(
    input clk ,
    input rst_n ,
    
    output clk_out_1_2  
    );
    parameter n= 3;
    reg [1:0] cnt ;
    reg clk_0 ;
    reg clk_3 ;

    //cnt 累加
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1)) ? 2'b0 : cnt + 1'b1 ;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_0 <= 1'b0 ;
        end else if (cnt == 1'b0)begin
            clk_0 <= ~clk_0 ;
        end else begin
            clk_0 <= clk_0 ;
        end 
    end

    always @(negedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_3 <= 1'b0 ;
        end else if (cnt == 2'd2)begin
            clk_3 <= ~clk_3 ;
        end else begin
            clk_3 <= clk_3 ;
        end 
    end

    assign  clk_out_1_2 = clk_0 ^ clk_3 ;
endmodule