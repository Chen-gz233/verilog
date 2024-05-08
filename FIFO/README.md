reference: https://zhuanlan.zhihu.com/p/95081329
### Icarus Verilog编译器主要包含3个工具：

- iverilog：用于编译verilog和vhdl文件，进行语法检查，生成可执行文件
- vvp：根据可执行文件，生成仿真波形文件
- gtkwave：用于打开仿真波形文件，图形化显示波形

### 参数 -o
这是比较常用的一个参数了，和GCC中-o的使用几乎一样，用于指定生成文件的名称。如果不指定，默认生成文件名为a.out。如：iverilog -o test test.v

### 参数-y
用于指定包含文件夹，如果top.v中调用了其他的的.v模块，top.v直接编译会提示
```
led_demo_tb.v:38: error: Unknown module type: led_demo
2 error(s) during elaboration.
*** These modules were missing:
        led_demo referenced 1 times.
***
```
找不到调用的模块，那么就需要指定调用模块所在文件夹的路径，支持相对路径和绝对路径。

如：``` iverilog -y D:/test/demo led_demo_tb.v ```

如果是同一目录下：```iverilog -y ./ led_demo_tb.v```

###  参数-I
如果程序使用`include语句包含了头文件路径，可以通过-i参数指定文件路径，使用方法和-y参数一样。

如：```iverilog -I D:/test/demo led_demo_tb.v```


### 参数 -tvhdl
iverilog还支持把verilog文件转换为VHDL文件，如```iverilog -tvhdl -o out_file.vhd in_file.v```


##  编译

```iverilog -o wave led_demo_tb.v led_demo.v```命令，对源文件和仿真文件，进行语法规则检查和编译

例如，```led_demo_tb.v```中调用了```led_demo.v```模块，就可以直接使用```iverilog -o wave -y ./ top.v top_tb.v```来进行编译。


### 生成波形文件

使用```vvp -n wave -lxt2```命令生成vcd波形文件，运行之后，会在当前目录下生成.vcd文件。


如果没有生成，需要检查testbench文件中是否添加了如下几行：
```
initial
begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, led_demo_tb);    //tb模块名称
end
```