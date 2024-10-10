module asyncFIFO(
    input clk_f,
    input rst_n,
    input [7:0] data_in,

    input clk_s,
    output reg [7:0] data_out
);

reg [7:0] RAM [7:0];

reg     [3:0] w_ptr ;
reg     [3:0] r_ptr ;
wire    [2:0] w_addr ;
wire    [2:0] r_addr ;
assign w_addr = w_ptr[2:0];
assign r_addr = r_ptr[2:0];

reg full ;
reg empty ;

reg     [3:0] wptr_2gray ;
reg     [3:0] rptr_2gray ;

reg     [3:0] gray_2wptr ;
reg     [3:0] gray_2rptr ;


always @(posedge clk_f or negedge rst_n)begin
    if(!rst_n)begin
        w_ptr <= 4'b0;
    end else if(!full)begin
        RAM[w_addr] <= data_in ;
        w_ptr <= w_ptr +1'b1;
    end else begin
        RAM[w_addr] <= RAM[w_addr] ;
        w_ptr <= w_ptr ;
    end 
end 

always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        r_ptr <= 4'b0;
    end else if(!empty) begin
        data_out <= RAM[r_addr];
        r_ptr <= r_ptr +1'b1 ;
    end else begin
        data_out <= data_out;
        r_ptr <= r_ptr ;
    end 

end 

always @(posedge clk_f or negedge rst_n)begin
    if(!rst_n)begin
        wptr_2gray <= 4'b0;
    end else begin
        wptr_2gray <= w_ptr ^ (w_ptr>>1);
    end 

end 

always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        rptr_2gray <= 4'b0;
    end else begin
        rptr_2gray <= r_ptr ^(r_ptr>>1);
    end
end 

reg [3:0]wptr_2gray_ff1;
reg [3:0]wptr_2gray_ff2;

always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        wptr_2gray_ff1<= 4'b0;
        wptr_2gray_ff2<= 4'b0;
    end else begin
        wptr_2gray_ff1<= wptr_2gray;
        wptr_2gray_ff2<= wptr_2gray_ff1;
    end 
end 


reg [3:0]rptr_2gray_ff1;
reg [3:0]rptr_2gray_ff2;

always @(posedge clk_s or negedge rst_n)begin
    if(!rst_n)begin
        rptr_2gray_ff1<= 4'b0;
        rptr_2gray_ff2<= 4'b0;
    end else begin
        rptr_2gray_ff1<= rptr_2gray;
        rptr_2gray_ff2<= rptr_2gray_ff1;
    end 
end 

integer i;

always @(*)begin
    if(!rst_n)begin
        gray_2wptr <= 4'b0;
    end else begin
        gray_2wptr[3] <= wptr_2gray_ff2[3];
        for(i=2;i>=0;i=i-1)begin
             gray_2wptr[i] <= wptr_2gray_ff2[i] ^ gray_2wptr[i+1];
        end
    end 
end

integer j;

always @(*)begin
    if(!rst_n)begin
        gray_2rptr <= 4'b0;
    end else begin
        gray_2rptr[3] <= rptr_2gray_ff2[3];
        for(j=2;j>=0;j=j-1)begin
             gray_2rptr[j] <= rptr_2gray_ff2[j] ^ gray_2rptr[j+1];
        end
    end 
end 

always @(*)begin
    if(gray_2rptr == r_ptr)begin
        empty = 1'b1;
    end else begin
        empty = 1'b0;
    end 
end 

always @(*)begin
    if((gray_2wptr[3] != w_ptr[3]) &&(gray_2wptr[2:0] == w_ptr[2:0]))begin
        full = 1'b1;
    end else begin
        full = 1'b0;
    end 
end 



endmodule