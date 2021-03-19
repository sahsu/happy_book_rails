# Model2 增刪改查

本節中，我們只學習Model的基本操作

## 數據持久層

簡單的說, 持久層就是對數據庫直接查詢操作的封裝。

```
Ruby代碼  <===>  持久層  <===> 數據庫SQL語句
```

## 從例子來看持久層

在Ruby中，使用ActiveRecord作爲持久層。

```
Book.all
```

- `Book` 它是個model.  它映射到了 books 表。
- `Book.all`,  就會被Rails的持久層的機制，轉換成一段SQL語句：

```
select * from books;
```

然後，Rails的持久層，再把上面SQL的結果轉換成："ruby 對象" 的格式。

## 數據庫與持久層

數據庫：

- mysql:  是一個文件。 對於ubuntu, 默認放在： /var/lib/mysql/數據庫名下面，例如：

```
/var/lib/mysql/me/students.frm
/var/lib/mysql/me/students.ibd
```

文件放在硬盤上。

## 持久層的巨大作用：爲了一統(數據操作的)天下

例如: 不同數據庫對於分頁的操作。

如果用MYSQL：

```
select ... from ... order by id limit(100) offset(2000)
```

oracle: 寫法就變了：

```
select ... from ... order by id limit(100) top(2000)
```

ms sql server: 寫法又變了：

```
select ... from ... order by id between 2000 and 2100
```

其他的： postgres, ... 都不一樣。

所以，想兼容數據庫，那就是一場噩夢。

（例如： mysql支持 `select ... from (select ... from ... )` 這樣的嵌套 select,  其他好多數據庫就不支持）

市面上， 根本找不到 熟悉所有數據庫的人。 而且各個數據庫的“方言(dialact )“ 都不一樣。

十年以前的環境，比現在的還糟糕。（當年作java都沒現在多。）

所以：持久層最大的賣點：

學好一個持久層， 可以操作所有數據庫。

例如： 學好hibernate/Rails ActiveRecord, 可以在所有數據庫上操作。

而且持久層生成的代碼，就是專家級別的。(持久層在生成代碼時會自動作優化。)

# 正式學習Model的增刪改查

說明： 下面的所有代碼中，需要同學們輸入的只是在  `irb..>` 右側的內容。例如：

```
irb(main):006:0> book = Book.first
```

其他的文字（例如SQL語句等都是控制檯的自動輸出)

## 準備工作（修改表結構，創建持久層文件）

4.1 回顧一下，我們前一節通過migration創建了一個表 books, 只有一個列name (這個name 列我們不使用)

4.2 創建一個新的migration, 爲這個books表增加內容: author和title列

`$ bundle exec rails g migration add_title_and_author_to_books`

內容如下：
```
class AddTitleAndAuthorToBooks < ActiveRecord::Migration

  def up

    # 增加列：標題
    add_column :books, :title, :string

    # 增加列：作者
    add_column :books, :author, :string
  end

  def down

    # 刪除列 books 表中的title
    remove_column :books, :title

    # 刪除列 books 表中的author
    remove_column :books, :author
  end
end
```

4.3 運行migrate

```
$ bundle exec rake db:migrate

== 20210130010914 AddTitleAndAuthorToBooks: migrating =========================
-- add_column(:books, :title, :string)
   -> 0.0316s
-- add_column(:books, :author, :string)
   -> 0.0284s
== 20210130010914 AddTitleAndAuthorToBooks: migrated (0.0602s) ================
```

從控制檯的日誌當中可以看到，books表已經增加了兩列。

同時，我們查看MySQL，可以發現books表的內容也發生了改變。

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

4.4 創建model文件

創建一個文件 `app/models/book.rb`, 內容如下：

```
class Book < ActiveRecord::Base
end
```

在上面的代碼中，

- `class Book` 對應數據庫的表名`books`
- `< ActiveRecord::Base` 表示該class繼承了ActiveRecord, 是一個持久層的類（一定對應一個表）

4.5 進入到控制檯

```
$ bundle exec rails console
```

就可以進入到rails console來操作數據庫了.

```
Loading development environment (Rails 4.1.6)
irb(main):001:0> Book
=> Book (call 'Book.connection' to establish a connection)
```

## 創建記錄

接下來,我可以創建一個book, author爲 王博士

```
irb(main):001:0> Book.create author: '王博士'
```

可以看到, 上面的代碼被轉換成了下面的SQL語句並執行：

