# Module

Module用來把各種方法提煉出來,供其他 class 引用.

基本作用：

- 提供namespace(開源代碼中大量使用，比如Rails項目中使用的各種gem)
- 取消多重繼承代碼的結構混亂(在ruby中，class可以認爲是一個加強的module)

實際的用法：

1. 不能被new
2. 可以被include
3. module中的 self.xx方法可以被直接調用
4. module中的普通方法,需要被某個class include之後, 由對應的class調用.

簡單的使用方式爲:

一個典型的module爲：

```ruby
module Fruit
  def self.test_method
    "this is a test method in module"
  end

  def taste
    'good'
  end
end
```

`include`用來包含一個module，module裏面的普通方法會變成class裏面的instance method:

```ruby
class Apple
  include Fruit
end

puts Apple.new.taste
# => good

```

`extend`把Module中的普通方法方法變成 "class method"

```ruby
class Orange
  extend Fruit
end

puts Orange.taste
# => good
```

## Class的繼承

```ruby
class Parent
  def family_name
    'Green'
  end
end

class Child < Parent
end

puts Child.new.family_name

# => Green
```

## Mixed In 混合

Mixed in 是一種比繼承和interface/implementation更加優秀的存在. 非常直觀, 而且很好的重用了代碼.

我們來定義兩個class,  `Student` 和 `Teacher`. 下面可以看到, 這兩個類,通過`include`, 都繼承了`Tool module`的方法: `show_tip`:

```ruby
require './tool.rb'

class Student
  include Tool
end

Student.new.show_tip  # => "this is the tip"

class Teacher
  include Tool
end

Teacher.new.show_tip  # => "this is the tip"
```

不要小瞧這個能力, 它用非常簡潔的方式, 完成了其他語言難以完成的事情.

## 元編程初探

所有的Ruby程序員都要學習這本書: ＜＜Ruby元編程＞＞ https://item.jd.com/11742255.html

元編程是一種特別強大的功能. 舉個例子:

```ruby
def say_hi_to_jim
  "hi, jim"
end
def say_hi_to_li_lei
  "hi, li_lei"
end
def say_hi_to_han_mei_mei
  "hi, han_mei_mei"
end
```

這三個方法, 也可以這樣寫:

```ruby
['jim', 'li_lei', 'han_mei_mei'].each do |name|
  define_method "say_hi_to_#{name}" do
    puts "hi, #{name}"
  end
end

```

然後就可以調用了:

```ruby
say_hi_to_jim  # => 'hi, jim'
```

每個語言都多少有些動態改變代碼邏輯的能力, 但是Ruby的元編程能力是最強的. 用起來也是最得心應手的.

ruby 元編程可以讓我們做到其他傳統語言無法做到的事. 大家務必知道他的重要性.

可以先不學, 但是要知道它的作用.

Rails框架之所以能這麼強大, 全靠ruby的元編程能力.


## Ruby中的self

在ruby中，self表示當前作用域的`method caller`, 可以認爲是調用方法的對象．例如, ：

```ruby
temp_string = '1,2,3'

# 下面的`temp_string`就是一個caller
temp_string.split ','
```

爲了方便記憶，只要見到　`a.b()` 這個形式，就可以說 `a` 就是 "method caller", 在方法`b`中，
self就指代"a", 例如，下面的例子，我們可以把self打印出來：

```ruby
class Apple
  def print_self
    puts self.inspect
  end
end

Apple.new.print_self
# => #<Apple:0x00000001f0dad8>
```

上面的　` #<Apple:0x00000001f0dad8>`就是 Apple.new　出來的實例．　

