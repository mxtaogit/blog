---

tags: ['Language Feature']
---

# Higher Kinded Type - 高阶类型

## Kind

维基百科：[Kind (type theory)](https://en.wikipedia.org/wiki/Kind_(type_theory))

> "kind"中文翻译也是“类型”，这样就跟"type"有些混淆。下文仅将“type”翻译类型。

**Kind**是类型理论(Type Theory)中的定义。一个*kind*便是一个*类型构造器*的*类型*(the *type* of a *type constructor*)，或者说是*高阶类型类型操作符*的*类型*(the *type* of a *higher-order type operator*)。

*Kind System*本质上是*简单类型Lambda演算*([simply typed lambda calculus](https://en.wikipedia.org/wiki/Simply_typed_lambda_calculus))的“上一层”。定义一个原始类型(primitive type)(记作`*`/$*$、称之为“type”)，它是任意*数据类型*(*data type*)的kind，不需要任何类型参数。

kind有个可能看上去有些莫名其妙的解释：“(数据)类型的类型”（type of a (data) type），但实际上它也有些*元数*指示的意思。从语法上讲，可以很自然地将多态类型视为类型构造器，因此非多态类型可以视为一个0元类型构造器/无参类型构造器，所有的无参类型构造器都是相同的、最简单的kind，便是`*`/$*$

高阶类型操作符在编程语言中并不常见，在大多数编程实践中，kind用于区分*数据类型*和*用于实现参数化多态的构造器类型*(types of constructors which are used to implement [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism))。在类型系统使得用户能编码实现参数化多态的编程语言中(如C++ Haskell Scala)，或明或暗地有kind的概念存在。

### Examples

+ `*`/$*$是所有数据类型的kind，读作"type"，也可看作0元类型构造器/无参类型构造器，在当前上下文中也称为恰当类型(proper type)，通常也包含函数式编程语言中的函数类型。例如`Int`/`Bool`/`List<Int>`/`Map<String, List<Double>>`的kind都是`*`
+ `* -> *`/$* \rightarrow *$是一元类型构造器(unary type constructor)的kind。例`List`类型的kind便是`* -> *`，需要给出一个类型参数`Int`才能得到恰当类型`List<Int>`
+ `* -> * -> *`/$* \rightarrow * \rightarrow *$是二元类型构造器(binary type constructor，curry方式实现)的kind。例如`Tuple`便是二元类型构造器；*函数类型构造器*`->`也属此类（注：对`->`应用的结果是函数类型，函数类型kind是`*`）
+ `(* -> *) -> *`/$(* \rightarrow *) \rightarrow *$是从*一元类型构造器*到*恰当类型*的*高阶类型操作符*的kind

| Values | Types | Kinds |
| :- | :- | :- |
| `1` | `Int` | `*` |
| `[1,2,3]` | `List<Int>` | `*` |
| `(1, "")` | `Tuple<Int, String>` | `*` |
| `fun s = s.Length` | `String -> Int` | `*` |
| - | `List` | `* -> *` |
| - | `Tuple` | `* -> * -> *` |
| - | `->` | `* -> * -> *` |

> 从左向右提升抽象层次

Haskell的Kind系统中，$K = * | K \rightarrow K$，它描述了两条规则：`*`/$*$是所有数据类型的kind；`* -> *`/$* \rightarrow *$是一元类型构造器的kind，接受一个kind然后给出一个kind。

---

## 相关链接

维基百科 [Kind (type theory)](https://en.wikipedia.org/wiki/Kind_(type_theory))

Scala语言对此的设计：[Generics of a Higher Kind](https://adriaanm.github.com/files/higher.pdf)

[Higher Kinded Types in typescript](https://www.thesoftwaresimpleton.com/blog/2018/04/14/higher-kinded-types)

[Higher Kinded Types in F#](https://robkuz.github.io/Higher-kinded-types-in-fsharp-Intro-Part-I/)


[Higher-rank and higher-kinded types](https://www.stephanboyer.com/post/115/higher-rank-and-higher-kinded-types)

关于对F#添加该功能的讨论：

[Add support for higher-rank types](https://github.com/fsharp/fslang-suggestions/issues/567)

[Simulate higher-kinded polymorphism](https://github.com/fsharp/fslang-suggestions/issues/175)

[Scala类型系统——高级类类型(higher-kinded types)](https://my.oschina.net/Barudisshu/blog/690595)

[高阶类型 Higher Kinded Type](https://zhuanlan.zhihu.com/p/29021140)
