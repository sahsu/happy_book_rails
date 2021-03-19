# block, Proc, lambda

block, proc, lambda 都是一段代碼．具體含義這裏不深究．例如：

```
[1,2,3].each do |element|
  puts element
end
```

上面的 `do ... end` 就是一個block . 它接受一個參數：　`element`

以下兩種寫法是等價的:

- each do 寫法：

```ruby
[1, 2, 3].each do |x|
  puts x
end
```
- 大括號寫法：

```ruby
[1, 2, 3].each {|x| puts x}
```

也可以用這個方式來聲明成一個`Proc`:

```ruby
proc = Proc.new {|x| puts x*2}
proc.call(2) # 4
```

也可以聲明成一個lambda：

```ruby
lam = lambda {|x| puts x*2}
lam.call(2) # 4
```

下面三種方式是等價的：

```ruby
[1, 2, 3].each {|x| puts x*2 }
[1, 2, 3].each(&proc)
[1, 2, 3].each(&lam)
```

lambda和proc的兩個重要區別是:

- Proc對象對參數數量檢查不嚴格, lambda對象則要求參數的數量精確匹配
- Proc對象和lambda對象對return關鍵字的處理不一樣

在block 中不允許用return. 如果要返回一個值，直接把它放在最後一行就可以了．例如：

```ruby
result = [1,2,3].map { |e|
  puts "e is: #{e}"
  e * 3
}

# 結果是：
e is: 1
e is: 2
e is: 3
=> [3, 6, 9]
```

下面這樣寫,會報錯:

```ruby
[1,2,3].map { |e|
  return "#{e}#{e}"
}

# => in `block in <main>': unexpected return (LocalJumpError)
```

