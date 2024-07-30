//三分频
//利用时钟的下降沿

module div3_old(
    input clk,
    input rst_n,
    output clk_out3

);
    reg [1:0] cnt ;
    reg clk_1 , clk_2 ;

    always @(posedge clk or negedge rst_n ) begin
        if(rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == 2'd2)? 2'b0 : cnt + 1'd1;
        end

    end

    always @(posedge clk or negedge rst_n ) begin
        if(rst_n)begin
            clk_1 <= 2'b0;
        end else if(cnt==2'd1 || cnt == 2'd2) begin
            clk_1 <= ~clk_1;
        end
    end
    
    always @(negedge clk or negedge rst_n ) begin
        if(rst_n)begin
            clk_2 <= 2'b0;
        end else if(cnt==2'd1 || cnt == 2'd2) begin
            clk_2 <= ~clk_2;
        end
    end

    assign clk_out3 = clk_1 | clk_2;
endmodule

module div3_new(
    input clk,
    input rst_n,
    output clk_out3

);
    reg [1:0] cnt ;
    reg clk_1 , clk_2 ;

    always @(posedge clk or negedge rst_n ) begin
        if(rst_n)begin
            cnt <= 2'b0;
        end else begin
            cnt <= (cnt == 2'd2)? 2'b0 : cnt + 1'd1;
        end

    end

    always @(posedge clk or negedge rst_n ) begin
        if(rst_n)begin
            clk_1 <= 2'b0;
        end else if( cnt == 2'd2) begin
            clk_1 <= ~clk_1;
        end
    end
    
    always @(negedge clk or negedge rst_n ) begin
        if(rst_n)begin
            clk_2 <= 2'b0;
        end else if(cnt==2'd1 ) begin
            clk_2 <= ~clk_2;
        end
    end

    assign clk_out3 = clk_1 ^ ~clk_2;

endmodule