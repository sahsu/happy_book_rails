# 數據庫關聯

關聯關係，是最重要的數據庫的知識。總共有3種關聯關係：

1. 一對多
2. 一對一（一對多的特殊情況）
3. 多對多（包含中間表的一對多）

所以，我們只要把一對多的關係學習好即可。

本節用於快速入門，在實際工作中需要多多學習官方文檔: https://guides.rubyonrails.org/association_basics.html

## 最簡單的關聯關係： 一對多

假如王媽媽有兩個孩子。小明和小亮。

可以說： 王媽媽有多個孩子。

可以說:

小明，只有一個媽媽。
小王，只有一個媽媽。

### 用數據庫結構來表示

媽媽mothers 表

id | name
-- | --
1  | 王媽媽

兒子sons表（包含了一個列：`mother_id`）

id   |  name |  mother_id
 --  |   --  |  --
100  |  小王 |  1
101  |  小明 |  1

上面的 `mother_id` 列， 就是外鍵。(foreign key) (表示該行對應mother表中的某個記錄）

可以看出: 外鍵的值，其實是另一個表的id 的值。

### 創建migration
我們使用migration來創建這兩個表：

Mothers:

```
$ bundle exec rails g migration create_mothers
      invoke  active_record
      create    db/migrate/20210131013530_create_mothers.rb
```

內容該文件內容如下：
```
class CreateMothers < ActiveRecord::Migration
  def change
    create_table :mothers do |t|
      t.string :name
    end
  end
end
```

爲sons表創建migration:

```
$ bundle exec rails g migration create_sons
      invoke  active_record
      create    db/migrate/20210131013535_create_sons.rb
```

內容如下：
```
class CreateSons < ActiveRecord::Migration
  def change
    create_table :sons do |t|
      t.string :name
      t.integer :mother_id
    end
  end
end

```

執行命令，創建兩個表：
```
$ bundle exec rake db:migrate
== 20210131013530 CreateMothers: migrating ====================================
-- create_table(:mothers)
   -> 0.0223s
== 20210131013530 CreateMothers: migrated (0.0224s) ===========================

== 20210131013535 CreateSons: migrating =======================================
-- create_table(:sons)
   -> 0.0191s
== 20210131013535 CreateSons: migrated (0.0192s) ==============================
```

### 創建model

增加`app/models/mother.rb`, 內容如下：

```
class Mother < ActiveRecord::Base
  has_many :sons
end
```

上面的代碼中：

- `has_many` 是ActiveRecord自帶的方法，
- `has_many :sons`表示當前的model包含多個 sons

增加`app/models/son.rb`, 內容如下：

```
class Son < ActiveRecord::Base
  belongs_to :mother
end
```

上面的代碼中：

- `belongs_to` 是ActiveRecord自帶的方法，
- `belongs_to :mother`表示當前的model屬於一個mother

### 增加初始化數據

進入到rails console:

```
irb> mother = Mother.create name: '王媽媽'
irb> Son.create name: '小王', mother_id: mother.id
irb> Son.create name: '小明', mother_id: mother.id
```

可以看到，mother表和sons 表都增加了對應的數據。

mothers表：
```
mysql> select * from mothers;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 王媽媽    |
+----+-----------+
```

sons表：
```
mysql> select * from sons;
+----+--------+-----------+
| id | name   | mother_id |
+----+--------+-----------+
|  1 | 小王   |         1 |
|  2 | 小明   |         1 |
+----+--------+-----------+
```

### 原生SQL查詢

如果我們要找出孩子“小王”對應的媽媽。

```
select * from mothers
  join sons
  on sons.mother_id = mothers.id
  where sons.name = '小王'
```

會得到這個結果
```
+----+-----------+----+--------+-----------+
| id | name      | id | name   | mother_id |
+----+-----------+----+--------+-----------+
|  1 | 王媽媽    |  1 | 小王   |         1 |
+----+-----------+----+--------+-----------+
```


### 在Rails中實現關聯查詢

然後，我就可以在 Rails Console 中：

```
irb > xiao_wang = Son.first
```

就會生成SQL：

```
select * from sons where id = 1;
```

我們還可以輕易的從 `xiao_wang` 找到他的媽媽:

```
mama = xiao_wang.mother
```

這個 `.mother` 方法就是由 `class Son`的`belongs_to :mother`這句話生成的。

上面的代碼會被轉換成下面的SQL語句, 然後被執行.

```
select * from mothers
	join sons
	on sons.mother_id = mothers.id
	where sons.id = 1
```

## Rails 是如何 根據 ORM配置，來自動生成上面的複雜的 SQL 語句的？

最初的配置：

```
class Son < ActiveRecord::Base
  belongs_to :mother
end
```

等同於下面的：

```
class Son < ActiveRecord::Base
  belongs_to :mother, :class => 'Mother', :foreign_key => 'mother_id'
end
```

這個就是Rails最典型的 根據 慣例來編程。

1.`belongs_to :mother`, rails就能判斷出：  mothers 表，是一的那一端。
而當前class 是： "class Son", 那麼rails 就知道了 兩個表的對應關係。

2.`:class => 'Mother'`, 表示， 一的那一端， 對應的model class是Mother.
根據rails的慣例， Mother model對應的是 數據庫中的 mothers 表。

3.`:foreign_key => 'mother_id'`, rails就知道了， 外鍵是 'mother_id'.
而一對多關係中， 外鍵是保存在 多的那一端（也就是 sons, 所以說，在 sons表中，
必須有一個列， 叫做： `mother_id` )

