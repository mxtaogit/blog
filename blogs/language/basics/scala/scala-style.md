# Scala Style

参照官方文档推荐的Scala代码风格[SCALA STYLE GUIDE](https://docs.scala-lang.org/style/index.html)

---

## 缩进和换行

该部分参考[INDENTATION](https://docs.scala-lang.org/style/indentation.html)

每个缩进级别都是2个空格

尽量保证每行不要超过80字符，若有表达式超出了，尽量考虑换行

```scala
// 缩进是2个空格
object Foo {
  def bar(): Unit = {
    val x = 10
    //...
  }
}

// ---

// 超长表达式的换行
val result = 1 + 2 + 3 + 4 + 5 + 6 +
  7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 +
  15 + 16 + 17 + 18 + 19 + 20

// 超多参数的函数调用，变量名超长时要注意方法在新一行开始调用
val myLongFieldNameWithNoRealPoint =
  foo(
    someVeryLongFieldName,
    andAnotherVeryLongFieldName,
    "this is a string",
    3.1415)
```