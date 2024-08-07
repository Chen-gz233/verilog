
# 跨时钟域总结

秋招学习跨时钟域
总结一下吧

## 异步电路


设计中有两个频率不同的时钟(也可能多个),而有数据在两组时钟之间传输


## 单bit跨时钟域

### 慢时钟域数据-> 快时钟域

- 方法 : 使用两个`锁存器` (打两拍)

数据跨时钟域同步过程中,`脉冲宽度`会改变，不影响同步结果

```
`timescale 1ns/1ns

//慢时钟数据跨时钟域到快时钟域
module cdc_slow2fast(
    input clk_s     ,
    input pluse_s   ,
    input clk_f     ,
    output pluse_f
);

    reg pluse_s_ff1 ;
    reg pluse_s_ff2 ; 
    //慢时钟下的数据在快时钟下打两拍
    always @(posedge clk_f)begin
        pluse_s_ff1 <= pluse_s ;
        pluse_s_ff2 <= pluse_s_ff1 ;
    end

    assign pluse_f = pluse_s_ff2 ;
endmodule

```



### 快时钟域数据 -> 慢时钟域

- 方法1 ：  `脉冲展宽`+`同步`


那么将快时钟域的信号进行`展宽`，但是会出现`毛刺`

```
`timescale 1ns/1ns

module cdc_fast2slow(
    input clk_f ,
    input clk_s ,
    input pulse_f,

    output pulse_s
);
    //在快时钟域下打两拍 
    //目的是为了将脉冲信号展宽，方便识别
    reg [2:0] pulse_f_ff;
    always @(posedge clk_f) begin
        pulse_f_ff <= {pulse_f_ff[1:0],pulse_f} ;
    end

    wire pulse_s_w ;
    assign pulse_s_w =  | pulse_f_ff ;//按位或
    
    
    reg pulse_s_ff1;
    reg pulse_s_ff2;
    
    always @(posedge clk_s) begin
        pulse_s_ff1 <= pulse_s_w  ;
        pulse_s_ff2 <= pulse_s_ff1 ;
    end
    assign pulse_s = pulse_s_ff2;
endmodule
```
 
 - 方法2 : `脉动电平检测`+`双触发器同步`+`边缘检测`

	- 对快时钟域的电平设置检测信号（翻转）
    - 将翻转信号进行跨时钟域处理
    - 使用两次寄存器打节拍
    - 将两个寄存器信号做异或
```
`timescale 1ns/1ns

module cdc_fast2slow_new(
    input clk_f ,
    input clk_s ,
    input pulse_f,

    output pulse_s
);
    //标志寄存器： 检测快时钟域中的脉冲信号

    reg  pulse_f_flag = 0;

    always @(posedge clk_f) begin
        if(pulse_f)begin
            pulse_f_flag <= ~pulse_f_flag ;
        end else begin
            pulse_f_flag <= pulse_f_flag  ;
        end 
    end
    
    reg pulse_f_ff1;
    reg pulse_f_ff2;
    reg pulse_s_ff3;    //这里的第三拍为了异或操作
    //对标志寄存器做跨时钟域处理
    always @(posedge clk_s) begin
        pulse_f_ff1 <= pulse_f_flag  ;
        pulse_f_ff2 <= pulse_f_ff1 ;
        pulse_s_ff3 <= pulse_f_ff2 ;
    end

    assign pulse_s = pulse_s_ff3 ^ pulse_f_ff2;
endmodule


