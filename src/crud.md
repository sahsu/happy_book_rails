# Model2 增删改查

本节中，我们只学习Model的基本操作

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

# 正式学习Model的增删改查

说明： 下面的所有代码中，需要同学们输入的只是在  `irb..>` 右侧的内容。例如：

```
irb(main):006:0> book = Book.first
```

其他的文字（例如SQL语句等都是控制台的自动输出)

## 准备工作（修改表结构，创建持久层文件）

4.1 回顾一下，我们前一节通过migration创建了一个表 books, 只有一个列name (这个name 列我们不使用)

4.2 创建一个新的migration, 为这个books表增加内容: author和title列

`$ bundle exec rails g migration add_title_and_author_to_books`

内容如下：
```
class AddTitleAndAuthorToBooks < ActiveRecord::Migration

  def up

    # 增加列：标题
    add_column :books, :title, :string

    # 增加列：作者
    add_column :books, :author, :string
  end

  def down

    # 删除列 books 表中的title
    remove_column :books, :title

    # 删除列 books 表中的author
    remove_column :books, :author
  end
end
```

4.3 运行migrate

```
$ bundle exec rake db:migrate

== 20210130010914 AddTitleAndAuthorToBooks: migrating =========================
-- add_column(:books, :title, :string)
   -> 0.0316s
-- add_column(:books, :author, :string)
   -> 0.0284s
== 20210130010914 AddTitleAndAuthorToBooks: migrated (0.0602s) ================
```

从控制台的日志当中可以看到，books表已经增加了两列。

同时，我们查看MySQL，可以发现books表的内容也发生了改变。

```
mysql> show create table books;
+-------+---------------------------------
| Table | Create Table                                                                                                                                                                                                                            |
+-------+---------------------------------
| books | CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+---------------------------------
1 row in set (0.00 sec)
```

4.4 创建model文件

创建一个文件 `app/models/book.rb`, 内容如下：

```
class Book < ActiveRecord::Base
end
```

在上面的代码中，

- `class Book` 对应数据库的表名`books`
- `< ActiveRecord::Base` 表示该class继承了ActiveRecord, 是一个持久层的类（一定对应一个表）

4.5 进入到控制台

```
$ bundle exec rails console
```

就可以进入到rails console来操作数据库了.

```
Loading development environment (Rails 4.1.6)
irb(main):001:0> Book
=> Book (call 'Book.connection' to establish a connection)
```

## 创建记录

接下来,我可以创建一个book, author为 王博士

```
irb(main):001:0> Book.create author: '王博士'
```

可以看到, 上面的代码被转换成了下面的SQL语句并执行：

```
(0.2ms)  BEGIN
SQL (0.6ms)  INSERT INTO `books` (`author`) VALUES ('王博士')
(3.3ms)  COMMIT
```

在MySQL控制台中，也可以看到这个记录了。

```
mysql> select * from books;
+----+------+--------------------+-----------+
| id | name | title              | author    |
+----+------+--------------------+-----------+
|  1 | NULL | NULL               | 王博士    |
+----+------+--------------------+-----------+
1 row in set (0.00 sec)
```

## 修改记录

我们为`id=1`的book 设置`title`, 依次输入：

```
irb(main):006:0> book = Book.first
irb(main):007:0> book.title = '十万个为什么'
irb(main):008:0> book.save
```

可以看到, 上面的代码被转换成了下面的SQL语句并执行：

```
(0.3ms)  BEGIN
SQL (1.8ms)  UPDATE `books` SET `title` = '十万个为什么' WHERE `books`.`id` = 1
(3.2ms)  COMMIT
```

在MySQL控制台中，也可以看到这个记录了。

```
mysql> select * from books;
+----+------+--------------------+-----------+
| id | name | title              | author    |
+----+------+--------------------+-----------+
|  1 | NULL | 十万个为什么       | 王博士    |
+----+------+--------------------+-----------+
1 row in set (0.00 sec)
```

## 删除记录

删掉该`book`

```
irb(main):010:0> a = Book.first
irb(main):011:0> a.delete
```

可以看到, 上面的代码被转换成了下面的SQL语句并执行：

```
SQL (4.3ms)  DELETE FROM `books` WHERE `books`.`id` = 1
```

可以看到，数据库中已经找不到这条记录了。

```
mysql> select * from books;
Empty set (0.00 sec)
```

## where查询语句

## 查询

### 准备10条数据

插入10本书的记录：

```
irb> (1..10).each {|i| Book.create(title:"#{i}万个为什么", author: "#{i}号作者") }
```

会有10条SQL被转换出来,并且被执行. 可以看到mysql中这些数据已经被创建了。

