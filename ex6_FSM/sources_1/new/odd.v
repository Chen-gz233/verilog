`timescale 1ns/1ns
module sequence_detect(
	input clk,
	input rst_n,
	input data,
	input data_valid,
	output reg match
	);
    
    reg [3:0] cur,nex;
 
    parameter  start = 4'd0;
    parameter  s1 = 4'd1;
    parameter  s2 = 4'd2;
    parameter  s3 = 4'd3;
    parameter  s4 = 4'd4;
    
    always @(posedge clk or negedge rst_n) begin

        if(!rst_n)//0-1

            cur <= start;

        else

            cur <= nex;

    end


    always @(*) begin
    case(cur)
        start:
            if(data_valid && !data)//0
                nex <= s1; //0        
            else
                nex <= start;
                
        s1:
            if (data_valid)
                begin  
                    if (data) //1
                        nex <= s2;   //01
                    else 
                        nex <= s1;        
                end
            else
             nex <= s1;
                       
        s2:
            if (data_valid)
                begin  
                    if (data) //1
                        nex <= s3;   //011
                    else 
                        nex <= s1;      
                end
            else 
            nex = s2;    
                          
        s3:
            if (data_valid)
                begin  
                    if (!data) //0
                        nex <= s4;       //0110
                    else
                        nex <= start;                
                end
            else
             nex <= s3;    
                         
        s4:
            if (data_valid)
                begin  
                    if (!data)//0
                        nex <= s1;      //������Ч��Ϊ0����ƥ��Ŀ�����еĵ�һλ0����һ״̬Ϊs1
                    else 
                        nex <= start;          //������Ч��Ϊ1����ƥ��Ŀ�����У���һ״̬Ϊstart
                end
            else nex <= start;                  //������Ч����һ״̬Ϊstart
        default:
            nex <= start;
        endcase
end

    always @(cur or rst_n)
    begin
        if(!rst_n == 1)
            match <= 1'b0;
        else if(cur == s4)                      //����״̬s4��ʾ��λ���ݶ�ƥ�䣬��ƥ��ָʾ�ź�match����
                match <= 1'b1;
            else
                match <= 1'b0;
    end
endmodule