所以，這個複雜的SQL 條件就齊備了， 可以生成了。

上面的ruby代碼，配置好之後， 就可以這樣調用：

```
son = Son.first

# .mother方法，  是由 class Son 中的 belongs_to 產生的。
son.mother

mother = Mother.first

# .sons 方法，  是由 class Mother 中的 hash_many  產生的。
mother.sons
```

## 一對一： 一對多的特例。

在一對多關係中，用到的關鍵方法是：`has_many/belongs_to`

在一對一關係中，可以用：`has_one/belongs_to`

例如，最典型的1:1的關係是老公和老婆.

一個老公：有一個老婆。


### 創建數據庫的表

創建老婆表

```
$ bundle exec rails g migration create_wives
      invoke  active_record
      create    db/migrate/20210131025033_create_wives.rb
```

文件`db/migrate/20210131025033_create_wives.rb` 內容如下：
```
class CreateWives < ActiveRecord::Migration
  def change
    create_table :wives do |t|
      t.string :name
      t.integer :husband_id
    end
  end
end
```

創建對應的model `app/models/wife.rb`, 內容如下：

```
class Wife < ActiveRecord::Base
  belongs_to :husband
end
```

注意：這裏是`belongs_to`, 所以我們在wife表中增加外鍵`husband_id`

創建老公表：


```
$ bundle exec rails g migration create_husbands
      invoke  active_record
      create    db/migrate/20210131025043_create_husbands.rb
```

文件`db/migrate/20210131025043_create_husbands.rb`的內容如下：

```
class CreateHusbands < ActiveRecord::Migration
  def change
    create_table :husbands do |t|
      t.string :name
    end
  end
end
```

創建對應的model `app/models/husband.rb`, 內容如下：

```
class Husband < ActiveRecord::Base
  has_one :wife
end
```

運行migration:

```
$ bundle exec rake db:migrate
== 20210131025033 CreateWives: migrating ======================================
-- create_table(:wives)
   -> 0.0198s
== 20210131025033 CreateWives: migrated (0.0199s) =============================

== 20210131025043 CreateHusbands: migrating ===================================
-- create_table(:husbands)
   -> 0.0182s
== 20210131025043 CreateHusbands: migrated (0.0182s) ==========================
```

可以看到，2個表的結構都已經生成了。

### 添加數據

```
$ bundle exec rails c
irb> a = Husband.create name: '李爸爸'
irb> b = Wife.create name: '王媽媽', husband_id: a.id
```

可以看到，此時的數據庫內容：

```
mysql> select * from wives;
+----+-----------+------------+
| id | name      | husband_id |
+----+-----------+------------+
|  1 | 王媽媽    |          1 |
+----+-----------+------------+

mysql> select * from husbands;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 李爸爸    |
+----+-----------+
```

查詢:

```
irb> Wife.first.husband
=> #<Husband id: 1, name: "李爸爸">

irb(main):007:0> Husband.first.wife
=> #<Wife id: 1, name: "王媽媽", husband_id: 1>
```

## 多對多

下面是最典型的多對多關係：

- 一個學生有多個老師（ 學習了多門課程）
- 一個老師可以教多個孩子（教一門課程，但是有好多學生來聽這個課程）

### 創建表結構

爲students表創建migration:

```
$ bundle exec rails g migration create_students
      invoke  active_record
      create    db/migrate/20210131073802_create_students.rb
```

`db/migrate/20210131073802_create_students.rb`內容如下：

```
class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
    end
  end
end
```

同時創建對應的model `app/models/student.rb`

```
class Student < ActiveRecord::Base
  has_many :lessons
  has_many :teachers, :through => :lessons
end
```

爲teachers表創建migration


```
$ bundle exec rails g migration create_teachers
      invoke  active_record
      create    db/migrate/20210131073807_create_teachers.rb
```

`db/migrate/20210131073807_create_teachers.rb` 的內容如下：

```
class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :name
    end
  end
end
```

設置對應的model: `app/models/teacher.rb`

```
class Teacher < ActiveRecord::Base
  has_many :lessons
  has_many :students, :through => :lessons
end
```

