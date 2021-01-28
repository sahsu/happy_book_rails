# Ruby中的缩写

从其他语言转过来的同学，在首先接触Ruby的时候，会快速的了解语法（例如５分钟），但是却会在语法简写上遇到问题．
下面是需要了解的Ruby简写的知识：


### 每个函数的最后一行默认是返回值

默认是不需要写return的，

例如：

```ruby
def color
  'red'  # 等同于:   return 'red'
end
```

### 方法调用的最外面的大括号可以省略。

例如：

```ruby
puts "hihihi"   # 等同于   puts("hihihi")
```

### hash最外面的{} 在大多数情况下可以省略，

如果这个 hash, 是某方法的最后一个参数(不考虑block的话),那么最外层{} 可以省略

```ruby
Apple.create :name => 'apple', :color => 'red'

#等同于：
Apple.create({:name => 'apple', :color => 'red'})

#等同于hash的另一种写法： Apple.create name: 'apple', color: 'red'
```

### 调用某个block中的某个方法：

```ruby
Apple.all.each do {  |apple|      apple.name  }
```

等同于：

```ruby
Apple.all.map(&:name)
```

注意：　这个缩写非常常见．几乎是Ruby目前语法的标准．

### do ...end 与 { } 几乎是一样的.

可以认为下面两个代码相同

```ruby
[1,2,3].each { |e|
  puts e
}

[1,2,3].each do |e|
  puts e
end
```

## block的简写

一个方法最多只有一个参数是 block, 并且永远是参数的最后一位.

所以：

```ruby
give "我", :what => '咖啡', :count => '2', :unit => '杯' do
  "味道不错哟!"
end
```

可以看出:

```ruby
give(

  # 第一个参数,是一个 string
  "我",

  # 第二个参数,是个hash
  {
    :what => '咖啡',
    :count => '2',
    :unit => '杯'
  },

  # 这是第三个参数,是一个block. 也是最后一个参数
  do
    "味道不错哟!"
  end
)
```