```
mysql> select * from books;
+----+------+-------------------+-------------+
| id | name | title             | author      |
+----+------+-------------------+-------------+
|  3 | NULL | 1万个为什么       | 1号作者     |
|  4 | NULL | 2万个为什么       | 2号作者     |
|  5 | NULL | 3万个为什么       | 3号作者     |
|  6 | NULL | 4万个为什么       | 4号作者     |
|  7 | NULL | 5万个为什么       | 5号作者     |
|  8 | NULL | 6万个为什么       | 6号作者     |
|  9 | NULL | 7万个为什么       | 7号作者     |
| 10 | NULL | 8万个为什么       | 8号作者     |
| 11 | NULL | 9万个为什么       | 9号作者     |
| 12 | NULL | 10万个为什么      | 10号作者    |
+----+------+-------------------+-------------+
10 rows in set (0.00 sec)
```

### find: 根据id 查询

find返回一条记录。

```
irb> book = Book.find(8)
```

可以看到，对应的SQL已经被执行：

```
Book Load (0.6ms)  SELECT  `books`.* FROM `books` WHERE `books`.`id` = 8 LIMIT 1
```

并且在控制台上可以打印出详情：

```
=> #<Book id: 8, name: nil, title: "6万个为什么", author: "6号作者">
```

### find: 根据单个列来查询

使用`find_by_列名`就可以了。

例如：查询 author='9号作者'

```
irb(main):016:0> book = Book.find_by_author('9号作者')
```

可以看到SQL语句：
```
Book Load (0.7ms)  SELECT  `books`.* FROM `books` WHERE `books`.`author` = '9号作者' LIMIT 1
```

并且在控制台上可以打印出详情：
```
=> #<Book id: 11, name: nil, title: "9万个为什么", author: "9号作者">
```

查询 title = '9万个为什么'

```
irb(main):017:0> book = Book.find_by_title('9万个为什么')
```

可以看到SQL语句：
```
Book Load (0.5ms)  SELECT  `books`.* FROM `books` WHERE `books`.`title` = '9万个为什么' LIMIT 1
```

并且在控制台上可以打印出详情：
```
=> #<Book id: 11, name: nil, title: "9万个为什么", author: "9号作者">
```

### 使用where 进行查询

我们绝大部分时候都用where进行查询。where返回的记录是一个数组。

where是ActiveRecord的函数，里面可以包含几乎所有的标准SQL语句的where条件。

例如，查询id = 5的book

```
irb> a = Book.where('id = ?', 5)
```
可以看到，对应的SQL语句被执行，并且返回一个数组。
```
  Book Load (0.7ms)  SELECT `books`.* FROM `books` WHERE (id = 5)
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">]>
```

想要获得第一条记录的话，就可以使用`.first`方法。
```
irb> a.first
=> #<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">
```

也可以进行`like`查询。例如，查询所有标题以`5`开头的Book.

```
irb> Book.where('title like "5%"')
```
或者写成这样：
```
irb> Book.where('title like ?', "5%")
```

可以看到，对应的SQL语句被执行，并且返回一个数组。
```
  Book Load (2.2ms)  SELECT `books`.* FROM `books` WHERE (title like "5%")
=> #<ActiveRecord::Relation [#<Book id: 7, name: nil, title: "5万个为什么", author: "5号作者">]
```

### where 中的or与and

一个where查询中可以包含任意条件的任意嵌套。例如：

如果你的查询中有or 或者and, 直接按照原生SQL的顺序写入到where函数中即可，例如：

例如，查询and条件：

```
> Book.where('title like ? and author like ?', '3万个%', '5号%')
```
可以看到，对应的SQL查询到的内容是空。如下：
```
  Book Load (0.8ms)  SELECT `books`.* FROM `books` WHERE (title like '3万个%' and author like '5号%')
=> #<ActiveRecord::Relation []>
```

再如，查询or条件：

```
> Book.where('title like ? or author like ?', '3万个%', '5号%')
```

可以看到，查到了标题是"3万个" 和作者是"5号作者"的Book:
```
  Book Load (0.6ms)  SELECT `books`.* FROM `books` WHERE (title like '3万个%' or author like '5号%')
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">, #<Book id: 7, name: nil, title: "5万个为什么", author: "5号作者">]>
```

你也可以使用多个`where`方法，等同于若干AND条件语句，例如：

```
Book.where('id > 1')
  .where('id < 100')
  .where('title like ?', '3%')
```

上面会生成对应SQL:

```
SELECT `books`.* FROM `books` WHERE (id > 1) AND (id<100) AND (title like '3%')
```

结果为：
```
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">]>
```

### 排序. order

跟标准的SQL语句非常像，例如根据title进行倒序：

```
irb> Book.where('title like "3%" or title like "4%" or title like "5%"').order('title desc')
```
可以注意到，上面的查询是根据title进行条件查询，并且按照title进行倒序。

