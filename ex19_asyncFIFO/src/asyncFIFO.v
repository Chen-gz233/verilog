`timescale 1ns/1ns


module asyncFIFO (
    input clk_a ,
    input clk_b ,
    input rst_n ,

    input wr_en ,
    input rd_en ,

    input [7:0] data_in ,
    output [7:0] data_out ,

    output wfull  ,
    output rempty 

);
    //数据宽度     数据深度 
    reg [7:0] RAM [7:0] ;

    reg [3:0] wr_ptr ; //读写指针 理论上是用3位宽表示真实地址，多一位用于判断写满
    reg [3:0] rd_ptr ;
    
    wire [2:0] wr_addr ; //3位宽真实地址
    wire [2:0] rd_addr ;
    assign wr_addr = wr_ptr[2:0] ;
    assign rd_addr = rd_ptr[2:0] ;
    reg [3:0] wr_gray ;
    reg [3:0] rd_gray ;

    reg [3:0] gray_wr ;
    reg [3:0] gray_rd ;

    reg [3:0] wr_gray_ff1 ;
    reg [3:0] rd_gray_ff1 ;
    reg [3:0] wr_gray_ff2 ;
    reg [3:0] rd_gray_ff2 ;

    reg full ;
    reg empty ;
    reg [7:0] data_out_reg ;
assign  wfull = full ;
assign  rempty = empty ;
assign data_out = data_out_reg ;

    //写时钟域下，写地址自增
    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            wr_ptr <= 4'b0;
            RAM[wr_addr] <= 8'b0;
        end else if(!full && wr_en ) begin
            RAM[wr_addr] <= data_in;
            wr_ptr <= wr_ptr +1'b1;
        end else begin
            RAM[wr_addr] <= RAM[wr_addr];
            wr_ptr <= wr_ptr ;
        end
    end

    //读时钟域下 ： 读地址自增
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            rd_ptr <= 4'b0;
            data_out_reg <= 8'd0 ; 
        end else if(!empty && rd_en ) begin
            data_out_reg <= RAM[rd_addr] ;
            rd_ptr <= rd_ptr +1'b1;
        end else begin
            data_out_reg <= data_out_reg ; 
            rd_ptr <= rd_ptr ;
        end
    end


    //写时钟域下，写地址转格雷码
    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            wr_gray <= 4'b0;
        end else begin
            //最高位不变，从次高位开始，次高位与前一位做异或
            wr_gray <= {wr_ptr[3],wr_ptr[3:1] ^ wr_ptr[2:0]} ;
        end
    end

    //读时钟域下，读地址转格雷码
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            rd_gray <= 3'b0;
        end else begin
            //最高位不变，从次高位开始，次高位与前一位做异或
            rd_gray <= {rd_ptr[3],rd_ptr[3:1] ^ rd_ptr[2:0]} ;
        end
    end

    //写地址格雷码 跨时钟域到读时钟
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            wr_gray_ff1 <= 4'b0;
            wr_gray_ff2 <= 4'b0;
        end else begin
             wr_gray_ff1 <= wr_gray    ;
            wr_gray_ff2 <= wr_gray_ff1 ;
        end
    end

    //读地址格雷码 跨时钟域到写时钟
    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            rd_gray_ff1 <= 4'b0;
            rd_gray_ff2 <= 4'b0;
        end else begin
            rd_gray_ff1 <= rd_gray    ;
            rd_gray_ff2 <= rd_gray_ff1 ;
        end
    end
    
    
    //读时钟下，写地址格雷码转写真实地址
    integer i ;
    always @(*) begin
        if(!rst_n)begin
            gray_wr <= 4'b0;
        end else begin //格雷码转真实地址 ： 格雷码最高位=真实地址最高位，真实地址次高位= 正式地址最高位与格雷码次高位做异或
            gray_wr[3] = wr_gray_ff2[3];
            for(i=2 ;i >= 0  ; i=i-1)begin
             gray_wr[i] = wr_gray_ff2[i] ^ gray_wr[i+1]   ;
            end
        end
    end

    //写时钟下，读地址格雷码转读真实地址
    integer j ;
    always @(*) begin
        if(!rst_n)begin
            gray_rd = 3'b0;
        end else begin //格雷码转真实地址 ： 格雷码最高位=真实地址最高位，真实地址次高位= 正式地址最高位与格雷码次高位做异或
            gray_rd[3] = rd_gray_ff2[3];
            for(j=2 ;j >= 0  ; j=j-1)begin
             gray_rd[j] = rd_gray_ff2[j] ^ gray_rd[j+1]   ;
            end
        end
    end


    //写满与读空判断
    //读空判断 ： 读指针 = 写指针 
    //但是这里的写指针是从写时钟域到读时钟域下的写指针
    always @(*) begin
        if(gray_wr == rd_ptr)
            empty = 1'b1 ;
        else 
            empty = 1'b0 ;
    end

    //写满操作比较复杂
    //读写地址中，标志位（最高位不同）但是地址位相同，代表写满了
    //这里的都读地址是从读时钟域下跨时钟域处理到写时钟域下的读地址
    always @(*) begin
        if((gray_rd[3] != wr_ptr[3]) && (gray_rd[2:0] == wr_ptr[2:0]))
            full = 1'b1 ;
        else 
            full = 1'b0 ;

    end


endmodule //asyncFIFO