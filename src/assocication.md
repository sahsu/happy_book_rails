# 数据库关联

关联关系，是最重要的数据库的知识。总共有3种关联关系：

1. 一对多
2. 一对一（一对多的特殊情况）
3. 多对多（包含中间表的一对多）

所以，我们只要把一对多的关系学习好即可。

本节用于快速入门，在实际工作中需要多多学习官方文档: https://guides.rubyonrails.org/association_basics.html

## 最简单的关联关系： 一对多

假如王妈妈有两个孩子。小明和小亮。

可以说： 王妈妈有多个孩子。

可以说:

小明，只有一个妈妈。
小王，只有一个妈妈。

### 用数据库结构来表示

妈妈mothers 表

id | name
-- | --
1  | 王妈妈

儿子sons表（包含了一个列：`mother_id`）

id   |  name |  mother_id
 --  |   --  |  --
100  |  小王 |  1
101  |  小明 |  1

上面的 `mother_id` 列， 就是外键。(foreign key) (表示该行对应mother表中的某个记录）

可以看出: 外键的值，其实是另一个表的id 的值。

### 创建migration
我们使用migration来创建这两个表：

Mothers:

```
$ bundle exec rails g migration create_mothers
      invoke  active_record
      create    db/migrate/20210131013530_create_mothers.rb
```

内容该文件内容如下：
```
class CreateMothers < ActiveRecord::Migration
  def change
    create_table :mothers do |t|
      t.string :name
    end
  end
end
```

为sons表创建migration:

```
$ bundle exec rails g migration create_sons
      invoke  active_record
      create    db/migrate/20210131013535_create_sons.rb
```

内容如下：
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

执行命令，创建两个表：
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

### 创建model

增加`app/models/mother.rb`, 内容如下：

```
class Mother < ActiveRecord::Base
  has_many :sons
end
```

上面的代码中：

- `has_many` 是ActiveRecord自带的方法，
- `has_many :sons`表示当前的model包含多个 sons

增加`app/models/son.rb`, 内容如下：

```
class Son < ActiveRecord::Base
  belongs_to :mother
end
```

上面的代码中：

- `belongs_to` 是ActiveRecord自带的方法，
- `belongs_to :mother`表示当前的model属于一个mother

### 增加初始化数据

进入到rails console:

```
irb> mother = Mother.create name: '王妈妈'
irb> Son.create name: '小王', mother_id: mother.id
irb> Son.create name: '小明', mother_id: mother.id
```

可以看到，mother表和sons 表都增加了对应的数据。

mothers表：
```
mysql> select * from mothers;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 王妈妈    |
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

### 原生SQL查询

如果我们要找出孩子“小王”对应的妈妈。

```
select * from mothers
  join sons
  on sons.mother_id = mothers.id
  where sons.name = '小王'
```

会得到这个结果
```
+----+-----------+----+--------+-----------+
| id | name      | id | name   | mother_id |
+----+-----------+----+--------+-----------+
|  1 | 王妈妈    |  1 | 小王   |         1 |
+----+-----------+----+--------+-----------+
```


### 在Rails中实现关联查询

然后，我就可以在 Rails Console 中：

```
irb > xiao_wang = Son.first
```

就会生成SQL：

```
select * from sons where id = 1;
```

我们还可以轻易的从 `xiao_wang` 找到他的妈妈:

```
mama = xiao_wang.mother
```

这个 `.mother` 方法就是由 `class Son`的`belongs_to :mother`这句话生成的。

上面的代码会被转换成下面的SQL语句, 然后被执行.

```
select * from mothers
	join sons
	on sons.mother_id = mothers.id
	where sons.id = 1
```

## Rails 是如何 根据 ORM配置，来自动生成上面的复杂的 SQL 语句的？

最初的配置：

```
class Son < ActiveRecord::Base
  belongs_to :mother
end
```

等同于下面的：

```
class Son < ActiveRecord::Base
  belongs_to :mother, :class => 'Mother', :foreign_key => 'mother_id'
end
```

这个就是Rails最典型的 根据 惯例来编程。

1.`belongs_to :mother`, rails就能判断出：  mothers 表，是一的那一端。
而当前class 是： "class Son", 那么rails 就知道了 两个表的对应关系。

2.`:class => 'Mother'`, 表示， 一的那一端， 对应的model class是Mother.
根据rails的惯例， Mother model对应的是 数据库中的 mothers 表。

3.`:foreign_key => 'mother_id'`, rails就知道了， 外键是 'mother_id'.
而一对多关系中， 外键是保存在 多的那一端（也就是 sons, 所以说，在 sons表中，
必须有一个列， 叫做： `mother_id` )

所以，这个复杂的SQL 条件就齐备了， 可以生成了。

上面的ruby代码，配置好之后， 就可以这样调用：

```
son = Son.first

# .mother方法，  是由 class Son 中的 belongs_to 产生的。
son.mother

mother = Mother.first

# .sons 方法，  是由 class Mother 中的 hash_many  产生的。
mother.sons
```

## 一对一： 一对多的特例。

在一对多关系中，用到的关键方法是：`has_many/belongs_to`

在一对一关系中，可以用：`has_one/belongs_to`

例如，最典型的1:1的关系是老公和老婆.

一个老公：有一个老婆。


### 创建数据库的表

创建老婆表

```
$ bundle exec rails g migration create_wives
      invoke  active_record
      create    db/migrate/20210131025033_create_wives.rb
```

文件`db/migrate/20210131025033_create_wives.rb` 内容如下：
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

创建对应的model `app/models/wife.rb`, 内容如下：

```
class Wife < ActiveRecord::Base
  belongs_to :husband
end
```

注意：这里是`belongs_to`, 所以我们在wife表中增加外键`husband_id`

创建老公表：


```
$ bundle exec rails g migration create_husbands
      invoke  active_record
      create    db/migrate/20210131025043_create_husbands.rb
```

文件`db/migrate/20210131025043_create_husbands.rb`的内容如下：

```
class CreateHusbands < ActiveRecord::Migration
  def change
    create_table :husbands do |t|
      t.string :name
    end
  end
end
```

创建对应的model `app/models/husband.rb`, 内容如下：

```
class Husband < ActiveRecord::Base
  has_one :wife
end
```

运行migration:

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

可以看到，2个表的结构都已经生成了。

### 添加数据

```
$ bundle exec rails c
irb> a = Husband.create name: '李爸爸'
irb> b = Wife.create name: '王妈妈', husband_id: a.id
```

可以看到，此时的数据库内容：

```
mysql> select * from wives;
+----+-----------+------------+
| id | name      | husband_id |
+----+-----------+------------+
|  1 | 王妈妈    |          1 |
+----+-----------+------------+

mysql> select * from husbands;
+----+-----------+
| id | name      |
+----+-----------+
|  1 | 李爸爸    |
+----+-----------+
```

查询:

```
irb> Wife.first.husband
=> #<Husband id: 1, name: "李爸爸">

irb(main):007:0> Husband.first.wife
=> #<Wife id: 1, name: "王妈妈", husband_id: 1>
```

## 多对多

下面是最典型的多对多关系：

- 一个学生有多个老师（ 学习了多门课程）
- 一个老师可以教多个孩子（教一门课程，但是有好多学生来听这个课程）

### 创建表结构

为students表创建migration:

```
$ bundle exec rails g migration create_students
      invoke  active_record
      create    db/migrate/20210131073802_create_students.rb
```

`db/migrate/20210131073802_create_students.rb`内容如下：

```
class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
    end
  end
end
```

同时创建对应的model `app/models/student.rb`

```
class Student < ActiveRecord::Base
  has_many :lessons
  has_many :teachers, :through => :lessons
end
```

为teachers表创建migration


```
$ bundle exec rails g migration create_teachers
      invoke  active_record
      create    db/migrate/20210131073807_create_teachers.rb
```

`db/migrate/20210131073807_create_teachers.rb` 的内容如下：

```
class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :name
    end
  end
end
```

设置对应的model: `app/models/teacher.rb`

```
class Teacher < ActiveRecord::Base
  has_many :lessons
  has_many :students, :through => :lessons
end
```

为中间表lessons创建migration:

```
$ bundle exec rails g migration create_lessons
      invoke  active_record
      create    db/migrate/20210131073822_create_lessons.rb
```

`db/migrate/20210131073822_create_lessons.rb`内容如下：

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

创建对应的model  `app/models/lesson.rb` 内容如下：

```
class Lesson < ActiveRecord::Base
  belongs_to :student
  belongs_to :teacher
end
```

然后，我们运行migration , 创建对应的表：

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

### 初始化数据


我们在Rails控制台中，运行如下代码:

```
irb> ['小王', '小明', '小红'].each { |name|  Student.create name: name}
irb> ['物理老师','化学老师'].each { |name| Teacher.create name: name }
```

数据库中就会得到对应的数据：

```
mysql> select * from students;
+----+--------+
| id | name   |
+----+--------+
|  1 | 小王   |
|  2 | 小明   |
|  3 | 小红   |
+----+--------+

mysql> select * from teachers;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 物理老师     |
|  2 | 化学老师     |
+----+--------------+
```

接下来，我们通过为中间表lessons增加数据，来实现多对多的关系：

物理老师教了3个孩子：小王，小明和小红

```
irb> ['小王', '小明', '小红'].each do |student_name|
irb>    student = Student.find_by_name student_name
irb>    teacher = Teacher.find_by_name '物理老师'
irb>    Lesson.create name: '物理课', student_id: student.id, teacher_id: teacher.id
irb>  end
```

化学老师教了2个孩子：小王和小红。

```
irb> ['小王', '小红'].each do |student_name|
irb>   student = Student.find_by_name student_name
irb>   teacher = Teacher.find_by_name '化学老师'
irb>   Lesson.create name: '化学课', student_id: student.id, teacher_id: teacher.id
irb> end
```

可以看到，数据库中已经存在了下面的数据：

```
mysql> select * from lessons;
+----+-----------+------------+------------+
| id | name      | teacher_id | student_id |
+----+-----------+------------+------------+
|  1 | 物理课    |          1 |          1 |
|  2 | 物理课    |          1 |          2 |
|  3 | 物理课    |          1 |          3 |
|  4 | 化学课    |          2 |          1 |
|  5 | 化学课    |          2 |          3 |
+----+-----------+------------+------------+
```

进行一些查询：

小红的所有老师的名字：

```
irb(main):001:0> Student.find_by_name('小红').teachers.each { |teacher| puts teacher.name }
  Student Load (0.4ms)  SELECT  `students`.* FROM `students` WHERE `students`.`name` = '小红' LIMIT 1
  Teacher Load (0.7ms)  SELECT `teachers`.* FROM `teachers` INNER JOIN `lessons` ON `teachers`.`id` = `lessons`.`teacher_id` WHERE `lessons`.`student_id` = 3
物理老师
化学老师
```

可以看到，Rails分别生成了2条SQL语句，并且在第二条SQL中使用了JOIN查询

### 使用join 查询

在很多时候，我们需要在where与join配合才能进行查询。例如：

找出符合下面条件的所有学生
1. 姓名包含"红",
2. 老师的名字中包含"物理"

我们可以这样做：

```
irb> Student.joins(:teachers).where('students.name like ? and teachers.name like ?',
        '%红%', '%物理%').each { |student| puts student.inspect }
```

会看到，生成对应的SQL是：

```SQL
SELECT students.* FROM students
  INNER JOIN lessons
  ON lessons.student_id = students.id
  INNER JOIN teachers
  ON teachers.id = lessons.teacher_id
  WHERE (students.name like '%红%' and teachers.name like '%物理%')
```

得到的结果：

```
#<Student id: 3, name: "小红">
```

### 回顾一下多对多的代码

可以发现，在Rails中，多对多的关系是有 `has_many` 来实现的。

```
class Student
  has_many :lessons
  has_many :teachers, :through => :lessons
  # 上面的简写， 相当于：
  has_many :teachers, :class => 'Teacher', :foreign_key => 'teacher_id', :throught => :lessons
end
```

```
class Teachers
  has_many :lessons
  has_many :students, :through => :lessons
end
```

### 注意： 多对多关联不要学习 `has_many_and_belongs_to`

因为这个方法会生成一个无意义的只包含外键的中间表。例如：

表名： `student_teachers`

student_id |  teacher_id
-- | --
1      |      100
2      |      100
3      |      100

1. 表名不明确。不要使用 `a_bs` 这样的表名。对应model比较难写。 (`app/models/a_b.rb` 吗？)
2. 任何一个中间表都应该是有意义的。绝大部分时候，中间表都是有正常的列的。与其以后通过migration加上这个列，不如一开始就不要使用 `has_many_and_belongs_to`
这样的方式来声明（声明之后， model 的名字就定下来了。难改）

### 多对多关联时对"中间表"的命名。

中间表一定要有"有意义的"名字。不能叫：中间表1，中间表2.

有个不太好用但是也将就能用的模式： `A_Bs` , 例如： `student_teachers`, 但是它不如`lessons`可读性强。

好的名字:

- 商品 与 顾客 的中间表是 订单
- 学生 与 老师 的中间表是 课程(或成绩)

## `has_many`与`belongs_to` 会自动生成一系列的方法

例如：

```
class Mother < ActiveRecord::Base
  has_many :sons
end

wangmama = Mother.first
```

Mother 自动获得了 16个方法, 下面表中，左侧是API， 右侧就是例子：


API 原文 |  对于我们上面的例子
 -- | --
collection(force_reload = false)   |   wangmama.sons
collection<<(object, ...)          |   wangmama.sons << Son.create({... })
collection.delete(object, ...)     |   wangmama.sons.delete
collection.destroy(object, ...)    |   wangmama.sons.destroy
collection=objects                 |   wangmama.sons=
collection_singular_ids            |   wangmama.son_id
collection.create(attributes = {})	|  wangmama.sons.create(...)

总共16个.不过,这些方法中,常用的只有一两个.大家可以参考文档.

## destroy 与 delete 区别？

- destroy 会删掉关联表的数据（通过调用关联表的方法）
- delete  不会。只会删掉当前对象对应的表。

例子：

老王去世了。老王有20张银行卡。

那么：
```
laowang.destroy    (老王的银行卡也会被删掉）

laowang.delete  （只删掉老王， 保留银行卡）
```

## 级联删除

级联删除, 就是我们把一对多中, "一"的那一端删掉, 那么"多"的那一端的所有关联数据,也要一起删掉.

在Rails中,我们使用 `dependency => :destroy` 来实现.

例如: 某个人去世后,他的银行卡应该都被注销掉. 那么就可以这样写:

```
class Person < ActiveRecord::Base
  has_many :cards
end

class Card < ActiveRecord::Base
  # 下面这句，表示： person一旦被删除， 该card也会自动被删除。
  belongs_to :person, :dependency => :destroy
end
```

实战中，不要用级联删除。（不要一条命令，删掉多个表的数据）

- 好处： 删的比较干净。 很清爽。
- 缺点： 大项目或者公司内的项目，一般都不允许删除。很多项目用“disabled” 来代替删除。

## 军规

1. 关联务必写全两端！ 无论`1：N`， `N:N`, 都要写全两端。否则会出初学者看不懂的错误。
另外，写全了两端对于理解代码是特别有好处的。

2. 掌握好单数和复数.

- model 名字是单数, 例如 app/models/user.rb,

```
class User < ActiveRecord::Base
end
```

- `belongs_to` 后面必须是单数, 都是小写
- `has_many` 后面必须是复数
- `controller` 都是复数, 例如 `users_controller`

```
class UsersController < ApplicationController
end
```

- 数据库的表明都是复数, 例如`users`表.


# 作业

1.使用 mysql, mysql work bench, 创建 两个表：

妈妈表 ： 孩子表 =  1 ： N

插入一些数据：   王妈妈，  小李， 小明。

  - 1.1 使用纯 SQL语句： 查询 小李的妈妈。
  - 1.2 创建一个rails项目，创建相关的model. 然后在 Rails console 中， 查询 小李的妈妈。
  - 1.3 创建一个路由:  /students/find_mother_by_student_name

访问后, 会在页面(erb)上展示结果.

2.使用 mysql, mysql work bench, 创建 3个表：

   - 2.1  students
   - 2.2  teachers
   - 2.3  lessons

实现：  students : teachers = n : n
加入若干数据。
然后根据 某个学生的名字，查出它的所有老师。
也是： 又用SQL， 又要用 Rails console来实现。

创建一个路由:  `/students/find_teachers_by_student_name`
访问后, 会在页面(erb)上展示结果.
