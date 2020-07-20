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

类和特质的命名应当遵循大驼峰风格，跟Java中对于类的命名约定是一致的

> 有时类或特质以及它们的成员是用于描述格式、文档或者某些协议，此时为了保持与输出一模一样，可以不遵循对类名和成员的命名约定。但应注意只能在这种特定用途使用，不能影响其余代码

### 对象

对象一般也遵循大驼峰命名风格，但是当之功能上模仿包或者函数的时候，可以不遵循这一约定

```scala
// 功能类似一个名为`ast`的包
object ast {
  sealed trait Expr

  case class Plus(e1: Expr, e2: Expr) extends Expr
  ...
}

// 功能类似一个名为`inc`的函数
object inc {
  def apply(x: Int): Int = x + 1
}
```

### 包

对包的命名应当遵循Java的命名约定，例如`com.foo.bar`

> 有时会出现必须用`_root_`指定包的全名的情况。但应注意不要过度使用`_root_`，以相对包路径方式来引用嵌套包是很推荐的做法，此外这十分有助于简化`import`语句

### 方法