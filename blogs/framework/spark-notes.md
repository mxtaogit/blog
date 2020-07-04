# Spark 相关内容随记

随手记录Spark相关的问题、思考等

## Spark SQL - DataSource

通过实现Spark定义的DataSource接口为Spark新增自定义数据源

数据源API目前分V1和V2版本，到目前为止[*Spark 3.0.0*](https://spark.apache.org/releases/spark-release-3-0-0.html)似乎还没有完成进化

[Data source V2 API refactoring](https://issues.apache.org/jira/browse/SPARK-25390)

貌似将在3.1.0版本将API稳定下来？

[Stabilize Data Source V2 API](https://issues.apache.org/jira/browse/SPARK-25186)

https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-data-source-api-v2.html

https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-DataSourceV2.html

https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-DataSource.html

## Spark SQL - CSV

CSV类型文件中，出于各种原因可能导致Spark SQL解析数据会出错。

> 以下问题举例在Hadoop2.6.0-Spark2.1.1-Scala2.10.6-JDK1.7生产环境出现，较新版本中的Spark具体行为暂不可知。该Spark版本已被魔改且无代码，离线环境中只有Spark2.4.4-Scala2.11，尝试看下源代码发现该部分已被重构，抛异常的类都没有了

例如，有些字段里面包含了特殊字符，导致Spark SQL解析行数据时出现了字段截断错误，从而导致列错位，有些转换函数直接执行失败，进而导致整个任务失败。

问题解决方式是强制指定`mode=DROPMALFORMED`，直接将问题数据丢弃，这是Spark SQL直接支持的配置，看文档的时候可能看到了，但是无视掉了。。。

Spark文档中对于CSV支持的配置有详细介绍。

最新版本的参考文档：[DataFrameReader#csv](https://spark.apache.org/docs/latest/api/scala/org/apache/spark/sql/DataFrameReader.html#csv(paths:String*):org.apache.spark.sql.DataFrame)

Spark 2.4.6参考文档：[DataFrameReader#csv](https://spark.apache.org/docs/2.4.6/api/scala/index.html#org.apache.spark.sql.DataFrameReader@csv(paths:String*):org.apache.spark.sql.DataFrame)