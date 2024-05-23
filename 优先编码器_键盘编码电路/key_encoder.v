`timescale 1ns/1ns

module encoder_0(   //优先编码器
   input      [8:0]         I_n   ,
   
   output reg [3:0]         Y_n   
);

always @(*)begin
   casex(I_n)   //由此可见，输入X_n低电平有效（0是重点），输出Y_n低电平有效
      9'b111111111 : Y_n = 4'b1111;
      9'b0xxxxxxxx : Y_n = 4'b0110;
      9'b10xxxxxxx : Y_n = 4'b0111;
      9'b110xxxxxx : Y_n = 4'b1000;
      9'b1110xxxxx : Y_n = 4'b1001;
      9'b11110xxxx : Y_n = 4'b1010;
      9'b111110xxx : Y_n = 4'b1011;
      9'b1111110xx : Y_n = 4'b1100;
      9'b11111110x : Y_n = 4'b1101;
      9'b111111110 : Y_n = 4'b1110;
      default      : Y_n = 4'b1111;
   endcase    
end 
     
endmodule
/*
10个按键分别对应十进制数0-9，按键9的优先级别最高；(说人话就是高位优先级大于低位)
按键悬空时，按键输出高电平，按键按下时，按键输出低电平；(说人话就是低电平有效，那么Y_n输出是低电平有效)
键盘编码电路的输出是8421BCD码。
*/
module key_encoder( //键盘编码
      input      [9:0]         S_n   ,         
 
      output wire[3:0]         L     ,
      output wire              GS
);
wire [3:0] L_n;
encoder_0 encoder_0_1(
    .I_n(S_n[9:1]), //优先编码器输入是9位。这里S_n输入是十位
    .Y_n(L_n)
);
assign L= ~L_n; //输出按位反
assign GS = ~(&L_n)||(S_n == 10'b11_1111_1110); //补充一种情况

endmodule