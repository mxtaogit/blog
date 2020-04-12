---
author: mxtao
date: 2020-04-07
---

# 范畴论


## 范畴 / Category

一些事物（称为对象/object）及事物之间的关系（称为态射/morphism）构成一个范畴。

> 最小的范畴是拥有0个对象的范畴。因为没有对象，自然也就没有态射。

> 可以通过用态射将对象连接起来的方法构造出范畴。
>
> 给出一个有向图，将它的结点视为对象，将节点间的箭头视为态射。在这个有向图上增加箭头，就可以将之构造成范畴。首先为每个结点添加恒等箭头，然后为所有首位相邻的箭头（即符合复合条件）增加复合箭头。注意每次新增一个箭头，必须考虑它本身与其它箭头（除了恒等箭头）的复合。这种由给定的图产生的范畴，称为**自由范畴**。以上是一种自由构造的示例，即给定一个结构，用符合法则（在此，就是范畴论法则）的最小数量的东西来扩展它。

> 编程语言中，一般是类型体现为对象，函数体现为态射。

## 复合 / Composition

范畴的本质是复合，或者说复合的本质是范畴。若有从对象A到对象B的态射，也有从对象B到对象C的态射，那么必定存在从对象A到对象C的复合态射。

数学中，一般以 $g \circ f$ 表示函数复合（复合顺序从右向左，即 $g \circ f = \lambda x.g \lparen f \lparen x \rparen \rparen$，可读作“g after f”）。下以几种函数式编程语言进行复合思想的演示

```haskell
-- Haskell

-- Haskell中，小写字母表示类型参数，具体类型是大写字母开头
f :: a -> b     -- 接受a返回b的函数
g :: b -> c     -- 接受b返回c的函数
-- 用`.`符进行复合，同数学写法一致，从右向左
g . f           -- f g 复合，其签名 `a -> c`
```

```fsharp
// F#

// F# 中无 `Bottom Type` 的概念。F#中以`'`作为前缀的类型名称视为类型参数
let f : 'a -> 'b = fun x -> failwith "not implement"
// let f<'a, 'b> : 'a -> 'b = failwith "not implement" -- 另一种方式
let g : 'b -> 'c = fun x -> failwith "not implement"

// 用内置操作符`>>` `<<`进行复合，前者从左向右，后者从右向左
f >> g          // 从左向右复合
g << f          // 从右向左复合
```

```scala
// Scala

// Scala 中 `???` 是个 `Nothing` 类型值，`Nothing` 是Scala中的"Bottom Type"

// Scala中的方法/Method 函数/Function 函数值/Function Value 概念存在区别和联系
//   方法强调的是“实例方法”，是在“对象实例”上进行调用的。在trait、class中以`def`关键字定义的有参值是方法（Scala模糊了无参方法和属性的界限，无参方法可以不带括号调用求值）
//   函数无需任何实例即可调用，一般只能进行形如`func(arg)`的调用求值操作。在object、函数中以`def`关键字定义的可视为函数
//   函数值可视为一个函数实例，可以调用其实例方法。以λ给出的值、函数经`func _`转换的值、方法经`obj.method _`转换的值都是函数值，可将该值绑定到`funcVal`上
//      `funcVal.apply(arg)` 传入参数求值（可以直接这样用`funcVal(arg)`，会转换成对`apply`方法的调用）
//      `funcVal.compose(funcVal')` 传入另一个函数值，进行函数复合，其顺序从右向左
//      `funcVal.andThen(funcVal')` 传入另一个函数值，进行函数复合，其顺序从左向右
//      ...
//      注：`andThen` `compose`方法混入自`Function1`特质 (仅`Function1`特质定义了此方法，换言之，仅单参数列表、单参数函数才能进行复合)
//
// Scala中的函数和方法可以是参数多态/泛型的，但函数值必定是确定类型的

