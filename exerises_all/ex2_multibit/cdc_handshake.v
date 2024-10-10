
//多bit 信号跨时钟域握手
module handshake_tx (
    input clk_tx ,
    input rst_n ,
    input data_resp ,
    input [3:0]data_in ,
    input data_en ,

    output [3:0] data_tx,
    output data_req  
    );

    reg [1:0] resp_ff ;

    wire resp_post ;
    assign resp_post =~resp_ff[1] & resp_ff[0] ;

    //跨时钟域
    always @(posedge clk_tx or negedge rst_n) begin
        if(!rst_n)begin
            resp_ff <= 2'b0;
        end else begin
            resp_ff <= {resp_ff[0],data_resp};
        end 
    end  

    //发送请求机制
    always @(posedge clk_tx or negedge rst_n) begin
        if(!rst_n)begin
            data_req <= 1'b0;
        end else if  (data_en && ~data_req)begin
            data_req <= 1'b1;
        end else if (resp_post)begin
            data_req <= 1'b0;
        end else begin
            data_req <= data_req;
        end 
    end 

    //数据接受
    always @(posedge clk_tx or posedge rst_n)begin
        if(!rst_n)begin
            data_tx <= 4'b0 ;
        end else if (data_en)begin 
            data_tx <= data_in ;
        end else begin
            data_tx <= data_tx ;
        end 
    end 

endmodule


module handshake_rx(
    input clk_rx ,
    input rst_n ,
    input [3:0] data_tx ,
    input data_req ,

    output [3:0] data_out ,
    output  data_resp
    );

    reg [3:0] data_reg ;
    assign data_out = data_reg ;

    reg [2:0] data_req_ff ;

    wire data_req_post ;
    assign data_req_post = ~data_req_ff[2] & data_req_ff[1];


    always @(posedge clk_rx or negedge rst_n)begin
        if(!rst_n)begin
            data_req_ff <= 3'b0;
        end else begin
            data_req_ff <= {data_req_ff[1:0],data_req};
        end 
    end 

    always @(posedge clk_rx or negedge rst_n)begin
        if(!rst_n)begin
            data_resp<= 1'b0 ;
        end else if(data_req_ff[2]) begin
            data_resp<= 1'b1 ;
        end else begin
            data_resp<= 1'b0 ;
        end 
    end 

    always @(posedge clk_rx or negedge rst_n)begin
        if(!rst_n)begin
            data_reg <= 4'b0 ;
        end else if(data_req_post) begin
            data_reg<= data_tx ;
        end else begin
            data_reg<= data_reg ;
        end 
    end 

    
endmodule



module handshake_TOP(
    input clk_tx ,
    input clk_rx ,
    input rst_n ,
    input data_en ,
    input [3:0] data_in ,
    output [3:0] data_out 
    );
    wire req  ;
    wire resp ;
    wire [3:0] data;

    handshake_tx TX(
        .clk_tx(clk_tx) ,
        .rst_n(rst_n) ,
        .data_resp(resp) ,
        .data_in(data_in) ,
        .data_en(data_en) ,

        .data_tx(data),
        .data_req(req)  
    );


    handshake_rx RX(
        .clk_rx(clk_rx) ,
        .rst_n(rst_n) ,
        .data_tx(data) ,
        .data_req(req) ,

        .data_out(data_out) ,
        . data_resp(resp)
    );


endmodule