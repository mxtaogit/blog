---

tags: ['Language Feature']
---

# Higher Kinded Type - 高阶类类型

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
| `fun i -> i % 2 == 0` | `Int -> Bool` | `*` |
| - | `List` | `* -> *` |
| - | `Tuple` | `* -> * -> *` |
| - | `->` | `* -> * -> *` |

> 从左向右提升抽象层次

### Kind In Haskell

Haskell的Kind系统中，$K = * | K \rightarrow K$，它描述了两条规则：`*`/$*$是所有数据类型的kind；`* -> *`/$* \rightarrow *$是一元类型构造器的kind，接受一个kind然后给出一个kind。

确实有值的类型才是算作具体类型，或者叫恰当类型。例如，`4`是`Int`类型的值、`[1, 2, 3]`是`[Int]`类型的值、`fun i -> i % 2 == 0`是`Int -> Bool`类型的值、`fun x -> fun y -> x % y == 0`是`Int -> Int -> Bool`类型的值。这些类型的kind都是`*`。

一个类型构造器接受一个或多个类型参数，当接受了足够的类型参数之后便产生了一个新类型(类型构造支持基于currying的偏应用)。例如，`[]`/`List`接受一个类型参数，这个类型参数指出了内部元素的类型，因此`[Int]`/`[Bool]`/`[[Int]]`都是对于`[]`的正确应用，`[]`的kind是`* -> *`，`Int`/`Bool`/`[Int]`的kind是`*`，将之应用到`[]`便得到`[Int]`/`[Bool]`/`[[Int]]`，这些结果类型的kind是`*`。同理，二元组类型构造器`(,)`的kind是`* -> * -> *`，三元组类型构造器`(,,)`的kind是`* -> * -> * -> *`

## HKT Usage

静态类型语言中，类型系统来保证值的使用安全性，kind系统是来保证类型的使用安全性。

主流编程语言中提供的一般是一阶参数化多态(first-order parametric polymorphism)，这一功能一般称为泛型(generic)。泛型能对类型进行抽象并进行静态检查，但无法对类型构造器进行抽象，进而无法保证这方面类型安全(不支持HKT的话也写不出来，因为编译器不接受这样的代码，只能舍弃抽象，从而导致代码重复)。

```scala
// ---------- Version 1 ----------
trait Iterable[T] {
    def filter(p: T => Boolean): Iterable[T]
    def remove(p: T => Boolean): Iterable[T] = filter(x => !p(x))
}

trait List[T] extends Iterable[T] {
    def filter(p: T => Boolean): List[T] = ???
    override def remove(p: T => Boolean): List[T] = filter(x => !p(x))
}
```

```scala
// ---------- Version 2 ----------
trait Iterable[T, Container[_]] {
    def filter(p: T => Boolean): Container[T]
    def remove(p: T => Boolean): Container[T] = filter(x => !p(x))
}

trait List[T] extends Iterable[T, List]
```

## HKT in Programming

```haskell
-- Functor in Haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b

-- data Maybe a = Nothing | Just a
instance Functor Maybe where
    fmap _ Nothing = Nothing
    fmap f (Just x) = Just (f x)

-- data List a = Nil | Cons a (List a)
instance Functor List where
    fmap _ Nil = Nil
    fmap f (Cons x xs) = Cons (f x) (fmap f xs)

-- `(->)` is a type constructor. `(->) r a` => `r -> a`
-- here: `fmap :: (a -> b) -> (r -> a) -> (r -> b)`
instance Functor ((->) r) where
    fmap f g = f . g
```

```scala
// Functor in Scala
trait Functor[F[_]] {
    def fmap[A, B](f: A => B)(fa: F[A]): F[B]
}

object OptionFunctor extends Functor[Option] {
    def fmap[A, B](f: A => B)(a: Option[A]): Option[B] = {
        a match {
            case None => None
            case Some(x) => Some(f(x))
        }
    }
}

object ListFunctor extends Functor[List] {
    def fmap[A, B](f: A => B)(list: List[A]): List[B] = {
        list match {
            case Nil => Nil
            case head :: tail => f(head) :: fmap(f)(tail)
        }
    }
}

class FunctionFunctor[R] extends Functor[({type λ[A] = R => A})#λ] {
    def fmap[A, B](f: A => B)(g: R => A): R => B = {
        f compose g
    }
}
```

分析以上代码，定义函子`Functor`用到了参数`f`/`F[_]`，该参数是个类型构造器，其kind便是`* -> *`，于是函子`Functor`的kind便是`(* -> *) -> *`，这里便是kind的“高阶”所在。此外要注意函数类型构造`(->)`，对于其返回类型呈(协变)函子性，因此可以固定函数参数类型为`r`/`R`，然后可实现`r -> ?`/`R => ?`函子。

[Generics of a Higher Kind](https://adriaanm.github.com/files/higher.pdf)解释了Scala对于HKT的设计及应用演示，论文中给出了一个更具实用意义的例子，通过对`Iterable`基础类库的设计和实现，演示了HKT存在的必要性（上文已简要演示）。此外也简要解释了Scala的“implicit”设计理念，该设计以另一种方式提供了Haskell的Type Class提供的特设多态(ad-hoc polymorphism)功能

Scala的Kind System中，kind还附带着上下界、可变性信息，以此来保证

---

## 相关链接

Scala语言对此的设计：

[Higher Kinded Types in typescript](https://www.thesoftwaresimpleton.com/blog/2018/04/14/higher-kinded-types)

[Higher Kinded Types in F#](https://robkuz.github.io/Higher-kinded-types-in-fsharp-Intro-Part-I/)

[Higher-rank and higher-kinded types](https://www.stephanboyer.com/post/115/higher-rank-and-higher-kinded-types)

关于对F#添加该功能的讨论：

[Simulate higher-kinded polymorphism](https://github.com/fsharp/fslang-suggestions/issues/175)

[Scala类型系统——高级类类型(higher-kinded types)](https://my.oschina.net/Barudisshu/blog/690595)

[高阶类型 Higher Kinded Type](https://zhuanlan.zhihu.com/p/29021140)
