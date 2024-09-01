`timescale 1ns / 1ps

module pulse_signal_tb;

    reg clk_a;
    reg clk_b;
    reg rst_n;
    reg pulse_in;
    wire pulse_out;

    pulse_signal uut (
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
        #20 pulse_in = 1; 
        #20 pulse_in = 0;

        #40 pulse_in = 1; 
        #20 pulse_in = 0;

        #60 pulse_in = 1; 
        #200; 
        $finish;
    end


//    initial begin
//        $fsdbDumpfile("test_tb.fsdb");
//        $fsdbDumpvars;
//    end
endmodule