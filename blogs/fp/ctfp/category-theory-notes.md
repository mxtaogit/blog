---
author: mxtao
date: 2020-04-07
---

# 范畴论

## 一些概念

+ 范畴 / Category

    一些事物（称为对象/object）及事物之间的关系（称为态射/morphism）构成一个范畴。

    > 编程语言中，一般是类型体现为对象，函数体现为态射。

+ 复合 / Composition

    范畴的本质是复合，或者说复合的本质是范畴。若有从对象A到对象B的态射，也有从对象B到对象C的态射，那么必定存在从对象A到对象C的复合态射。

    数学中，一般以 $g \circ f$ 表示函数复合（复合顺序从右向左，即 $g \circ f = \lambda x.g \lparen f \lparen x \rparen \rparen$，可读作“g after f”）。下以几种函数式编程语言进行复合思想的演示

    ```haskell
    -- Haskell
    f :: A -> B     -- 接受A返回B的函数
    g :: B -> C     -- 接受B返回C的函数
    -- 用`.`符进行复合，同数学写法一致，从右向左
    g . f           -- f g 复合，其签名 `A -> C`
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