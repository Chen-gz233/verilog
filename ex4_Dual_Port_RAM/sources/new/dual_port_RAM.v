`timescale 1ns/1ns
/**********************************RAM************************************/
module dual_port_RAM #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  //深度对2取对数，得到地址的位宽。
	,input [WIDTH-1:0] wdata      	//数据写入
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  //深度对2取对数，得到地址的位宽。
	,output reg [WIDTH-1:0] rdata 		//数据输出
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc) begin
		RAM_MEM[waddr] <= wdata;
	end	
end 

always @(posedge rclk) begin
	if(renc) begin
		rdata <= RAM_MEM[raddr];
	end
end 

endmodule  

/**********************************SFIFO************************************/
module sfifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output reg				wfull	,
	output reg				rempty	,
	output wire [WIDTH-1:0]	rdata
);
    
    reg [$clog2(DEPTH)-1:0] waddr, raddr;
    reg [$clog2(DEPTH)  :0] cnt;
    
       always@(posedge clk or negedge rst_n) begin
           if(~rst_n) begin
                waddr <= 0;
                raddr <= 0;
           end
            else begin 
                if(winc & ~wfull) 
                    waddr <= waddr+1;
                else 
                    waddr <=  waddr;

                if(rinc & ~rempty) 
                   raddr <= raddr+1;
                else 
                    raddr <=  raddr;
            end
       end
    

     //计数
   always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            cnt <= 0;
        else begin
        // 既读又写
            if(winc&~wfull & cnt < DEPTH-1 & rinc&~rempty & cnt > 0 )
                cnt <= cnt;
                //只写不读
            else if(winc&~wfull & cnt < DEPTH-1)
                cnt <= cnt + 1;
                //只读不写
            else if(rinc&~rempty & cnt > 0)
                cnt <= cnt - 1;
             else
             cnt <= cnt;
         end
    end
  //判断读空和写满   
 always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wfull  <= 1'd0;
            rempty <= 1'd1;
        end
        else begin
        /* if(cnt == DEPTH-1)*/
            if(cnt == DEPTH-1)
                wfull  <=1'd1;
            else
               wfull  <= 1'd0;
            
            if(cnt == 0)
                rempty <= 1'd1;
            else
                rempty <= 1'd0;
        end
    end
     
    dual_port_RAM #(
        .DEPTH(DEPTH       ),
        .WIDTH(WIDTH       )
    )
    myRAM(
        .wclk (clk         ),
        .wenc (winc&~wfull ),
        .waddr(waddr       ),
        .wdata(wdata       ),
        .rclk (clk         ),
        .renc (rinc&~rempty),
        .raddr(raddr       ),
        .rdata(rdata       )
    );
    
endmodule