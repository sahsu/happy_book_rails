# migration comments

如果我們的命名良好時，不需要爲數據庫的某個列，某個表增加註釋。

但是實踐證明，大部分的國內開發者都無法100%的保證自己的名字是良好的，
例如：'客廳', '客餐廳',
所以，我們須要爲每個列都增加註釋。

這個 migration comments gem就是爲了解決MYSQL 下這個問題的。

## 使用方法：

```
# Gemfile
gem 'migration_comments'
```

注意：

- 所有的註釋，都添加在migration中!
- 爲列增加註釋時，最好加上個例子。例如：  "該列保存用戶的年紀，例如： 32"

## 爲表和列增加註釋

```ruby
def self.up
  set_table_comment :users, "用戶表"
  set_column_comment :users, :email, "用戶的郵箱，例如： a@b.com"
end
```

也可以單獨指定 comment:
```ruby
def self.up
  change_table :users do |t|
    t.comment "普通用戶表。"
    t.change_comment :email, "用戶的郵箱，必須是happysoft.com的，例如：a@happysoft.cc"
  end
end
```

在新建table時指定comment:
```ruby
def self.up
  create_table :users, :comment => "用戶表" do |t|
    t.string :email, :comment => "email, 例如： a@b.com"
  end
end
```


刪除表或者列中的comment:
```ruby
def self.up
  remove_table_comment :table_name
  remove_column_comment :table_name, :column_name
end
```

把所有的列子綜合起來：
```ruby
def self.up
  change_table :existing_table do |t|
    # 刪除某個表的comment
    t.comment nil
    # 增加一個新列.帶有comment.
    t.string :new_column, :comment => "新列的comment"
    # 刪掉一個列的註釋
    t.change_comment :existing_column, nil
    # 修改一個列的類型, 連帶註釋也刪掉。
    t.integer :another_existing_column, :comment => nil
    # 僅僅修改列，不修改它的註釋
    t.boolean :column_with_comment
  end
end
```
