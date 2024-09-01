
# 单bit跨时钟域

## 无论电平还是脉冲 ：慢到快 大量拍

## 脉冲信号：快到慢 信号做展宽 然后同步

## 握手协议

 req端 延三拍 :req `req_ff1`, `req_ff2`, `req_ff3`

输出是
```
data_out = req_ff2 && ~req_ff3;
```

resp端 延两拍  `resp`,`resp_ff1`

用于接受跨时钟处理后的req_ff2 ,然后跨时钟处理到`req`
