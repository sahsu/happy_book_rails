# Model 入门

## 数据持久层

简单的说, 持久层就是对数据库直接查询操作的封装。

```
Ruby代码  <===>  持久层  <===> 数据库SQL语句
```

## 从例子来看持久层

在Ruby中，使用ActiveRecord作为持久层。

```
Book.all
```

- `Book` 它是个model.  它映射到了 books 表。
- `Book.all`,  就会被Rails的持久层的机制，转换成一段SQL语句：

```
select * from books;
```

然后，Rails的持久层，再把上面SQL的结果转换成："ruby 对象" 的格式。

## 数据库与持久层

数据库：

- mysql:  是一个文件。 对于ubuntu, 默认放在： /var/lib/mysql/数据库名下面，例如：

```
/var/lib/mysql/me/students.frm
/var/lib/mysql/me/students.ibd
```

文件放在硬盘上。

## 持久层的巨大作用：为了一统(数据操作的)天下

例如: 不同数据库对于分页的操作。

如果用MYSQL：

```
select ... from ... order by id limit(100) offset(2000)
```

oracle: 写法就变了：

```
select ... from ... order by id limit(100) top(2000)
```

ms sql server: 写法又变了：

```
select ... from ... order by id between 2000 and 2100
```

其他的： postgres, ... 都不一样。

所以，想兼容数据库，那就是一场噩梦。

（例如： mysql支持 `select ... from (select ... from ... )` 这样的嵌套 select,  其他好多数据库就不支持）

市面上， 根本找不到 熟悉所有数据库的人。 而且各个数据库的“方言(dialact )“ 都不一样。

十年以前的环境，比现在的还糟糕。（当年作java都没现在多。）

所以：持久层最大的卖点：

学好一个持久层， 可以操作所有数据库。

例如： 学好hibernate/Rails ActiveRecord, 可以在所有数据库上操作。

而且持久层生成的代码，就是专家级别的。(持久层在生成代码时会自动作优化。)

下面是持久层把 代码 转换成SQL语句的例子:

`City.first`:

对应的SQL:

```
SELECT  `cities`.* FROM `cities`   ORDER BY `cities`.`id` ASC LIMIT 1
```


`City.first.airport_managers`:

对应的SQL:

```
SELECT  `cities`.* FROM `cities`   ORDER BY `cities`.`id` ASC LIMIT 1
SELECT `airport_managers`.* FROM `airport_managers`  WHERE `airport_managers`.`city_id` = 1
```

`City.first.airport_managers.count`

对应的SQL:

```
SELECT  `cities`.* FROM `cities`   ORDER BY `cities`.`id` ASC LIMIT 1
SELECT COUNT(*) FROM `airport_managers`  WHERE `airport_managers`.`city_id` = 1
```

可以看出， 生成的SQL，格式及其严谨，该有的 \` 都有。而且， 该大写的都大写。

# 下面开始 正式学习 CRUD:

先创建一个表：  `books`

4.1 新建一个migration
```
$ bundle exec rails g migration create_books
      invoke  active_record
      create    db/migrate/20160926041205_create_books.rb
```

4.2 为这个migration增加内容:

```
def change
  create_table :books do |t|
    t.string :author
    t.string :title
    t.timestamp
  end
end

```

4.3 运行migrate:
```
$ bundle exec rake db:migrate
== 20160926041205 CreateBooks: migrating ======================================
-- create_table(:books)
   -> 0.0030s
== 20160926041205 CreateBooks: migrated (0.0031s) =============================
```

4.4 创建model:

```
# app/models/book.rb
class Book < ActiveRecord::Base
end
```

4.5 进入到控制台

说明:
- 所有 `irb>` 开头的代码,都表示本行从 rails console中敲入 , 例如： `irb(main):001:0>`
- 所有 `=>` 表示运行结果。

```
$ bundle exec rails console
```

就可以进入到控制台, 输入`Book.connection` 就可以连接并操作数据库了:

```
Loading development environment (Rails 4.1.6)
irb(main):001:0> Book
=> Book (call 'Book.connection' to establish a connection)
irb(main):002:0> Book.connection
```

接下来,我可以创建一个book, author为 王博士

```
irb> book = Book.create :author => '王博士'
```

```
sqlite> select * from books;
1|十万个为什么|王博士
```

```
irb>book = Book.first
irb>book.title = '二十万个为什么'
irb>book.save
```

可以看到, 上面的代码,被转换成了下面的SQL语句:
```
   (0.2ms)  begin transaction
  SQL (0.5ms)  UPDATE "books" SET "title" = ? WHERE "books"."id" = 1  [["title", "二十万个为什么"]]
   (173.7ms)  commit transaction
