# block, Proc, lambda

block, proc, lambda 都是一段代码．具体含义这里不深究．例如：

```
[1,2,3].each do |element|
  puts element
end
```

上面的 `do ... end` 就是一个block . 它接受一个参数：　`element`

以下两种写法是等价的:

- each do 写法：

```ruby
[1, 2, 3].each do |x|
  puts x
end
```
- 大括号写法：

```ruby
[1, 2, 3].each {|x| puts x}
```

也可以用这个方式来声明成一个`Proc`:

```ruby
proc = Proc.new {|x| puts x*2}
proc.call(2) # 4
```

也可以声明成一个lambda：

```ruby
lam = lambda {|x| puts x*2}
lam.call(2) # 4
```

下面三种方式是等价的：

```ruby
[1, 2, 3].each {|x| puts x*2 }
[1, 2, 3].each(&proc)
[1, 2, 3].each(&lam)
```

lambda和proc的两个重要区别是:

- Proc对象对参数数量检查不严格, lambda对象则要求参数的数量精确匹配
- Proc对象和lambda对象对return关键字的处理不一样

在block 中不允许用return. 如果要返回一个值，直接把它放在最后一行就可以了．例如：

```ruby
result = [1,2,3].map { |e|
  puts "e is: #{e}"
  e * 3
}

# 结果是：
e is: 1
e is: 2
e is: 3
=> [3, 6, 9]
```

下面这样写,会报错:

```ruby
[1,2,3].map { |e|
  return "#{e}#{e}"
}

# => in `block in <main>': unexpected return (LocalJumpError)
```