```
(0.2ms)  BEGIN
SQL (0.6ms)  INSERT INTO `books` (`author`) VALUES ('王博士')
(3.3ms)  COMMIT
```

在MySQL控制檯中，也可以看到這個記錄了。

```
mysql> select * from books;
+----+------+--------------------+-----------+
| id | name | title              | author    |
+----+------+--------------------+-----------+
|  1 | NULL | NULL               | 王博士    |
+----+------+--------------------+-----------+
1 row in set (0.00 sec)
```

## 修改記錄

我們爲`id=1`的book 設置`title`, 依次輸入：

```
irb(main):006:0> book = Book.first
irb(main):007:0> book.title = '十萬個爲什麼'
irb(main):008:0> book.save
```

可以看到, 上面的代碼被轉換成了下面的SQL語句並執行：

```
(0.3ms)  BEGIN
SQL (1.8ms)  UPDATE `books` SET `title` = '十萬個爲什麼' WHERE `books`.`id` = 1
(3.2ms)  COMMIT
```

在MySQL控制檯中，也可以看到這個記錄了。

```
mysql> select * from books;
+----+------+--------------------+-----------+
| id | name | title              | author    |
+----+------+--------------------+-----------+
|  1 | NULL | 十萬個爲什麼       | 王博士    |
+----+------+--------------------+-----------+
1 row in set (0.00 sec)
```

## 刪除記錄

刪掉該`book`

```
irb(main):010:0> a = Book.first
irb(main):011:0> a.delete
```

可以看到, 上面的代碼被轉換成了下面的SQL語句並執行：

```
SQL (4.3ms)  DELETE FROM `books` WHERE `books`.`id` = 1
```

可以看到，數據庫中已經找不到這條記錄了。

```
mysql> select * from books;
Empty set (0.00 sec)
```

## where查詢語句

## 查詢

### 準備10條數據

插入10本書的記錄：

```
irb> (1..10).each {|i| Book.create(title:"#{i}萬個爲什麼", author: "#{i}號作者") }
```

會有10條SQL被轉換出來,並且被執行. 可以看到mysql中這些數據已經被創建了。

```
mysql> select * from books;
+----+------+-------------------+-------------+
| id | name | title             | author      |
+----+------+-------------------+-------------+
|  3 | NULL | 1萬個爲什麼       | 1號作者     |
|  4 | NULL | 2萬個爲什麼       | 2號作者     |
|  5 | NULL | 3萬個爲什麼       | 3號作者     |
|  6 | NULL | 4萬個爲什麼       | 4號作者     |
|  7 | NULL | 5萬個爲什麼       | 5號作者     |
|  8 | NULL | 6萬個爲什麼       | 6號作者     |
|  9 | NULL | 7萬個爲什麼       | 7號作者     |
| 10 | NULL | 8萬個爲什麼       | 8號作者     |
| 11 | NULL | 9萬個爲什麼       | 9號作者     |
| 12 | NULL | 10萬個爲什麼      | 10號作者    |
+----+------+-------------------+-------------+
10 rows in set (0.00 sec)
```

### find: 根據id 查詢

find返回一條記錄。

```
irb> book = Book.find(8)
```

可以看到，對應的SQL已經被執行：

```
Book Load (0.6ms)  SELECT  `books`.* FROM `books` WHERE `books`.`id` = 8 LIMIT 1
```

並且在控制檯上可以打印出詳情：

```
=> #<Book id: 8, name: nil, title: "6萬個爲什麼", author: "6號作者">
```

### find: 根據單個列來查詢

使用`find_by_列名`就可以了。

例如：查詢 author='9號作者'

```
irb(main):016:0> book = Book.find_by_author('9號作者')
```

可以看到SQL語句：
```
Book Load (0.7ms)  SELECT  `books`.* FROM `books` WHERE `books`.`author` = '9號作者' LIMIT 1
```

並且在控制檯上可以打印出詳情：
```
=> #<Book id: 11, name: nil, title: "9萬個爲什麼", author: "9號作者">
```

查詢 title = '9萬個爲什麼'

```
irb(main):017:0> book = Book.find_by_title('9萬個爲什麼')
```

可以看到SQL語句：
```
Book Load (0.5ms)  SELECT  `books`.* FROM `books` WHERE `books`.`title` = '9萬個爲什麼' LIMIT 1
```

並且在控制檯上可以打印出詳情：
```
=> #<Book id: 11, name: nil, title: "9萬個爲什麼", author: "9號作者">
```

### 使用where 進行查詢

我們絕大部分時候都用where進行查詢。where返回的記錄是一個數組。

