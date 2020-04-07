---
author: mxtao
date: 2020-04-07
---

# 范畴论

## 一些概念

+ 范畴

    一些事物（称为对象/object）及事物之间的关系（称为态射/morphism）构成一个范畴。

    > 编程语言中，一般是类型体现为对象，函数体现为态射。

+ 复合

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
    f : A -> B      // 接受A返回B的函数
    g : B -> C      // 接受B返回C的函数
    // 用内置操作符`>>` `<<`进行复合，前者从左向右，后者从右向左
    f >> g          // 从左向右复合
    g << f          // 从右向左复合
    ```

    ```scala
    // Scala
    f : A => B
    g : B => C
    // 用`Function1`特质的`compose`方法进行复合，从右向左
    // 注： (仅`Function1`特质定义了此方法，换言之，仅单参数列表、单参数函数才能进行复合)
    g compose f     // 方法作为中缀操作符形式
    g.compose(f)    // 方法调用形式
    ```

    态射的复合需要满足以下两个性质

    1. 结合律/associative

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
        f : A -> B
        g : B -> C
        h : C -> D
        h << (g << f) == (h << g) << f == h << g << f   // 从右向左复合
        f >> (g >> h) == (f >> g) >> h == f >> g >> h   // 从左向右复合
        ```

        ```scala
        // Scala
        f : A => B
        g : B => C
        h : C => D
        h compose g compose f       // 中缀操作符形式
        h.compose(g.compose(f))     // 方法调用形式
        ```