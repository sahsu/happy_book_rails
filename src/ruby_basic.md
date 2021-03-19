#Ruby入門

## Hello World

新建一個文件 `hello.rb`

```ruby
puts 'Hello world!'
```

運行，就會看到效果：

```bash
$ ruby hello.rb
```

## 賦值

```ruby
name = "jim"
# => jim
```

## 字符串插值

在Ruby中，我們最好所有的地方都用字符串插值(interpolition) ,避免使用 +　方式．
原因是：對於不同的數據類型，用`+`號時，系統會報錯．

使用字符串插值時，記得用雙引號．

```ruby
name = "jim"
puts "hi, #{name}!"
# => hi, jim
```

你也可以把它寫成：

```ruby
puts "hi, "+ name
# => hi, jim
```

如果用加號，一些時候就會報錯：

```ruby
a = 1
puts "a is: " + a
# => 報錯

puts "a is: #{a}"
# => a is: 1
```

## 任何語言都通用的 數據類型.

1. String 字符串 "abc"
2. Number (包括了: 整數,小數,long double ...) 數字,  123342342342343.3141234
3. Array.  數組   [1,2,3]
4. Hash   hash.  (dictionary)

```
{
   "name": "dashi",
   "birth": "1982-9-16"
}
```

## 對象和實例 .

對象:  class, object   抽象概念,  例如:   human

實例:  instance.    具體概念.  小王.

小王 是 Human 的一個 instance.

小王有個屬性,叫做: "名字",  那麼,小王的名字,就可以認爲,是 instance varaible.
(實例變量, 只跟實例有關)


## 雙引號與單引號

雙引號中可以：

- 使用interpolation (字符串插值), 例如  `"banana is #{color}"`
- 使用escape. 例如：　 `"\n"` 可以表示回車

單引號中的內容則不可以使用字符串插值，也不能使用escape的功能．

```
puts '\n'

# => \n
```

## Class 類

跟Java中的概念一樣，就是表示一個類．

我們從一個例子來看,　注意代碼中的註釋：

```ruby
class Apple

  # 這個方法就是在　Apple.new　時自動調用的方法
  def initialize
    # instance variable, 實例變量
    @color
  end

  # getter 方法
  def color
    return @color
  end

  # setter 方法
  def color= color
    @color = color
  end

  # private 下面的方法都是私有方法
  private
  def i_am_private
  end
end

# 下面開始運行：
red_apple = Apple.new
red_apple.color = 'red'
puts "red_apple.color: #{red_apple.color}"
```

我們來運行這個文件：

```bash
$ ruby apple.rb
# => "red_apple.color: red"
```

上面的例子是java/c風格的. ruby的熟手一般這麼寫：

```ruby
class Apple
  # 這一句，自動聲明瞭 @color, getter,setter
  attr_accessor 'color'
end
```

## 變量

- 類變量　class variable

例如： `@@name`, 作用域：所有的多個instance 會共享這個變量. 用的很少．

- 實例變量　instance variable

例如： `@color`, 作用域僅在instance之內

- 普通變量： local variable

例如：　`age = 20`, 作用域僅在　某個方法內．

- 全局變量： global variable

例如：`$name = "Jim"`, 作用域在全局． 用的更少．

下面是一個例子：

```ruby
class Apple

  @@from = 'China'

  def color= color
    @color = color
  end

  def color
    return @color
  end

  def get_from
    @@from
  end

  def set_from from
    @@from = from
  end
end

red_one = Apple.new
red_one.color = 'red'
puts red_one.color
# => 'red'

red_one.set_from 'Japan'
puts red_one.get_from
# => 'Japan'

green_one = Apple.new
green_one.color = 'green'
puts green_one.color
# => 'green'

puts green_one.get_from
# => 'Japan'
```

## 方法：類方法(class method)與實例方法(instance method)

用法看這個例子:

```ruby
class Apple
  # 類方法
  def Apple.name
    'apple'
  end

  # 實例方法
  def color
    'red'
  end
end

Apple.new.color
# => red

Apple.name
# => apple
```

## Symbol

前面的`apple.rb`例子中，正常的應該寫成：

```ruby
class Apple
  attr_accessor :color
end
```

這個　:color 是什麼呢？　就是Symbol. 它是不會變化的字符串．

`:name` 等同於：　`"name".to_symbol`

## Hash

```Ruby

# 任何情況下都生效的語法： =>
jim = {
    :name => 'Jim',
    :age => 20
}

# Ruby 1.9之後產生的語法：更加簡潔．
jim = {
    name: 'Jim',
    age: 20
}

# 也可以寫成：
jim = {}
jim[:name] = 'Jim'
jim[:age] = 20
```

