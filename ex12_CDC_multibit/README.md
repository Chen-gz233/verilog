# 多bit跨时钟域处理

- 多bit的跨时钟域为什么不能直接打两拍？

每一个寄存器中的数据在进行跨时钟域处理的时候，从源寄存器到目的寄存器之间的延迟可能会出现不同的路径长度，所以延迟也不能控制完全相等。

## 方法1 ： 格雷码+同步
格雷码是一种循环码（相邻的值之间只有一个bit的不同）

采用格雷码。使相邻两个多bit数据传输过程中，只有一个bit发生改变。（多bit变化到单bit变化）降低亚稳态的产生。

格雷码只能在地址或者数值依次增加的情况下使用。

数值不是依次增加，那么格雷码相邻的数值不止一个bit发生改变。

**同步** ： 慢时钟域到快时钟域才能使用

## 方法2 ： Dmux
`格雷码+同步`的方法只适合数值依次变化（累加or累减），并且是慢时钟域到快时钟域。

当快时钟域源数据向慢时钟域传输，数据可能被慢时钟域遗漏。
因此在Dmux方法中，需要快时钟域数据在快时钟域下保持几个时钟周期：满足源数据有足够时间传向目的数据


- 条件：支持多bit跨时钟域处理（支持跳变的多bit数据），DMUX在源端的clk信号必须维持好几个目的断时钟周期时间（3-4个）