```

## 多bit跨时钟域处理

- 多bit的跨时钟域为什么不能直接打两拍？

每一个寄存器中的数据在进行跨时钟域处理的时候，从源寄存器到目的寄存器之间的延迟可能会出现不同的路径长度，所以延迟也不能控制完全相等。

###  方法1 ： 慢时钟域-> 快时钟域 : `格雷码`+`同步`
采用格雷码。使相邻两个多bit数据传输过程中，`只有一个bit发生改变`。（多bit变化到单bit变化）`降低亚稳态`的产生。

格雷码**只能在地址或者数值依次增加的情况下使用**。

数值不是依次增加，那么格雷码相邻的数值`不止一个bit发生改变`。

```
`timescale  1ns/1ns

//格雷码+同步的方法只适合两种情况
// 1. 多bit的跨时钟域数值（地址or数据）必须依次变化（增大 or 减小） 
// 2. 必须是慢时钟域数据到快时钟域数据


module gray_cdc(
    input clk_s,
    input clk_f,
    input [3:0] data_in,
    
    output [3:0] data_out 
);

    //二进制2格雷码
    wire [3:0] gray_data;
    assign  gray_data = (data_in>>1) ^ data_in ;

    //跨时钟域处理
    reg [3:0] gray_data_ff1;
    reg [3:0] gray_data_ff2;

    //格雷码2二进制
    reg [3:0] out_data;

    //跨时钟域处理
    always @(posedge clk_f ) begin
        gray_data_ff1 <= gray_data ;
        gray_data_ff2 <= gray_data_ff1 ;
        
    end
    //格雷码2二进制
    integer i;
    always @(*) begin
        out_data[3] <= gray_data_ff2[3];
        for(i=2;i>=0;i=i-1) begin
            out_data[i] = (gray_data_ff2[i] ^ out_data[i+1]);
        end
    end
    assign data_out =out_data; 


endmodule


```

###  方法2 ： 快时钟域 -> 慢时钟域 : `Dmux`

`格雷码+同步`的方法只适合数值依次变化（累加or累减），并且是慢时钟域到快时钟域。

当快时钟域源数据向慢时钟域传输，数据可能被慢时钟域遗漏。
因此在Dmux方法中，需要快时钟域数据在快时钟域下保持几个时钟周期：满足源数据有足够时间传向目的数据


- 条件：支持多bit跨时钟域处理（支持跳变的多bit数据），DMUX在源端的clk信号必须维持好几个目的断时钟周期时间（3-4个）
```
module dmux_cdc #(
    parameter tx_clk = 100,
    parameter rx_clk = 50 ,
    parameter DATA_WIDTH = 8
)
(
    input clk_f ,
    input clk_s ,
    input rst_n  ,
    input [DATA_WIDTH-1:0] data_in ,
    input valid_in ,

    output [DATA_WIDTH-1 :0] data_out,
    output valid_out
);
    reg [DATA_WIDTH-1:0] data_in_ff1;
    reg valid_in_ff1;

    //在快时钟域打一拍
    always @(posedge clk_f or negedge rst_n)begin
        if(!rst_n)begin
            data_in_ff1 <= 'd0;
            valid_in_ff1 <= 'd0;
        end else begin
            data_in_ff1 <= data_in;
            valid_in_ff1 <= valid_in ;
        end
    end

    reg valid_in_ff2;
    reg valid_in_ff3;

    //valid信号在慢时钟域打两拍
    always @(posedge clk_s)begin
        if(!rst_n)begin
            valid_in_ff2<= 'd0;
            valid_in_ff3<= 'd0;
        end else begin
            valid_in_ff2<= valid_in_ff1 ;
            valid_in_ff3<= valid_in_ff2 ;
        end
    end

    //选择器(MUX)
    reg [DATA_WIDTH-1 : 0] data_out_ff1;
    reg valid_out_ff1;
    
    always @(posedge clk_s)begin
        if(!rst_n)begin
            data_out_ff1<= 'd0;
            valid_out_ff1 <= 'd0;
        end else if(valid_in_ff3) begin
            data_out_ff1 <= data_in_ff1;
            valid_out_ff1 <= 'd1;
        end else begin
            data_out_ff1 <= data_out_ff1;
            valid_out_ff1 <= 'd0;
        end
    end
    assign data_out = data_out_ff1;
    assign valid_out = valid_out_ff1 ;

endmodule
```