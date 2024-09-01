
//展宽+打两拍
module pulse_signal(
    input clk_a ,
    input clk_b ,
    input rst_n ,
    input pulse_in ,

    output pulse_out

);
    //展宽
    reg [2:0] pulse_in_reg ;

    always @(posedge clk_a or negedge rst_n)begin
        if (!rst_n)begin
            pulse_in_reg <= 3'b0;
        end else begin
            pulse_in_reg <= {pulse_in_reg[1:0],pulse_in};
        end
    end

    wire pulse_out_wire ;   //展宽信号做或处理
    assign pulse_out_wire = | pulse_in_reg ;

    reg pulse_out_ff1;
    reg pulse_out_ff2;
    reg pulse_out_ff3;
    
    always @(posedge clk_b) begin
         if (!rst_n)begin
            pulse_out_ff1 <= 1'b0   ;
            pulse_out_ff2 <= 1'b0   ;
            pulse_out_ff3 <= 1'b0   ;
        end else begin
            pulse_out_ff1 <= pulse_out_wire   ;
            pulse_out_ff2 <= pulse_out_ff1    ;
            pulse_out_ff3 <= pulse_out_ff2    ;
        end
    end

    assign pulse_out = pulse_out_ff2 & ~pulse_out_ff3 ;

endmodule