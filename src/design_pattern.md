# 繼承， interface 與mix-in

## 繼承
它們都是面向對象的一些概念。

大學剛入學，都要學C/C++。 有概念，叫繼承。

例如：

人 是 生物。

class 生物

end

class 人 extends 生物
end

這樣的話，通過繼承， 人 就具備了 生物的 所有屬性，方法。

C 語言：  可以多重繼承。

人 又能繼承 哺乳動物， 又能繼承 素食動物。

繼承缺點： 繼承的多了，特別容易複雜。

事實上， java / oc 是不允許多重繼承的。

## interface

爲了彌補 不能多重繼承的缺點， 以及一些其他語法上的需要， 出現了interface

設計模式 98年左右出現， 經典的設計模式，有24種， 設計模式裏面，大量的使用了interface.
因爲 interface 可以被多重 實現。

例如：

interface Fruit { }
interface GreenObject{ }
interface SweetObject{ }


那麼我就可以聲明一個class, 同時實現這三個接口。

class 綠葡萄 implements Fruit, GreenObject, SweetObject

從面向對象的角度出發。 這樣設計， 很精巧。

所以，在傳統語言（java, c, ... )中， 設計模式，大行其道。

缺點：

1. 設計模式很精巧， 各種多重implementation 也是被用的特別廣泛。這是一種：語法糖。
個人感覺：  我們去醫院， 被打一針， 疼的嗷嗷哭。 家長給個糖吃。

編程之路一路走來各種虐心，最後，使用設計模式，感覺稍微好一點點。
總體： 還是感覺吃了大虧。

2. 設計模式，特別不直觀。 每個模式，都要跟語言的語法掛鉤。 如果你不瞭解那門語言，
就用不好設計模式。

3. 在現代語言中，特別是 支持block的語言中（ ruby, javascript, python ) 設計模式，幾乎用不到。

同理， 現代語言，認爲 interface 是多餘的。


## mix-in

1. 定義一些高度抽象的module. （模塊）
2. 一個class, 可以 包含（include) 多個module.

跟多重繼承有些相似，但是有很大區別。  不會像多重繼承那樣，把對象給弄亂了。

module Fruit
  def can_eat?
    true
  end
end

module GreenObject
  def color
    'green'
  end
end

class Apple
  include Fruit
  include GreenObject
end


green_apple = Apple.new
green_apple.color  # => 'green'






## 設計模式

30年以前, 那時候的主流語言: c, vb, 彙編.

操作非常底層, 非常原始. 甚至一些語言, 沒有循環的語法.
只有 go-to .  通過go-to ,來實現循環的目的.

例如:  我們希望對一個數組,做遍歷.  現在這樣寫:

```
[1,2,3].each do |e|
   puts e
end
```

之前是:

```
for .. each
end
```

再往前:

```
a = [1,2,3]

for( i = 0 ; i < a.length; i++){

}
```

再往前:

```
a = [1,2,3]
i = 0
while(i < a.length ) {
  System.out.println("e is: " + e);
  i ++;
}

```

再往前:  (更不好理解了)

```
   int a = 10;

   /* do loop execution */
   LOOP:do {

      if( a == 15) {
         /* skip the iteration */
         a = a + 1;
         goto LOOP;
      }

      printf("value of a: %d\n", a);
      a++;

   }while( a < 20 );

```

## 痛點:

1. 大家的代碼,一不小心,就寫的特別亂.
2. 代碼不好讀.

所以,一些老手, 慢慢的,就發展出了,一些面對特定問題的固定的解決寫法.
我們管這個叫"模式".  (在國外, pattern, 是一個建築工程師, 首次提出來的.
alexandar(?) )

跟今天的 按照習俗來編程是一樣的.

經典的設計模式. <<Design patterns>> , 作者4個人. Gang of Four.

設計模式,最初,只口頭流傳與, 業內的頂級高手. 於是他們四個就做整理.
梳理出 24種設計模式.  包括三大類.

所以, 如果不懂設計模式,就== 不同面向對象編程.

創建類
  Singleton   :
		a = DatabaseTool.getConnection()

	Prototype


  Builder
  Factory
  Factory Builder

行爲類
  Iterator
	Visitor
  Listener
  Command


class EditorCommand

  def redo
	end

  def undo
  end

  def execute
	end

end



  Responsibility Chaining

結構類
  Bridge
  Strategy
  Adapter


MVC: 是一種 "思想". 層面非常高, 非常概括行的"分層思想"


form object 思想:

封裝.  把一個form中零散的20個屬性, 封裝成一個大的對象. 這個對象,就是表單對象.


<form action='/books'>
  <input type='text' name='tit'

</form
