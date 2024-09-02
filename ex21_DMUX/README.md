# DMUX

https://blog.csdn.net/weixin_43593478/article/details/137028706


dmux表示数据分配器，该方法适合**带数据有效标志信号**的**多bit数据**做跨时钟域传输(慢到快)。其典型结构如下：


![alt text](image.png)

快时钟域到慢时钟域只要将红框中换成单bit快时钟域到慢时钟域处理单元即可。

`DMUX`遵循的原则就是，**数据不同步只对控制信号同步**，这点其实和异步`fifo`里的思路一样，只不多异步`fifo`中的控制信号是多比特的格雷码，而这个场景下的控制信号是`data_valid`。继续观察结构可以发现，`DMUX`是将单`bit`控制信号同步之后将其最为`mux`的选择信号。因此使用这个结构需要满足一些要求：

1.**数据和使能信号在源时钟域为同步到来的信号**；

2.**在目的时钟域对数据完成采样前，数据信号不能跳变**；

如果不满足以上的要求，那么就可能造成数据漏同步、错同步等问题。