// Scala中函数不是自动柯里化/Currying，只能以定义多参数列表函数的形式进行显式柯里化（λ表达式写出柯里化不需任何特殊处理）
//      def func(x: A)(y: B)(z: C): X = ???
//      val func = (x: A) => (y: B) => (z: C) => ???
//      val func: A => B => C => X = x => y => z => ???

val f : A => B = ???
val g : B => C = ???
g compose f     // 从右向左复合，方法作为中缀操作符形式
g.compose(f)    // 从右向左复合，实例方法调用形式
f andThen g     // 从左向右复合，方法作为中缀操作符形式
f.andThen(g)    // 从左向右复合，实例方法调用形式
```

态射的复合需要满足以下两个性质

1. 结合律 / associative

    复合要满足结合律。若有三个态射 $f$ $g$ $h$ 可被复合（即对象可被首尾相连），必有 $h \circ \lparen g \circ f \rparen$ = $\lparen h \circ g \rparen \circ f$ = $h \circ g \circ f$。下面编程语言中以伪代码演示该性质（编程语言未定义“函数相等”）

    ```haskell
    -- Haskell
    f :: A -> B
    g :: B -> C
    h :: C -> D
    h . (g . f) == (h . g) . f == h . g . f
    ```

    ```fsharp
    // F#
    let f : 'a -> 'b = fun x -> failwith "not implement"
    let g : 'b -> 'c = fun x -> failwith "not implement"
    let h : 'c -> 'd = fun x -> failwith "not implement"
    h << (g << f) == (h << g) << f == h << g << f   // 从右向左复合
    f >> (g >> h) == (f >> g) >> h == f >> g >> h   // 从左向右复合
    ```

    ```scala
    // Scala
    val f : A => B = ???
    val g : B => C = ???
    val h : C => D = ???
    h compose g compose f       // 从右向左复合
    f andThen g andThen h       // 从左向右复合
    ```

    对于函数复合的结合律，以上演示应当还是比较显而易见，但是在其它范畴中，可能结合律并不是那么显然。

2. 恒等态射 / identity morphism

    范畴中的任一对象，都存在恒等态射。这个态射从自身出发又返回自身。它是复合的最小单位。恒等态射与任何（符合复合条件的）态射复合，得到的都是后者自身。恒等态射称为$id_A$（意为 identity on A，即A与自身恒等）。

    在数学中，若有接受$A$返回$B$的函数$f$，则有$f \circ id_A = f$ 和 $id_B \circ f = f$

    编程语言中的实现很简单，只需要简单地把输入返回即可（一般函数式编程语言标准库中已有该基本元素）

    ```haskell
    -- Haskell

    id :: a -> a        -- `id` 的函数签名，接受任意类型并返回此类型
    id x = x            -- `id` 的定义   注：Haskell标准库（称为Prelude）已定义
    
    f :: a -> b         -- 它与恒等函数复合之后还是其自身， 注：Haskell中是从右向左复合
    id . f == f         -- 这里的 `id` 是 `id_b`
    f . id == f         -- 这里的 `id` 是 `id_a`
    ```

    ```fsharp
    // F#

    // FSharp.Core 中 `id` 的定义、并以特性方式注明了编译成程序集之后的名称
    [<CompiledName("Identity")>]
    let id x = x    // F#具备自动泛化/Automatic Generalization特性，其类型是 `id : 'a -> 'a`

    let f : 'a -> 'b = fun x -> failwith "not implement"

    id >> f == f    // 从左向右复合，此处 `id` 是 `id_a`
    f >> id == f    // 从左向右复合，此处 `id` 是 `id_b`

    id << f == f    // 从右向左复合，此处 `id` 是 `id_b`
    f << id == f    // 从右向左复合，此处 `id` 是 `id_a`
    ```

    ```scala
    // Scala

    // scala-library 中 `identity` 的定义，标注了 `@inline`
    @inline def identity[A](x: A): A = x

    val f : a => b = ???

    (identity[b] _) compose f == f      // 从右向左复合，此处 `identity` 是 `identity_b`
    f compose identity[a] == f          // 从右向左复合，此处 `identity` 是 `identity_a`

    f andThen identity[b] == f          // 从左向右复合，此处 `identity` 是 `identity_b`
    (identity[a] _) andThen f == f      // 从左向右复合，此处 `identity` 是 `identity_a`
    ```

## 函数 / Function

数学上的函数是值到值的映射。在编程语言中，可以实现数学上的函数：一个函数，给它一个输入值，它就计算出一个结果。每次调用时，对于相同输入，总能得到相同的输出。

编程语言中，给出相同输入保证得到相同输出，且对外界环境无关的函数，称为纯函数。纯函数式语言Haskell中，所有函数都是纯的。对其它语言，可以构造一个纯的子集，谨慎对待副作用。之后将会看到单子如何只借助纯函数对副作用进行建模。

## **Set**

**Set**是集合的范畴。在**Set**中，对象是集合，态射是函数。

存在一个空集 $\emptyset$，它不包含任何元素；也存在只有一个元素的集合。函数可以将一个集合中的元素映射到另一个集合；也能将两个元素映射为一个。但是函数不能将一个元素映射成两个。恒等函数可以将一个元素映射为本身。

## 类型 / Type

范畴中，并非任意两个态射皆可复合。当某态射的源与另一态射的目标是同一对象时，两态射才能复合。在编程语言中，类型关乎复合。在参数及返回类型上，两函数必须满足复合条件，这样在类型意义上程序才是安全的（当然，这一般仅是程序通过编译的保证，并非逻辑正确的保证）。

对于类型，一个直观理解是：类型是值的集合。例如，`Bool`类型是2个元素`True` `False`的集合，`Char`类型是所有Unicode字符的集合。集合可能是有限的（例如`Bool`），也可能是无限的（例如`String`）。当声明`x :: Integer`时，是在说`x`是整型数集中的一个元素。

理想世界中，可以说Haskell的数据类型是集合，Haskell的函数是集合之间的数学函数。但由于“数学函数只知道答案，不可被执行”，Haskell必须要计算才能得出答案。若是可以在有限步骤内计算完毕，这没有什么问题，但有些计算是递归的，可能永远不会终止。在Haskell中无法阻止无终止的计算（停机问题）。Haskell为每个类型添加了一个特殊值，称为底/Bottom，用符号表示为`_|_`或`⊥`。这个值与无休止计算有关。若一个函数声明为`f :: a -> Bool`，它可以返回`True` `False`或`_|_`，后者表示它不会终止。

将**底**作为类型系统的一部分之后，可以将运行时错误作为**底**对待，甚至可以允许函数显式地返回底（一般用于未定义表达式）。例如声明`f :: a -> Bool` 定义`f x = undefined`。因为`undefined`求值结果是**底**，它可以是任何类型的值，因此该定义可以通过类型检查。（甚至`f = undefined`，因为**底**也是`a -> Bool`这种类型的值）。

可以返回**底**的函数称为偏函数；全函数则可以保证对任意参数返回有效的结果。

> 由于**底**的存在，Haskell的类型与函数的范畴称为**Hask**而不是**Set**。从实用的角度看，可以暂时无视掉这些无终止的函数与**底**，将**Hask**视为一个友善的**Set**即可。

> 注：Scala中也有**底**类型的概念存在，`Nothing`是任何类型/`Any`的子类型，`Null`是所有引用类型/`AnyRef`的子类型。F#中没有这一概念。

基于类型是集合的直觉，思考一些特殊情形。

+ 空集

    在Haskell中，空集是`Void`，这是个没有任何值的类型。可以定义一个接受`Void`的函数，但是无法调用它。因为无法提供一个`Void`类型的值（这种值不存在）。该函数的返回值没有任何限制，这是个多态返回类型的函数。Haskell中该函数称为`absurd :: Void -> a`。这种类型与函数，在逻辑学上有更深入的解释。`Void`表示谎言，`absurd`函数的类型相当于“由谎言可以推出任何结论”，这也就是逻辑学中的“爆炸原理”。

    > F# 和 Scala 中似乎没有 空集/`Void` 的概念 ？

+ 单例集合

    这是只有一个值的类型。它实际上是其它编程语言如C++/Java中常见的`void`类型。考虑一个函数`int f42() {return 42;}`。已知无法调用不接受任何值的函数，函数`f42`被调用时发生了什么？从概念上说，接受了一个空值。由于不会有第二个空值，所以没有显式强调它。在Haskell中为空值提供了一个符号`()`（读作"unit"，该符号既是类型也是值）

    > F#中，空值的类型为`unit`，值为`()`；Scala中空值类型为`Unit`，值为`()`，它是`AnyVal`的子类型。

    注意，每个接受unit的函数都等同于从目标类型中选择一个值的函数。实际上，可以将`f42`作为数字`42`的另一种表示方法，这也演示了如何通过与函数交互来代替显式给出集合中某个元素。这证实了数据与计算过程在本质上是没有区别的。从unit到类型A的函数就相当于集合A中的元素。

    考虑让函数返回一个unit的情形。在C++等其它编程语言中，这样的函数通常担当含有副作用的函数，这并非数学意义上的函数。一个返回unit类型的纯函数，它什么也不做；或者说，唯一做的就是丢弃接受的输入。

    ```haskell
    -- Haskell 中的 `unit` 函数
    unit :: a -> ()
    unit _ = ()
    ```

    ```fsharp
    // F# 中的 `ignore` 函数
    // ignore : 'a -> unit
    [<CompiledName("Ignore")>]
    let inline ignore _ = ()
    ```

    Scala中好像没有类似的函数

+ 二元集合

    二元集合一般对应编程语言中的布尔类型。命令式/面向对象编程语言中，该类型一般是内置的`bool`。但在Haskell中可以自行定义 `data Bool = True | False`（读作`Bool`要么是`True`要么是`False`）。（F#中也可以直接进行定义`type Bool = True | False`，Scala中需要借助封闭抽象类/sealed abstract class来定义）

    > 接受`Bool`的纯函数只是从目标类型中选择了两个值，一个关联了`True`，另一个关联了`False`。返回`Bool`的函数被称为“谓词/predicate”。

    > 注： 二元集合并非只有`Bool`，自定义类型也可能是个二元集合（例如`type Gender = Male | Female`）

## Hom-集 / Hom-Set

在一个范畴C中，从对象a到对象b的态射集称为hom-集，记作`C(a,b)`或$Hom_C\lparen a,b \rparen$。

## 序 / Order

存在这样的范畴，其中态射描述两个对象之间的小于等于关系（这是个范畴。每个对象都小于等于自身，因此恒等态射存在；若$a \le b$且$b \le c$，则$a \le c$，态射复合存在；另，态射复合遵守结合律）。伴随这种关系的集合称为前序集/preorder，一个前序集是一个范畴。

可以加强这种对象间的关系，要求该关系满足一个附加条件，即，若$a \le b$且$b \le a$，则必有$a = b$。伴随这种关系的集合称为偏序集/partial order。

若一个集合中的任意两个元素之间存在偏序关系，这种集合称为全序集/total order。

可将这些有序集描绘为范畴。前序集所构成的范畴，在任意两个对象之间最多只有一个态射，这样的范畴称为瘦范畴。瘦范畴内的每个hom-集要么是空集，要么是单例/singleton。在任意前序集构成的范畴内，`C(a,a)`也是个单例hom-集，只包含恒等态射。前序集中是允许出现环的，但偏序集中不允许。

排序需要用到前序、偏序和全序的概念。例如快排、归并之类的排序算法，只能在全序集中进行；偏序集可以用拓扑排序来进行处理。

## 幺半群 / Monoid

幺半群是个简单且重要的概念，它是基本算术幕后的概念：只要有加法或乘法运算就可以形成幺半群。编程中幺半群有很多实例，表现为字符串、列表、可折叠数据结构、并发编程中的`future`、函数式响应编程中的事件等。

数学上，幺半群$\langle S, *, e \rangle$是指一个带有可结合二元运算($*: S \times S \rightarrow S$，这隐含了$S$对运算$*$封闭)和单位元$e$的代数结构$S$。“可结合”是指二元运算满足结合律，$\forall a,b,c \in S \Rightarrow \lparen a * b \rparen * c = a * \lparen b * c \rparen$；单位元是指，$\exists e \in S \And \forall a \in S \Rightarrow a * e = e * a$

+ 作为集合

    伴随着一个满足结合律的二元运算和一个特殊“中立”元素的的集合被称为幺半群。对与该二元运算，这个“中立”元素的行为类似一个返回其自身的“unit”。

    例如，加法运算和包含0的自然数集便形成一个幺半群。结合律是指`(a+b)+c=a+(b+c)`或$\lparen a + b \rparen + c = a + \lparen b + c \rparen$。这个理想的、永远保持“中立”的元素是`0`，因为`0+a=a`以及`a+0=a`（$0+a=a$ $a+0=a$）。由于加法满足交换律（`a+b=b+a` $a+b=b+a$），所以似乎再强调`a+0=a`有点多余。但应注意，交换律并非幺半群所需。例如，字符串连接运算不遵守交换律，但字符串及其连接运算可以构成幺半群，它的中立元素是空字符串。

+ 作为范畴

    幺半群可被描述为带有一个态射集的单对象范畴，这些态射皆符合复合规则。

    只含单个对象m的范畴M存在hom-集M(m,m)。在这个集合上可以定义一个二元运算，M(m,m)中两元素“相乘”相当于两态射的复合。复合总是存在的，因为这些态射的源对象与目标对象是同一个对象。这种“乘法运算”也符合范畴论法则中的结合律，因为态射复合满足结合律。恒等态射也是肯定存在的。因此，总是能够从幺半群范畴中复原出幺半群集合。因此，幺半群范畴与幺半群集合是同一个东西。

    > 在范畴论中，是在尝试放弃查看集合及其元素，转而讨论对象和态射。因此，现从范畴的角度来看作用于集合的二元运算。
    >
    > 例如，一个将每个自然数都加5的运算（会将0映射为5、将1映射为6等等）这样就在自然数集上定义了一个函数，现在有了一个函数与一个集合。通常对于任意数字n，都会有一个加n的函数，称之为“adder”。把这些“adder”采用符合直觉的方式去复合，例如`adder5`与`adder7`的复合式`adder12`。因此“adder”的复合等同于加法规则，现在可以用函数的复合来代替加法运算。此外，还有一个面向中立元素0的`adder0`，它不会改变任何东西，因此它是自然数集上的恒等函数。

    > 每个范畴化的幺半群都会定义一个唯一的伴随二元运算的集合的幺半群，事实上总是能够从单个对象的范畴中抽出一个集合，这个集合是态射的集合。

```haskell
-- Haskell

