`timescale 1ns / 1ps

module pulse_handshake_tb();

    reg clk_a;
    reg clk_b;
    reg rst_n;
    reg pulse_in;
    wire pulse_out;

    pulse_handshake pulse_handshake_tb (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .rst_n(rst_n),
        .pulse_in(pulse_in),
        .pulse_out(pulse_out)
    );

    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a; 
    end

    initial begin
        clk_b = 0;
        forever #10 clk_b = ~clk_b; 
    end


    initial begin
        rst_n = 0;
        pulse_in = 0;
        #100;
        rst_n = 1;
        #60 pulse_in = 1; 
        #10 pulse_in = 0;

        #90 pulse_in = 1; 
        #10 pulse_in = 0;

        #90 pulse_in = 1; 
        #10 pulse_in = 0;
        #100; 
        $finish;
    end


//    initial begin
//        $fsdbDumpfile("test_tb.fsdb");
//        $fsdbDumpvars;
//    end
endmodule