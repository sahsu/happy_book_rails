#Ruby入门

## Hello World

新建一个文件 `hello.rb`

```ruby
puts 'Hello world!'
```

运行，就会看到效果：

```bash
$ ruby hello.rb
```

## 赋值

```ruby
name = "jim"
# => jim
```

## 字符串插值

在Ruby中，我们最好所有的地方都用字符串插值(interpolition) ,避免使用 +　方式．
原因是：对于不同的数据类型，用`+`号时，系统会报错．

使用字符串插值时，记得用双引号．

```ruby
name = "jim"
puts "hi, #{name}!"
# => hi, jim
```

你也可以把它写成：

```ruby
puts "hi, "+ name
# => hi, jim
```

如果用加号，一些时候就会报错：

```ruby
a = 1
puts "a is: " + a
# => 报错

puts "a is: #{a}"
# => a is: 1
```

## 任何语言都通用的 数据类型.

1. String 字符串 "abc"
2. Number (包括了: 整数,小数,long double ...) 数字,  123342342342343.3141234
3. Array.  数组   [1,2,3]
4. Hash   hash.  (dictionary)

```
{
   "name": "dashi",
   "birth": "1982-9-16"
}
```

## 对象和实例 .

对象:  class, object   抽象概念,  例如:   human

实例:  instance.    具体概念.  小王.

小王 是 Human 的一个 instance.

小王有个属性,叫做: "名字",  那么,小王的名字,就可以认为,是 instance varaible.
(实例变量, 只跟实例有关)


## 双引号与单引号

双引号中可以：

- 使用interpolation (字符串插值), 例如  `"banana is #{color}"`
- 使用escape. 例如：　 `"\n"` 可以表示回车

单引号中的内容则不可以使用字符串插值，也不能使用escape的功能．

```
puts '\n'

# => \n
```

## Class 类

跟Java中的概念一样，就是表示一个类．

我们从一个例子来看,　注意代码中的注释：

```ruby
class Apple

  # 这个方法就是在　Apple.new　时自动调用的方法
  def initialize
    # instance variable, 实例变量
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

# 下面开始运行：
red_apple = Apple.new
red_apple.color = 'red'
puts "red_apple.color: #{red_apple.color}"
```

我们来运行这个文件：

```bash
$ ruby apple.rb
# => "red_apple.color: red"
```

上面的例子是java/c风格的. ruby的熟手一般这么写：

```ruby
class Apple
  # 这一句，自动声明了 @color, getter,setter
  attr_accessor 'color'
end
```

## 变量

- 类变量　class variable

例如： `@@name`, 作用域：所有的多个instance 会共享这个变量. 用的很少．

- 实例变量　instance variable

例如： `@color`, 作用域仅在instance之内

- 普通变量： local variable

例如：　`age = 20`, 作用域仅在　某个方法内．

- 全局变量： global variable

例如：`$name = "Jim"`, 作用域在全局． 用的更少．

下面是一个例子：

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

## 方法：类方法(class method)与实例方法(instance method)

用法看这个例子:

```ruby
class Apple
  # 类方法
  def Apple.name
    'apple'
  end

  # 实例方法
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

前面的`apple.rb`例子中，正常的应该写成：

```ruby
class Apple
  attr_accessor :color
end
```

这个　:color 是什么呢？　就是Symbol. 它是不会变化的字符串．

`:name` 等同于：　`"name".to_symbol`

## Hash

```Ruby

# 任何情况下都生效的语法： =>
jim = {
    :name => 'Jim',
    :age => 20
}

# Ruby 1.9之后产生的语法：更加简洁．
jim = {
    name: 'Jim',
    age: 20
}

# 也可以写成：
jim = {}
jim[:name] = 'Jim'
jim[:age] = 20
```

但是，symbol与string是不同的key, 例如：

```bash
a = {:name => 'jim', 'name'=> 'hi'}
a[:name]  #=>  'jim'
a['name'] #=>  'hi'
```

## 条件语句

### if else end 是最常见的

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

### case when end 分支语句

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

### 三元表达式

```ruby
a = 1
puts a == 1 ? 'one' : 'not one'
# => one
```

也可以写成：

```ruby
if a == 1
  puts 'one'
else
  puts 'not one'
end
```

## for, each, loop, while 循环

for 与 each 几乎一样．

例如：

```ruby
[1,2,3].each { |e|
  puts e
}
```

等同于：　

```ruby
for e in [1,2,3]
  puts e
end
```

for 与 each 都可以做循环，但是高手都用each.

区别在于：for 后面的变量，是全局变量，不仅仅存在于```for .. end``` 这个作用域之内．

具体见: http://stackoverflow.com/questions/3294509/for-vs-each-in-ruby

举个例子：

```ruby
for i in [1,2,3]
  puts i
end

# 可以看到，　这里的 i 被错误的识别成了一个全局变量（超出了for 的代码块范围)
puts i  # => 3
```

loop与while是几乎一样的.

```ruby
loop do
  # your code
  break if <condition>
end
```

等同于：

```ruby
begin
  # your code
end while <condition>
```
但是ruby的作者推荐使用loop. 因为可读性更强． 下面是一个例子：

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

## 命名规则

常量: 全都是大写字母．`ANDROID_SYSTEM = 'android'`

变量：如果不算@, @@, $的话，是小写字母开头．下划线拼接．例如: `color`, `age`, `is_created`

class, module: 首字母大写，骆驼表达法： Apple, Human

方法名：　小写字母开头．　可以以问号？ 或者等号结尾，例如： `name`, `created?`, `color=`

## 如何查看API

查看ruby API　很其他的语言差不多．官方文档是：api.ruby-lang.org?
TODO 详细图文

## 如何调试(debug)

- ruby的出错信息, 距离顺序是从上到下，时间顺序是从下到上，出现的．例如：

```ruby
test_class.rb:8:in `extend': wrong argument type Class (expected Module) (TypeError)
  from test_class.rb:8:in `<class:Child>'
  from test_class.rb:7:in `<main>'
```
上面信息中，时间的运行顺序是，先运行　test_class.rb的第７行，再运行到第8行，才出错．
出错信息是  `wrong argument type Class (expected Module) (TypeError)`

- 在调试中，`class instance` 的最外层是`#<>` 的固定格式，前面的Apple表示class名字，`0x00000001f0dad8`是内存的地址．
例如：`#<Apple:0x00000001f0dad8>`


## ::  双冒号

表示:
1. class的 常量
2. 某个命名空间

```
class Interface
  class Apple
    COLOR = 'red'
  end
end

puts Interface::Apple::COLOR
```

rails中：

app/controller/interface/apples_controller的话：

```ruby
class Interface::ApplesController < ApplicationController::Base
  ## 其他代码
end
```

我们在实战中,会有这样的模式:

当访问某个页面的时候,

- 普通人:  /pages
- 管理员:  /admin/pages

在上面的例子中, '/admin' 就是一个非常典型的 "命名空间".  我们也可以叫它: url前缀.

它没有任何意义, 存在的目的,就是为了区别 管理员与普通用户的URL (方便权限的管理)

## block, proc, lambda

几乎是一样的.  都表示代码块儿.

ruby的代码块儿是相比其他传统语言特别强大的功能. 碾压其他传统语言.

例子:

```ruby
[1,2,3].each { |e| puts e }

# 假设student有两个属性:name, age
Student.all.map { |student|
  {
    :name => student.name,
    :aget => student.age
  }
}
```