where是ActiveRecord的函數，裏面可以包含幾乎所有的標準SQL語句的where條件。

例如，查詢id = 5的book

```
irb> a = Book.where('id = ?', 5)
```
可以看到，對應的SQL語句被執行，並且返回一個數組。
```
  Book Load (0.7ms)  SELECT `books`.* FROM `books` WHERE (id = 5)
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">]>
```

想要獲得第一條記錄的話，就可以使用`.first`方法。
```
irb> a.first
=> #<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">
```

也可以進行`like`查詢。例如，查詢所有標題以`5`開頭的Book.

```
irb> Book.where('title like "5%"')
```
或者寫成這樣：
```
irb> Book.where('title like ?', "5%")
```

可以看到，對應的SQL語句被執行，並且返回一個數組。
```
  Book Load (2.2ms)  SELECT `books`.* FROM `books` WHERE (title like "5%")
=> #<ActiveRecord::Relation [#<Book id: 7, name: nil, title: "5萬個爲什麼", author: "5號作者">]
```

### where 中的or與and

一個where查詢中可以包含任意條件的任意嵌套。例如：

如果你的查詢中有or 或者and, 直接按照原生SQL的順序寫入到where函數中即可，例如：

例如，查詢and條件：

```
> Book.where('title like ? and author like ?', '3萬個%', '5號%')
```
可以看到，對應的SQL查詢到的內容是空。如下：
```
  Book Load (0.8ms)  SELECT `books`.* FROM `books` WHERE (title like '3萬個%' and author like '5號%')
=> #<ActiveRecord::Relation []>
```

再如，查詢or條件：

```
> Book.where('title like ? or author like ?', '3萬個%', '5號%')
```

可以看到，查到了標題是"3萬個" 和作者是"5號作者"的Book:
```
  Book Load (0.6ms)  SELECT `books`.* FROM `books` WHERE (title like '3萬個%' or author like '5號%')
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">, #<Book id: 7, name: nil, title: "5萬個爲什麼", author: "5號作者">]>
```

你也可以使用多個`where`方法，等同於若干AND條件語句，例如：

```
Book.where('id > 1')
  .where('id < 100')
  .where('title like ?', '3%')
```

上面會生成對應SQL:

```
SELECT `books`.* FROM `books` WHERE (id > 1) AND (id<100) AND (title like '3%')
```

結果爲：
```
=> #<ActiveRecord::Relation [#<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">]>
```

### 排序. order

跟標準的SQL語句非常像，例如根據title進行倒序：

```
irb> Book.where('title like "3%" or title like "4%" or title like "5%"').order('title desc')
```
可以注意到，上面的查詢是根據title進行條件查詢，並且按照title進行倒序。

下面是結果SQL語句：
```
  Book Load (0.5ms)  SELECT `books`.* FROM `books` WHERE (title like "3%" or title like "4%" or title like "5%")  ORDER BY title desc
```

結果爲：
```
=> #<ActiveRecord::Relation [
  #<Book id: 7, name: nil, title: "5萬個爲什麼", author: "5號作者">,
  #<Book id: 6, name: nil, title: "4萬個爲什麼", author: "4號作者">,
  #<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">
  ]>
```

### limit

可以限制查詢條件的數量。例如：

```
Book.where('1 = 1').limit(3)
```

得到對應的SQL：

```
Book Load (0.4ms)  SELECT  `books`.* FROM `books` WHERE (1 = 1) LIMIT 3
```

結果是：
```
=> #<ActiveRecord::Relation[
  #<Book id: 3, name: nil, title: "1萬個爲什麼", author: "1號作者">,
  #<Book id: 4, name: nil, title: "2萬個爲什麼", author: "2號作者">,
  #<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">
  ]>
```

### where, all與延遲加載

`all` 等同於 `.where('1=1')`, 作用只是讓查詢更加可讀。

通常說來where非常智能, 只會在需要執行的時候纔會執行.

例如，在controller中不會執行，只有到了erb頁面需要渲染的階段，纔會執行。或者有`all`方法的時候，查詢纔會強制執行。

例如：這行代碼不會被執行. 因爲它的結果沒有在任何地方被使用.

```
def index
  Book.where('age = 18')
end
```

下面這行代碼會被執行, 因爲變量 `@books`被渲染在了view中。

```
#controller:
def index
  @books = Book.where('age = 18')
end

# view:
<%= @books %>
```

### count

用來計算某個查詢的數量，例如：

