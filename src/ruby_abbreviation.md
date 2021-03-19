# Ruby中的縮寫

從其他語言轉過來的同學，在首先接觸Ruby的時候，會快速的瞭解語法（例如５分鐘），但是卻會在語法簡寫上遇到問題．
下面是需要了解的Ruby簡寫的知識：


### 每個函數的最後一行默認是返回值

默認是不需要寫return的，

例如：

```ruby
def color
  'red'  # 等同於:   return 'red'
end
```

### 方法調用的最外面的大括號可以省略。

例如：

```ruby
puts "hihihi"   # 等同於   puts("hihihi")
```

### hash最外面的{} 在大多數情況下可以省略，

如果這個 hash, 是某方法的最後一個參數(不考慮block的話),那麼最外層{} 可以省略

```ruby
Apple.create :name => 'apple', :color => 'red'

#等同於：
Apple.create({:name => 'apple', :color => 'red'})

#等同於hash的另一種寫法： Apple.create name: 'apple', color: 'red'
```

### 調用某個block中的某個方法：

```ruby
Apple.all.each do {  |apple|      apple.name  }
```

等同於：

```ruby
Apple.all.map(&:name)
```

注意：　這個縮寫非常常見．幾乎是Ruby目前語法的標準．

### do ...end 與 { } 幾乎是一樣的.

可以認爲下面兩個代碼相同

```ruby
[1,2,3].each { |e|
  puts e
}

[1,2,3].each do |e|
  puts e
end
```

## block的簡寫

一個方法最多隻有一個參數是 block, 並且永遠是參數的最後一位.

所以：

```ruby
give "我", :what => '咖啡', :count => '2', :unit => '杯' do
  "味道不錯喲!"
end
```

可以看出:

```ruby
give(

  # 第一個參數,是一個 string
  "我",

  # 第二個參數,是個hash
  {
    :what => '咖啡',
    :count => '2',
    :unit => '杯'
  },

  # 這是第三個參數,是一個block. 也是最後一個參數
  do
    "味道不錯喲!"
  end
)
```
