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

Scala中，对于普通文本/字母名称的方法应当采用小驼峰风格

#### Accessors/Mutators 属性访问器、修改器

其功能可以直接对应成Java中常用的getter/setter，但是命名风格与Java完全不一致，Scala中采用一下约定

> 对于属性的访问器/Accessors，该方法的名称与属性名称保持完全一致
>
> 某些情况下，对于`Boolean`类型的访问器，允许在前面加上`is`（例如`isEmpty`），这种情况下也要保证没有相应的修改器才行。（[Lift](https://liftweb.net/)框架中，对此种情况的约定是在属性名后加`_?`，这是非标做法，注意不要滥用该做法）
>
> 对于修改器/Mutators，其方法名应当是在属性名后加`_=`。遵循该约定后，调用点对属性的赋值将映射为调用该修改器方法（这不再仅是个约定，而变成了语言的约束）

```scala
class Foo {
  def bar = ...
  def bar_=(bar: Bar) {
    ...
  }
  def isBaz = ...
}

val foo = new Foo
foo.bar             // accessor
foo.bar = bar2      // mutator
foo.isBaz           // boolean property
```

由于Java没有对于属性及其绑定的一等支持，因此有了getter/setter范式的存在。在Scala中，有专门的库用于做此类支持

```scala
class Company {
  val string: Property[String] = Property("Initial Value") // 一个不变的属性对象引用，但属性对象保存的值是可以修改的
}
```

#### 无参方法/函数的括号

定义和调用无参方法/函数时，应当注意并考虑清楚是否要带括号

```scala
def foo1() = ...
def foo2 = ...
```

以上两个方法在Scala中都是合法的，两者也是不同的。其中`foo2`只能无括号方式调用、但`foo1`可以带括号调用。

实际行为类似访问器的方法、而且方法调用无任何副作用，那么声明时不应当带括号。若有副作用，那么就应当带上括号。调用时也应当遵循此约定，若是要调用含副作用的方法，注意带上其括号

#### 符号方法名

尽量避免！

Scala语言库中符号用得很多，但实际编程中对于符号的使用还是应当慎重考虑，尤其是这一符号没有其标准意义时。两个合理的使用场景是：DSL中(`actor ! msg`)；数学操作符（`a + b` `c :: d`）。在标准的API设计领域，严格限制符号方法名只能使用在纯函数式操作中。可以定义`>>=`来进行单子的`bind`操作，但是不允许定义`<<`方法向输出流写东西。因为前者是有完备数学定义的，而且没有任何副作用，但后者既没有标准定义也不是无副作用的操作。

一般而言，能以符号命名的方法应当是广为人知或者能很好地自描述的。一旦需要解释这个方法到底在做什么，那么该方法就不适合用符号名称了。

### 常量、值、变量和方法

常量命名应采用大驼峰风格，例如`scala.math.Pi`；一般的值、变量和方法应采用小驼峰命名风格

### 类型参数（泛型）

简单的类型参数一般用一个大写字母即可，一般从A开始

```scala
class List[A] {
  def map[B](f: A => B): List[B] = ...
}
```

若是类型参数有特定意义，那么可以用具备描述性的单词，该单词遵循类型的命名规则（注意不是全大写）；当然，若是的类型参数的作用域足够小，直接用单个字母依然没有问题

```scala
// 可以用单词
class Map[Key, Value] {
  def get(key: Key): Value
  def put(key: Key, value: Value): Unit
}

// 也可以用字母
class Map[K, V] {
  def get(key: K): V
  def put(key: K, value: V): Unit
}
```

#### HKT

理论上讲，高阶类型参数跟一般类型参数没什么不同（当然高阶kind至少是`* => *`而不是简单的`*`）。一般而言，更倾向于使用更具描述性的单词，而不是一个简单的字母，例如`class HigherOrderMap[Key[_], Value[_]] { ... }`。对于一些基础概念，可以用简单的字母，例如`F[_]`来表述函子、`M[_]`表述单子。

### 注解

Scala中注解一般采用小驼峰

### 特别说明

由于Scala本质上是函数式编程语言，因此`def add(a: Int, b: Int) = a + b`这种名称短小、方法体简单的函数定义很常见。这种行为在Java中是个很不好的做法，但是在Scala中是很推荐的。

## 类型

该部分内容参考[TYPES](https://docs.scala-lang.org/style/types.html)

### 类型推断

在保证代码清晰的前提下，尽可能地用上类型推断的功能。在向外开放API的地方，注意显式给出类型信息。

对于私有字段或本地变量，几乎完全不用显式给出类型，因为它们的类型我们一般能直接从值上看出来，对于那些不那么明显的、或者比较复杂的，还是应该显式给出类型。对于所有的公共成员，必须明确给出类型信息。

特别地，Scala编译器对于函数值/λ表达式的类型推断做了特殊处理，对于需要传入函数的高阶函数调用，可以不必声明该表达式参数的类型。考虑`ints.map(i => i * 2)`，编译器可以直接推断出λ表达式的参数`i`的类型。

### 类型注解

类型注解该以如下方式写`value: Type`，例如`i: Int`、`d: Double`甚至`l: ::`

### Type ascription / 类型归属？

类型归属的语法跟类型注解是一致的，所以很容易搞混，例如`Nil: List[String]` `None: Option[String]` `"Str12": AnyRef` `Set(values: _*)`。类型归属是在向编译器声明我们期望该值的类型是什么，一般在做上转型操作，前三者例子便是如此；但Scala中更常见的可能是最后一例，当调用一个可变参数的方法时、期望将序列展开，因此用到`_*`（否则会变成可变参数列表仅接收到一个参数，该参数是个序列）

### 函数

函数的类型遵循`(argType1, argType2, ...) => retType`的写法。特别地，对于元数为1的函数，可以省去参数的括号，写作`argType => retType`


### 结构类型

若是结构类型的总长度小于50字符，那么应该写在一行里，否则就应写作多行，并且为之分配一个类型别名。

```scala
// 简单结构类型
def foo(a: { val bar: String }) = ...

// 复杂结构类型
private type FooParam = {
  val baz: List[String => String]
  def bar(a: Int, b: Int): String
}

def foo(a: FooParam) = ...
```

当把简单结构类型写在一行的时候，多个成员之间应该用一个分号和空格隔开，成员跟花括号之间也应有空格

> 结构类型是在运行时用反射实现的，因此性能较差。开发时还是应尽可能选择常规类型，除非结构类型能带来明显的益处

## 嵌套代码块

[NESTED BLOCKS](https://docs.scala-lang.org/style/nested-blocks.html)

### 代码块

左花括号必须跟它所归属定义的声明放在同一行

### 括号

当某表达式跨越多行且需要小括号包裹时，左右两小括号与其包裹的内容之间应当没有空格、并且与内容保持同一行；

```scala
(this + is a very ++ long *
  expression)
```

小括号也可用于禁用分号推断，因此允许更喜欢将操作符写在开头的开发者写出如下代码

```scala
(  someCondition
|| someOtherCondition
|| thirdCondition
)
```

## 声明

[DECLARATIONS](https://docs.scala-lang.org/style/declarations.html)

类、对象、特质的构造器应当尽可能放在一整行里，当这一行过长（比如超出100字符）的时候，那么需要将该行拆成多行，每个构造器参数及其跟随的逗号占一行，如下所示

```scala
// 单行形式
class Person(name: String, age: Int) {
  …
}

// 多行形式
class Person(
  name: String,
  age: Int,
  birthdate: Date,
  astrologicalSign: String,
  shoeSize: Int,
  favoriteColor: java.awt.Color,
) {
  def firstMethod: Foo = …
}
```

若是该类、对象、特质扩展了其他成员，采用同样的规则。尽可能放在一行里，若是单行超出100字符，那就拆成如下的多行形式

```scala
class Person(
  name: String,
  age: Int,
  birthdate: Date,
  astrologicalSign: String,
  shoeSize: Int,
  favoriteColor: java.awt.Color,
) extends Entity
  with Logging
  with Identifiable
  with Serializable {

  def firstMethod: Foo = …
}
```

### 类中各元素的顺序

类、对象、特质中的所有成员之间一般都应当用一个空行隔开。对于`val`和`var`，如果定义足够简单（比如单行少于20字符）并且没有Scala Doc，那么多个`val`或`var`之间可以不加空行。