但是，symbol與string是不同的key, 例如：

```bash
a = {:name => 'jim', 'name'=> 'hi'}
a[:name]  #=>  'jim'
a['name'] #=>  'hi'
```

## 條件語句

### if else end 是最常見的

```ruby
a = 1
if a == 1
  puts "a is 1"
elsif a == 2
  puts "a is 2"
else
  puts "a is not in [1,2]"
end
```

### case when end 分支語句

例如：

```ruby
a = 1
case a
  when 1 then puts "a is 1"
  when 2 then puts "a is 2"
  when 3,4,5 then puts "a is in [3,4,5]"
  else puts "a is not in [1,2,3,4,5]"
end
```

### 三元表達式

```ruby
a = 1
puts a == 1 ? 'one' : 'not one'
# => one
```

也可以寫成：

```ruby
if a == 1
  puts 'one'
else
  puts 'not one'
end
```

## for, each, loop, while 循環

for 與 each 幾乎一樣．

例如：

```ruby
[1,2,3].each { |e|
  puts e
}
```

等同於：　

```ruby
for e in [1,2,3]
  puts e
end
```

for 與 each 都可以做循環，但是高手都用each.

區別在於：for 後面的變量，是全局變量，不僅僅存在於```for .. end``` 這個作用域之內．

具體見: http://stackoverflow.com/questions/3294509/for-vs-each-in-ruby

舉個例子：

```ruby
for i in [1,2,3]
  puts i
end

# 可以看到，　這裏的 i 被錯誤的識別成了一個全局變量（超出了for 的代碼塊範圍)
puts i  # => 3
```

loop與while是幾乎一樣的.

```ruby
loop do
  # your code
  break if <condition>
end
```

等同於：

```ruby
begin
  # your code
end while <condition>
```
但是ruby的作者推薦使用loop. 因爲可讀性更強． 下面是一個例子：

```ruby
a = [2,1,0,-1,-2]
loop do
  current_element = a.pop
  puts current_element
  break if current_element < 0
end

# => 2
# => 1
# => 0
```

## 命名規則

常量: 全都是大寫字母．`ANDROID_SYSTEM = 'android'`

變量：如果不算@, @@, $的話，是小寫字母開頭．下劃線拼接．例如: `color`, `age`, `is_created`

class, module: 首字母大寫，駱駝表達法： Apple, Human

方法名：　小寫字母開頭．　可以以問號？ 或者等號結尾，例如： `name`, `created?`, `color=`

## 如何查看API

查看ruby API　很其他的語言差不多．官方文檔是：api.ruby-lang.org?
TODO 詳細圖文

## 如何調試(debug)

- ruby的出錯信息, 距離順序是從上到下，時間順序是從下到上，出現的．例如：

```ruby
test_class.rb:8:in `extend': wrong argument type Class (expected Module) (TypeError)
  from test_class.rb:8:in `<class:Child>'
  from test_class.rb:7:in `<main>'
```
上面信息中，時間的運行順序是，先運行　test_class.rb的第７行，再運行到第8行，纔出錯．
出錯信息是  `wrong argument type Class (expected Module) (TypeError)`

- 在調試中，`class instance` 的最外層是`#<>` 的固定格式，前面的Apple表示class名字，`0x00000001f0dad8`是內存的地址．
例如：`#<Apple:0x00000001f0dad8>`


## ::  雙冒號

表示:
1. class的 常量
2. 某個命名空間

```
class Interface
  class Apple
    COLOR = 'red'
  end
end

puts Interface::Apple::COLOR
```

rails中：

app/controller/interface/apples_controller的話：

```ruby
class Interface::ApplesController < ApplicationController::Base
  ## 其他代碼
end
```

我們在實戰中,會有這樣的模式:

當訪問某個頁面的時候,

- 普通人:  /pages
- 管理員:  /admin/pages

在上面的例子中, '/admin' 就是一個非常典型的 "命名空間".  我們也可以叫它: url前綴.

它沒有任何意義, 存在的目的,就是爲了區別 管理員與普通用戶的URL (方便權限的管理)

## block, proc, lambda

幾乎是一樣的.  都表示代碼塊兒.

ruby的代碼塊兒是相比其他傳統語言特別強大的功能. 碾壓其他傳統語言.

例子:

```ruby
[1,2,3].each { |e| puts e }

# 假設student有兩個屬性:name, age
Student.all.map { |student|
  {
    :name => student.name,
    :aget => student.age
  }
}
```