爲中間表lessons創建migration:

```
$ bundle exec rails g migration create_lessons
      invoke  active_record
      create    db/migrate/20210131073822_create_lessons.rb
```

`db/migrate/20210131073822_create_lessons.rb`內容如下：

```
class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :teacher_id
      t.integer :student_id
    end
  end
end
```

創建對應的model  `app/models/lesson.rb` 內容如下：

```
class Lesson < ActiveRecord::Base
  belongs_to :student
  belongs_to :teacher
end
```

然後，我們運行migration , 創建對應的表：

```
$ bundle exec rake db:migrate
== 20210131073802 CreateStudents: migrating ===================================
-- create_table(:students)
   -> 0.0170s
== 20210131073802 CreateStudents: migrated (0.0171s) ==========================

== 20210131073807 CreateTeachers: migrating ===================================
-- create_table(:teachers)
   -> 0.0234s
== 20210131073807 CreateTeachers: migrated (0.0235s) ==========================

== 20210131073822 CreateLessons: migrating ====================================
-- create_table(:lessons)
   -> 0.0192s
== 20210131073822 CreateLessons: migrated (0.0193s) ===========================
```

### 初始化數據


我們在Rails控制檯中，運行如下代碼:

```
irb> ['小王', '小明', '小紅'].each { |name|  Student.create name: name}
irb> ['物理老師','化學老師'].each { |name| Teacher.create name: name }
```

數據庫中就會得到對應的數據：

```
mysql> select * from students;
+----+--------+
| id | name   |
+----+--------+
|  1 | 小王   |
|  2 | 小明   |
|  3 | 小紅   |
+----+--------+

mysql> select * from teachers;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 物理老師     |
|  2 | 化學老師     |
+----+--------------+
```

接下來，我們通過爲中間表lessons增加數據，來實現多對多的關係：

物理老師教了3個孩子：小王，小明和小紅

```
irb> ['小王', '小明', '小紅'].each do |student_name|
irb>    student = Student.find_by_name student_name
irb>    teacher = Teacher.find_by_name '物理老師'
irb>    Lesson.create name: '物理課', student_id: student.id, teacher_id: teacher.id
irb>  end
```

化學老師教了2個孩子：小王和小紅。

```
irb> ['小王', '小紅'].each do |student_name|
irb>   student = Student.find_by_name student_name
irb>   teacher = Teacher.find_by_name '化學老師'
irb>   Lesson.create name: '化學課', student_id: student.id, teacher_id: teacher.id
irb> end
```

可以看到，數據庫中已經存在了下面的數據：

```
mysql> select * from lessons;
+----+-----------+------------+------------+
| id | name      | teacher_id | student_id |
+----+-----------+------------+------------+
|  1 | 物理課    |          1 |          1 |
|  2 | 物理課    |          1 |          2 |
|  3 | 物理課    |          1 |          3 |
|  4 | 化學課    |          2 |          1 |
|  5 | 化學課    |          2 |          3 |
+----+-----------+------------+------------+
```

進行一些查詢：

小紅的所有老師的名字：

```
irb(main):001:0> Student.find_by_name('小紅').teachers.each { |teacher| puts teacher.name }
  Student Load (0.4ms)  SELECT  `students`.* FROM `students` WHERE `students`.`name` = '小紅' LIMIT 1
  Teacher Load (0.7ms)  SELECT `teachers`.* FROM `teachers` INNER JOIN `lessons` ON `teachers`.`id` = `lessons`.`teacher_id` WHERE `lessons`.`student_id` = 3
物理老師
化學老師
```

可以看到，Rails分別生成了2條SQL語句，並且在第二條SQL中使用了JOIN查詢

### 使用join 查詢

在很多時候，我們需要在where與join配合才能進行查詢。例如：

找出符合下面條件的所有學生
1. 姓名包含"紅",
2. 老師的名字中包含"物理"

我們可以這樣做：

```
irb> Student.joins(:teachers).where('students.name like ? and teachers.name like ?',
        '%紅%', '%物理%').each { |student| puts student.inspect }
```

會看到，生成對應的SQL是：

```SQL
SELECT students.* FROM students
  INNER JOIN lessons
  ON lessons.student_id = students.id
  INNER JOIN teachers
  ON teachers.id = lessons.teacher_id
  WHERE (students.name like '%紅%' and teachers.name like '%物理%')
```

得到的結果：

```
#<Student id: 3, name: "小紅">
```

### 回顧一下多對多的代碼

可以發現，在Rails中，多對多的關係是有 `has_many` 來實現的。

```
class Student
  has_many :lessons
  has_many :teachers, :through => :lessons
  # 上面的簡寫， 相當於：
  has_many :teachers, :class => 'Teacher', :foreign_key => 'teacher_id', :throught => :lessons
end
```