```
Book.where('title like ?', '3%').count
```

對應的SQL：
```
SELECT COUNT(*) FROM `books` WHERE (title like '3%')
```

結果是

```
=> 1
```

### group 與 having

這類聚合函數的使用也很簡單，就不贅述了。可以在官網直接看到例子。

https://guides.rubyonrails.org/active_record_querying.html#group

個人認爲使用聚合函數時，如果SQL語句比較複雜，或者結果集比較複雜，就直接使用原生SQL來查詢。

## 直接運行原生SQL

在某些情況下，直接運行SQL才能達到我們的目的。我們可以這樣做：

```
sql = "insert into temp_orders select * from orders"
ActiveRecord::Base.connection.execute(sql)
```

## find 與 where 的區別

find 在3.0 之前的版本用的最普遍.
到 3.0之後,往往被where 取代.

根據查詢id 直接用 find(2).
查詢多個數據的話, 往往用where 更加合適一些.

find 得到的都是單數
where 得到的都是複數.

## 總結: 如何在Rails中實現 數據庫的映射呢？

Rails中聲明持久層極其簡單:

如果你的表，名字叫：  teachers, 那麼，就在
app/models 目錄下，新建一個rb文件：  teacher.rb

```
class Teacher < ActiveRecord::Base
end
```

然後就可以在Rails框架的任意文件中調用這個 teacher了。

## 軍規

1.Model的名字不能跟項目重名. 例如你的項目名字叫"book", 那麼`config/application.rb`中一定定義了:

```
module Book
  class Application < Rails::Application
  end
end
```

那麼, 這個`Book`變量已經被全局範圍內定義了,任何變量都不能叫做`Book`，包括Model。

2.where查詢中，一定要使用問號形式傳遞參數，這樣纔是安全的。例如：

```
Book.where('id = ?', 3)
```

絕對不是：

```
# 在controller中：
id = params[:id]
Book.where("id = #{id}")
```

因爲在上面的代碼中，變量`id`可能被惡意攻擊者利用，傳入參數`xx or 1=1`, 這樣，生成的SQL就是一個全體查詢。例如：

```
id = "1000 or 1 = 1"
Book.where("id = #{id}")
```

得到的SQL語句是這樣的，注意where條件中的 `or 1 = 1` 直接把前面的條件給無視掉了。
```
Book Load (0.6ms)  SELECT `books`.* FROM `books` WHERE (id = 1000 or 1 = 1)
```

得到的結果：
```
=> #<ActiveRecord::Relation [
  #<Book id: 3, name: nil, title: "1萬個爲什麼", author: "1號作者">,
  #<Book id: 4, name: nil, title: "2萬個爲什麼", author: "2號作者">,
  #<Book id: 5, name: nil, title: "3萬個爲什麼", author: "3號作者">,
  #<Book id: 6, name: nil, title: "4萬個爲什麼", author: "4號作者">,
  #<Book id: 7, name: nil, title: "5萬個爲什麼", author: "5號作者">,
  #<Book id: 8, name: nil, title: "6萬個爲什麼", author: "6號作者">,
  #<Book id: 9, name: nil, title: "7萬個爲什麼", author: "7號作者">,
  #<Book id: 10, name: nil, title: "8萬個爲什麼", author: "8號作者">,
  #<Book id: 11, name: nil, title: "9萬個爲什麼", author: "9號作者">,
  #<Book id: 12, name: nil, title: "10萬個爲什麼", author: "10號作者">
  ]>
```

# 作業：

創建一個rails項目, 連接到本地的mysql， 本地mysql有個表：book，

有兩個列： title, author:

1.在console下面，實現book表的增刪改查。

  1.1 新建一個文件, app/models/book.rb
  1.2 操作,分別試試 book的 crud.

2.在Rails的action裏面，實現book表的增刪改查。

例如：

2.1 用戶訪問 `/books/create_a_book`， 數據庫 books表中就會出現一條記錄（title: "三體", author: "大劉"），頁面顯示結果： “操作成功”

2.2 用戶訪問 `/books/update_the_book`, 數據庫的 books表的第一條記錄，的title，就會變成： “十萬個爲什麼”.  頁面顯示結果： “操作成功"

2.3 用戶訪問 `/books/search_the_book`, 數據庫的books表，會查詢：  author=大劉 的記錄。頁面顯示結果：   找到1/0個結果。

2.4 用戶訪問 `/books/delete_the_book`, 會刪除數據庫books表中的第一條記錄。 頁面顯示結果： “操作成功”

