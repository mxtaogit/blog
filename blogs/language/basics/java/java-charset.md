# 关于字符集

需要用到`java.util.UUID#nameUUIDFromBytes(byte[] bytes)`来生成UUID

参数处直接调用了`String#getBytes`方法获取字节数据

但是结果中发现不少数据生成了同一个UUID

最终确认到，是有些节点的默认字符集是`US_ASCII`，而不是`UTF-8`

因此这些节点上、涉及到了中文字符的`getBytes`，出现了问题

todo .....