```
class Teachers
  has_many :lessons
  has_many :students, :through => :lessons
end
```

### 注意： 多對多關聯不要學習 `has_many_and_belongs_to`

因爲這個方法會生成一個無意義的只包含外鍵的中間表。例如：

表名： `student_teachers`

student_id |  teacher_id
-- | --
1      |      100
2      |      100
3      |      100

1. 表名不明確。不要使用 `a_bs` 這樣的表名。對應model比較難寫。 (`app/models/a_b.rb` 嗎？)
2. 任何一箇中間表都應該是有意義的。絕大部分時候，中間表都是有正常的列的。與其以後通過migration加上這個列，不如一開始就不要使用 `has_many_and_belongs_to`
這樣的方式來聲明（聲明之後， model 的名字就定下來了。難改）

### 多對多關聯時對"中間表"的命名。

中間表一定要有"有意義的"名字。不能叫：中間表1，中間表2.

有個不太好用但是也將就能用的模式： `A_Bs` , 例如： `student_teachers`, 但是它不如`lessons`可讀性強。

好的名字:

- 商品 與 顧客 的中間表是 訂單
- 學生 與 老師 的中間表是 課程(或成績)

## `has_many`與`belongs_to` 會自動生成一系列的方法

例如：

```
class Mother < ActiveRecord::Base
  has_many :sons
end

wangmama = Mother.first
```

Mother 自動獲得了 16個方法, 下面表中，左側是API， 右側就是例子：


API 原文 |  對於我們上面的例子
 -- | --
collection(force_reload = false)   |   wangmama.sons
collection<<(object, ...)          |   wangmama.sons << Son.create({... })
collection.delete(object, ...)     |   wangmama.sons.delete
collection.destroy(object, ...)    |   wangmama.sons.destroy
collection=objects                 |   wangmama.sons=
collection_singular_ids            |   wangmama.son_id
collection.create(attributes = {})	|  wangmama.sons.create(...)

總共16個.不過,這些方法中,常用的只有一兩個.大家可以參考文檔.

## destroy 與 delete 區別？

- destroy 會刪掉關聯表的數據（通過調用關聯表的方法）
- delete  不會。只會刪掉當前對象對應的表。

例子：

老王去世了。老王有20張銀行卡。

那麼：
```
laowang.destroy    (老王的銀行卡也會被刪掉）

laowang.delete  （只刪掉老王， 保留銀行卡）
```

## 級聯刪除

級聯刪除, 就是我們把一對多中, "一"的那一端刪掉, 那麼"多"的那一端的所有關聯數據,也要一起刪掉.

在Rails中,我們使用 `dependency => :destroy` 來實現.

例如: 某個人去世後,他的銀行卡應該都被註銷掉. 那麼就可以這樣寫:

```
class Person < ActiveRecord::Base
  has_many :cards
end

class Card < ActiveRecord::Base
  # 下面這句，表示： person一旦被刪除， 該card也會自動被刪除。
  belongs_to :person, :dependency => :destroy
end
```

實戰中，不要用級聯刪除。（不要一條命令，刪掉多個表的數據）

- 好處： 刪的比較乾淨。 很清爽。
- 缺點： 大項目或者公司內的項目，一般都不允許刪除。很多項目用“disabled” 來代替刪除。

## 軍規

1. 關聯務必寫全兩端！ 無論`1：N`， `N:N`, 都要寫全兩端。否則會出初學者看不懂的錯誤。
另外，寫全了兩端對於理解代碼是特別有好處的。

2. 掌握好單數和複數.

- model 名字是單數, 例如 app/models/user.rb,

```
class User < ActiveRecord::Base
end
```

- `belongs_to` 後面必須是單數, 都是小寫
- `has_many` 後面必須是複數
- `controller` 都是複數, 例如 `users_controller`

```
class UsersController < ApplicationController
end
```

- 數據庫的表明都是複數, 例如`users`表.


# 作業

1.使用 mysql, mysql work bench, 創建 兩個表：

媽媽表 ： 孩子表 =  1 ： N

插入一些數據：   王媽媽，  小李， 小明。

  - 1.1 使用純 SQL語句： 查詢 小李的媽媽。
  - 1.2 創建一個rails項目，創建相關的model. 然後在 Rails console 中， 查詢 小李的媽媽。
  - 1.3 創建一個路由:  /students/find_mother_by_student_name

訪問後, 會在頁面(erb)上展示結果.

2.使用 mysql, mysql work bench, 創建 3個表：

   - 2.1  students
   - 2.2  teachers
   - 2.3  lessons

實現：  students : teachers = n : n
加入若干數據。
然後根據 某個學生的名字，查出它的所有老師。
也是： 又用SQL， 又要用 Rails console來實現。

創建一個路由:  `/students/find_teachers_by_student_name`
訪問後, 會在頁面(erb)上展示結果.
