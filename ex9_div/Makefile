run:
	iverilog -o generate sources/new/lab_1.v sim/new/lab1_tb.v

wave:
	vvp -n generate -lxt2
	
clean:
	rm -rf generate
	rm -rf test.vcd