下面是结果SQL语句：
```
  Book Load (0.5ms)  SELECT `books`.* FROM `books` WHERE (title like "3%" or title like "4%" or title like "5%")  ORDER BY title desc
```

结果为：
```
=> #<ActiveRecord::Relation [
  #<Book id: 7, name: nil, title: "5万个为什么", author: "5号作者">,
  #<Book id: 6, name: nil, title: "4万个为什么", author: "4号作者">,
  #<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">
  ]>
```

### limit

可以限制查询条件的数量。例如：

```
Book.where('1 = 1').limit(3)
```

得到对应的SQL：

```
Book Load (0.4ms)  SELECT  `books`.* FROM `books` WHERE (1 = 1) LIMIT 3
```

结果是：
```
=> #<ActiveRecord::Relation[
  #<Book id: 3, name: nil, title: "1万个为什么", author: "1号作者">,
  #<Book id: 4, name: nil, title: "2万个为什么", author: "2号作者">,
  #<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">
  ]>
```

### where, all与延迟加载

`all` 等同于 `.where('1=1')`, 作用只是让查询更加可读。

通常说来where非常智能, 只会在需要执行的时候才会执行.

例如，在controller中不会执行，只有到了erb页面需要渲染的阶段，才会执行。或者有`all`方法的时候，查询才会强制执行。

例如：这行代码不会被执行. 因为它的结果没有在任何地方被使用.

```
def index
  Book.where('age = 18')
end
```

下面这行代码会被执行, 因为变量 `@books`被渲染在了view中。

```
#controller:
def index
  @books = Book.where('age = 18')
end

# view:
<%= @books %>
```

### count

用来计算某个查询的数量，例如：

```
Book.where('title like ?', '3%').count
```

对应的SQL：
```
SELECT COUNT(*) FROM `books` WHERE (title like '3%')
```

结果是

```
=> 1
```

### group 与 having

这类聚合函数的使用也很简单，就不赘述了。可以在官网直接看到例子。

https://guides.rubyonrails.org/active_record_querying.html#group

个人认为使用聚合函数时，如果SQL语句比较复杂，或者结果集比较复杂，就直接使用原生SQL来查询。

## 直接运行原生SQL

在某些情况下，直接运行SQL才能达到我们的目的。我们可以这样做：

```
sql = "insert into temp_orders select * from orders"
ActiveRecord::Base.connection.execute(sql)
```

## find 与 where 的区别

find 在3.0 之前的版本用的最普遍.
到 3.0之后,往往被where 取代.

根据查询id 直接用 find(2).
查询多个数据的话, 往往用where 更加合适一些.

find 得到的都是单数
where 得到的都是复数.

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

1.Model的名字不能跟项目重名. 例如你的项目名字叫"book", 那么`config/application.rb`中一定定义了:

```
module Book
  class Application < Rails::Application
  end
end
```

那么, 这个`Book`变量已经被全局范围内定义了,任何变量都不能叫做`Book`，包括Model。

2.where查询中，一定要使用问号形式传递参数，这样才是安全的。例如：

```
Book.where('id = ?', 3)
```

绝对不是：

```
# 在controller中：
id = params[:id]
Book.where("id = #{id}")
```

因为在上面的代码中，变量`id`可能被恶意攻击者利用，传入参数`xx or 1=1`, 这样，生成的SQL就是一个全体查询。例如：

```
id = "1000 or 1 = 1"
Book.where("id = #{id}")
```

得到的SQL语句是这样的，注意where条件中的 `or 1 = 1` 直接把前面的条件给无视掉了。
```
Book Load (0.6ms)  SELECT `books`.* FROM `books` WHERE (id = 1000 or 1 = 1)
```

得到的结果：
```
=> #<ActiveRecord::Relation [
  #<Book id: 3, name: nil, title: "1万个为什么", author: "1号作者">,
  #<Book id: 4, name: nil, title: "2万个为什么", author: "2号作者">,
  #<Book id: 5, name: nil, title: "3万个为什么", author: "3号作者">,
  #<Book id: 6, name: nil, title: "4万个为什么", author: "4号作者">,
  #<Book id: 7, name: nil, title: "5万个为什么", author: "5号作者">,
  #<Book id: 8, name: nil, title: "6万个为什么", author: "6号作者">,
  #<Book id: 9, name: nil, title: "7万个为什么", author: "7号作者">,
  #<Book id: 10, name: nil, title: "8万个为什么", author: "8号作者">,
  #<Book id: 11, name: nil, title: "9万个为什么", author: "9号作者">,
  #<Book id: 12, name: nil, title: "10万个为什么", author: "10号作者">
  ]>
```

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