```

删掉该`book`:

```
irb> book.delete
  SQL (52.4ms)  DELETE FROM "books" WHERE "books"."id" = 1
=> #<Book id: 1, title: "二十万个为什么", author: "王博士">
```

插入100条语句：

```
irb> (1..100).each  { |e|  Book.create :title => "#{e}个为什么" }
```

会有100条SQL被转换出来,并且被执行.

查询：

```
irb> Book.where('title like "5%"')
  Book Load (0.6ms)  SELECT "books".* FROM "books"  WHERE (title like "5%")
```

```
Book.where('title like "5%"').order('title desc') # 根据title倒序
```

## find 查询

### 1. 根据id 查询, 获得一个数据

```
# 搜索 id = 2 的User
User.find(2)
```

假设一个表users, 有两个属性: name, age, 我们就可以使用find 来查询.

例如:

```
# 搜索 name = '小王'
User.find_by_name('小王')

# 搜索 name = '小王' , 并且 age = 18 的记录.
User.find_by_name_and_age('小王', 18)

# 或者
User.find_by_age_and_name(18, '小王')
```

得到的结果, 是单数.

## find 与 where 的区别

find 在3.0 之前的版本用的最普遍.
到 3.0之后,往往被where 取代.

根据查询id 直接用 find(2).
查询多个数据的话, 往往用where 更加合适一些.


find 得到的都是单数
where 得到的都是复数.


### TODO where方法, 能智能判断执行顺序.

### where 方法有时候是不执行的.

where 非常智能, 只会在需要执行的时候才会执行.
(例如,我们在某个controller中)


这行代码不会被执行. 因为它的结果没有在任何地方被使用.

```
def index
  Book.where('age = 18')
end
```
下面这行代码会被执行, 因为变量 `@books`被用在了view中.

```
#controller:
def index
  @books = Book.where('age = 18')
end
```

```
# view:
<%= @books %>
```

如果我们需要某个方法, 立刻马上执行的话, 使用`.all`方法.例如:

```
def index
  Book.where('age=18').all
and

```

## 总结: 如何在Rails中实现 数据库的映射呢？

Rails中声明持久层极其简单:

如果你的表，名字叫：  teachers, 那么，就在
app/models 目录下，新建一个rb文件：  teacher.rb

```
class Teacher < ActiveRecord::Base
end
```

然后就可以在Rails框架的任意文件中调用这个 teacher了。

## 军规

model 的名字不能跟项目重名. 例如, 你的项目名字叫"book", 那么 `config/application.rb` 中一定定义了:

```
module Book
  class Application < Rails::Application
  end
end
```

那么, 这个`Book`变量已经被全局范围内定义了,
任何变量都不能叫做这个 `Book`.

# 作业：

创建一个rails项目, 连接到本地的mysql， 本地mysql有个表：book，

有两个列： title, author:

1.在console下面，实现book表的增删改查。

  1.1 新建一个文件, app/models/book.rb
  1.2 操作,分别试试 book的 crud.

2.在Rails的action里面，实现book表的增删改查。

例如：

2.1 用户访问 `/books/create_a_book`， 数据库 books表中就会出现一条记录（title: "三体", author: "大刘"），页面显示结果： “操作成功”

2.2 用户访问 `/books/update_the_book`, 数据库的 books表的第一条记录，的title，就会变成： “十万个为什么”.  页面显示结果： “操作成功"

2.3 用户访问 `/books/search_the_book`, 数据库的books表，会查询：  author=大刘 的记录。页面显示结果：   找到1/0个结果。

2.4 用户访问 `/books/delete_the_book`, 会删除数据库books表中的第一条记录。 页面显示结果： “操作成功”

