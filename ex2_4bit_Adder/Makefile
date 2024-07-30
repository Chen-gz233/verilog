run:
	iverilog -o generate src/lab_1.v tb/lab1_tb.v

wave:
	vvp -n generate -lxt2
	
clean:
	rm -rf generate
	rm -rf test.vcd