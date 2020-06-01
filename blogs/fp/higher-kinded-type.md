---

tags: ['Language Feature']
---

# Higher Kinded Type - 高阶类型

## Kind[^1] - 类型

**Kind**是类型理论(Type Theory)中的定义。一个*kind*便是一个*类型构造器*的*类型*(the *type* of a *type constructor*)，或者说是*高阶类型类型操作符*的*类型*(the *type* of a *higher-order type operator*)。

*Kind System*本质上是*简单类型Lambda演算*([simply typed lambda calculus](https://en.wikipedia.org/wiki/Simply_typed_lambda_calculus))的“上一层”。定义一个原始类型(primitive type)(记作`*`/$*$、称之为“type”)，它是任意*数据类型*(*data type*)的kind，不需要任何类型参数。

kind有个可能看上去有些莫名其妙的解释：“类型的类型”（type of a (data) type），但实际上它也有些*元数*指示的意思。从语法上讲，可以很自然地将多态类型视为类型构造器，因此非多态类型可以视为一个0元类型构造器/无参类型构造器，所有的无参类型构造器都是相同的、最简单的kind，便是`*`/$*$

维基百科：[Kind (type theory)](https://en.wikipedia.org/wiki/Kind_(type_theory))



---

## 相关链接

[^1]: 维基百科 [Kind (type theory)](https://en.wikipedia.org/wiki/Kind_(type_theory))

Scala语言对此的设计：[Generics of a Higher Kind](https://adriaanm.github.com/files/higher.pdf)

[Higher Kinded Types in typescript](https://www.thesoftwaresimpleton.com/blog/2018/04/14/higher-kinded-types)

[Higher Kinded Types in F#](https://robkuz.github.io/Higher-kinded-types-in-fsharp-Intro-Part-I/)


[Higher-rank and higher-kinded types](https://www.stephanboyer.com/post/115/higher-rank-and-higher-kinded-types)

关于对F#添加该功能的讨论：

[Add support for higher-rank types](https://github.com/fsharp/fslang-suggestions/issues/567)

[Simulate higher-kinded polymorphism](https://github.com/fsharp/fslang-suggestions/issues/175)

[Scala类型系统——高级类类型(higher-kinded types)](https://my.oschina.net/Barudisshu/blog/690595)

[高阶类型 Higher Kinded Type](https://zhuanlan.zhihu.com/p/29021140)
