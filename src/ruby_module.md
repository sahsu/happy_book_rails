# Module

Module用来把各种方法提炼出来,供其他 class 引用.

基本作用：

- 提供namespace(开源代码中大量使用，比如Rails项目中使用的各种gem)
- 取消多重继承代码的结构混乱(在ruby中，class可以认为是一个加强的module)

实际的用法：

1. 不能被new
2. 可以被include
3. module中的 self.xx方法可以被直接调用
4. module中的普通方法,需要被某个class include之后, 由对应的class调用.

简单的使用方式为:

一个典型的module为：

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

`include`用来包含一个module，module里面的普通方法会变成class里面的instance method:

```ruby
class Apple
  include Fruit
end

puts Apple.new.taste
# => good

```

`extend`把Module中的普通方法方法变成 "class method"

```ruby
class Orange
  extend Fruit
end

puts Orange.taste
# => good
```

## Class的继承

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

Mixed in 是一种比继承和interface/implementation更加优秀的存在. 非常直观, 而且很好的重用了代码.

我们来定义两个class,  `Student` 和 `Teacher`. 下面可以看到, 这两个类,通过`include`, 都继承了`Tool module`的方法: `show_tip`:

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

不要小瞧这个能力, 它用非常简洁的方式, 完成了其他语言难以完成的事情.

## 元编程初探

所有的Ruby程序员都要学习这本书: ＜＜Ruby元编程＞＞ https://item.jd.com/11742255.html

元编程是一种特别强大的功能. 举个例子:

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

这三个方法, 也可以这样写:

```ruby
['jim', 'li_lei', 'han_mei_mei'].each do |name|
  define_method "say_hi_to_#{name}" do
    puts "hi, #{name}"
  end
end

```

然后就可以调用了:

```ruby
say_hi_to_jim  # => 'hi, jim'
```

每个语言都多少有些动态改变代码逻辑的能力, 但是Ruby的元编程能力是最强的. 用起来也是最得心应手的.

ruby 元编程可以让我们做到其他传统语言无法做到的事. 大家务必知道他的重要性.

可以先不学, 但是要知道它的作用.

Rails框架之所以能这么强大, 全靠ruby的元编程能力.


## Ruby中的self

在ruby中，self表示当前作用域的`method caller`, 可以认为是调用方法的对象．例如, ：

```ruby
temp_string = '1,2,3'

# 下面的`temp_string`就是一个caller
temp_string.split ','
```

为了方便记忆，只要见到　`a.b()` 这个形式，就可以说 `a` 就是 "method caller", 在方法`b`中，
self就指代"a", 例如，下面的例子，我们可以把self打印出来：

```ruby
class Apple
  def print_self
    puts self.inspect
  end
end

Apple.new.print_self
# => #<Apple:0x00000001f0dad8>
```

上面的　` #<Apple:0x00000001f0dad8>`就是 Apple.new　出来的实例．　