-- 定义 `Monoid` 类型类
class Monoid m where
    empty :: m
    append :: m -> m -> m   -- currying form

-- 将 `String` 声明为一个 `Monoid` ，提供 `empty` `append` 的实现
instance Monoid String where
    empty = ""
    append = (++)      -- 中缀运算符用括号包住后，就转化为接受两个参数的函数
```

```fsharp
// F#

// F# 中不存在 类型类/type class 的概念，参考Scala版本尝试给出了使用接口进行的定义
module Monoid =
    open System         // `String`类存在于`System`名称空间下，或者可以直接用F#为之给出的类型别名：`string`，此处是为了形式一致
    type Monoid<'T> =   // F# 中定义泛型类型时，写法可以是`type 'T Monoid`或`type Monoid<'T>`
        abstract member Zero: 'T
        abstract member BiOp: ('T -> 'T -> 'T)      // 注意，此处给出`BiOp`的类型`('T -> 'T -> 'T)`时带上了括号

    let stringMonoid = {    // 使用对象表达式，直接实例化一个实现了接口的匿名类对象。
        new Monoid<String> with
            member _.Zero = ""
            member _.BiOp = (+)
        }

    type StringMonoid =     // 似乎基于对接口的实现来定义一个新的类并不合适，似乎不太符合"Monoid"的意义
        interface Monoid<String> with    // 也可以写作`String Monoid`
            member _.Zero = ""
            member _.BiOp = (+)

    // ---------------------------

    // F#是一门混合范式语言，一般是函数式编程范式优先。涉及到与面向对象范式混合编程时，存在一些注意事项
    // 在函数式世界里，函数是一等公民，可以作为值来用。
    //      `fun x -> x + 1` 是一个匿名函数值，与数字`1` 字符串`"abc"`的身份没有高低之分
    //      `let add1 = fun x -> x + 1` 是在将“函数值”绑定到名称`add1`上，与`let a = 1`在做的事情没有区别
    //      `let add' = add1` 是在将`add1`的值绑定到名称`add'`上，与`let b = a`行为类似
    // 面向对象的世界里函数/方法并非一等公民，是有特殊处理的
    type I<'T, 'R> =                    // 定义一个泛型接口
        abstract member M1: 'T -> 'R    // 没有括号，这是在定义接受`'T`返回`'R`的函数
        abstract member M2: ('T -> 'R)  // 带上括号，这是在定义`FSharpFunc<'T,'R>`(`'T -> 'R`)类型的只读属性
    type C<'T, 'R>() =                  // 定义一个泛型类型
        let f:'T->'R = failwith "err"   // 私有的函数类型字段
        interface I<'T, 'R> with        // 该类实现泛型接口
            member _.M1 t = f t         // 实现接口中定义的方法，必须显式给出参数。调用时使用`obj.M1(x)`方式
            member _.M2 = f             // 实现接口中定义的属性，只能直接赋函数值。这是`FSharpFunc<'T,'R>`类型的属性，注意与`Func<T,R>`类型不同

    // ---------------------------

    // 使用Monoid实例的时候，似乎可以考虑使用静态解析类型参数来进行约束，而不必要求必须是某个接口的实现 ??
    // 尝试实现失败
    // Constraints: https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/constraints
    // Statically Resolved Type Parameters: https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters
    // Type extensions: https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/type-extensions
    // 静态解析的类型参数: https://docs.microsoft.com/zh-cn/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters
    // 只有在定义时或内部类型扩展(Intrinsic type extensions)给出的成员才是符合静态类型约束的
    // 类型扩展: https://docs.microsoft.com/zh-cn/dotnet/fsharp/language-reference/type-extensions#optional-type-extensions
```

```scala
object Monoid {
    trait Monoid[M] {
        def zero : M
        def biOp : (M, M) => M
    }

    val stringMonoid = new Monoid[String] {
        def zero = ""
        def biOp = _ + _
    }

    class StringMonoid extends Monoid[String] {
        def zero = ""
        def biOp = _ + _
    }
}
```

> 注：概念上 `append = (+)` 与 `append s1 s2 = (+) s1 s2` 是不同的。前者是**Hask**范畴（忽略"Bottom Type"的话则是**Set**）中态射的相等，这样不仅写法简洁，也经常被泛化到其它范畴。后者称为外延相等/extensional equality，陈述的是对任意两个输入，`append` 与 `(+)` 的值是相同的。由于参数的值有时也被称为point（函数$f$在点$x$出的值），外延相等也被称为point-wise相等，未指定参数的函数相等称为point-free相等。