//三分频
//50%的占空比

module div3_or(    //三分频：或操作
    input clk,
    input rst_n,
    output clk_out3_or

);
    reg [1:0] cnt ;
    reg clk_1 , clk_2 ;
    parameter n = 3 ;
    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1))? 2'b0 : cnt + 1'd1;
        end

    end

    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_1 <= 2'b0;      //或操作 clk 初始化是0 
        end else if((cnt == (n-1)) || (cnt == (n-1)/2)) begin //与和或都是一样的条件
            clk_1 <= ~clk_1;
        end
    end
    
    always @(negedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_2 <= 2'b0;   //或操作 clk 初始化是0 
        end else if((cnt == (n-1)) || (cnt == (n-1)/2)) begin //与和或都是一样的条件
            clk_2 <= ~clk_2;
        end
    end

    assign clk_out3_or = clk_1 | clk_2;
endmodule

module div3_xor(    //三分频：异或操作
    input clk,
    input rst_n,
    output clk_out3_xor

    );
    reg [1:0] cnt ;
    reg clk_1 , clk_2 ;
    parameter n = 3 ;
    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1))? 2'b0 : cnt + 1'd1;
        end

    end

    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_1 <= 2'b0;
        end else if( cnt == (n-1)) begin    // //把与和或的条件拆开
            clk_1 <= ~clk_1;
        end
    end
    
    always @(negedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_2 <= 2'b0;
        end else if(cnt==(n-1)/2 ) begin    //把与和或的条件拆开
            clk_2 <= ~clk_2;
        end
    end

    assign clk_out3_xor = clk_1 ^ clk_2;

endmodule


module div3_and(    //三分频：与操作
    input clk,
    input rst_n,
    output clk_out3_and

    );
    parameter n = 3;
    reg [1:0] cnt ;
    reg clk_1 , clk_2 ;

    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == (n-1))? 2'b0 : cnt + 1'd1;
        end

    end

    always @(posedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_1 <= 2'b1;  //与clk 初始化为1
        end else if( (cnt == (n-1)) || (cnt == (n-1)/2)) begin  //与和或都是一样的条件
            clk_1 <= ~clk_1;
        end
    end
    
    always @(negedge clk or negedge rst_n ) begin
        if(~rst_n)begin
            clk_2 <= 2'b1;
        end else if((cnt == (n-1)) || (cnt == (n-1)/2))  begin //与和或都是一样的条件
            clk_2 <= ~clk_2;
        end
    end

    assign clk_out3_and = clk_1 && clk_2;

endmodule