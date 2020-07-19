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

## 命名约定

该部分内容参考[NAMING CONVENTIONS](https://docs.scala-lang.org/style/naming-conventions.html)

绝大多数情况下，Scala采用小驼峰风格`lowerCamelCase`，一些缩写术语也作为普通单词对待`xHtml`/`maxId`，由于下划线在Scala语法中有特殊意义，因此非常不推荐使用（若要强行使用、编译器也不会主动拒绝此类代码）

### 类、特质

类和特质的命名应当遵循大驼峰风格