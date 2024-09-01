module pulse_handshake (
    input clk_a ,
    input clk_b ,
    input rst_n ,

    input pulse_in ,
    output pulse_out 
    
);

    reg req ;
    reg req_ff1 ;
    reg req_ff2 ;
    reg req_ff3 ;

    reg resp ;
    reg resp_ff1 ;

    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            req <=1'b0 ;
        end else if (pulse_in)begin
            req <=1'b1 ;
        end else if(resp_ff1)begin
            req <=1'b0 ;
        end else begin
            req <= req ;
        end
    end

    always @(posedge clk_b or negedge rst_n) begin
        if(!rst_n)begin
            req_ff1 <=1'b0 ;
            req_ff2 <=1'b0 ;
            req_ff3 <=1'b0 ;
        end else begin
            req_ff1 <= req ;
            req_ff2 <= req_ff1 ;
            req_ff3 <= req_ff2 ;
        end
    end

    always @(posedge clk_a or negedge rst_n) begin
        if(!rst_n)begin
            resp <=1'b0 ;
            resp_ff1 <=1'b0 ;
        end else begin
            resp <= req_ff2 ;
            resp_ff1 <= resp ;
        end
    end

    assign pulse_out = ~req_ff3 & req_ff2 ;
endmodule //pulse_handshake