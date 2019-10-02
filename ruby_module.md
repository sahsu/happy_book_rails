# Module

module有两个典型的作用:
- 提供namespace(开源代码中大量使用，比如Rails项目中使用的各种gem)
- 取消多重继承代码的结构混乱(在ruby中，class可以认为是一个加强的module)

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

## self
在ruby中，self表示当前作用域的　method caller. 可以认为是调用方法的对象．例如, ：

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
