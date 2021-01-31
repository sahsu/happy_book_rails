# 数据库关联

关联关系，是最重要的数据库的知识。总共有3种关联关系：

1. 一对多
2. 一对一（一对多的特殊情况）
3. 多对多（包含中间表的一对多）

所以，我们只要把一对多的关系学习好即可。

## 最简单的关联关系： 一对多

假如王妈妈有两个孩子。小明和小亮。

可以说： 王妈妈有多个孩子。

可以说:

小明，只有一个妈妈。
小王，只有一个妈妈。

### 用数据库结构来表示

也就是说，有两给表

妈妈mothers 表:

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

### 用SQL来表示

如果我们要找出孩子“小王”对应的妈妈。

```
   select * from mothers
        join sons
        on sons.mother_id = mothers.id
        where sons.name = '小王'
```

(复习一下SQL的知识，上面的SQL语句，会给到我们一个大表）

mothers.id | mothers.name | sons.id   |  sons.name |  sons.mother_id
-----------| ------------ | --------  |  --------  |  --------------
1          | 王妈妈       | 100       |  小王      |  1

### 在Rails中实现关联关系`has_many`,`belongs_to`

一个妈妈可以有多个孩子:

```
class Mother < ActiveRecord::Base
  has_many :sons
end
```

一个儿子属于一个妈妈:

```
class Son < ActiveRecord::Base
  belongs_to :mother
end
```

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

所以， 这个复杂的SQL 条件就齐备了， 可以生成了。

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

一对多：   `has_many/belongs_to`

一对一：   `has_one/belongs_to`


老婆和老公的例子:

一个老婆：  有一个老公

```
class Wife < ActiveRecord::base
  belongs_to :husband
end
```

一个老公：  有一个老婆。

```
class Husband < ActiveRecord::base
  has_one :wife
end
```


wivies表

id |   name
-- | --
1  |  王妈妈

husbands表

id  | name
 -- | --
200 | 李爸爸

那么，外键放在哪个表都可以。 ( 我们可以在 `wivies`表，增加一个列， 叫`husband_id`,
也可以在`husbands`表，增加一个列， 叫`wife_id` )

## 多对多

一个学生， 有多个老师 （ 学习了多门课程）
一个老师，可以教多个孩子 （教一门课程，但是有好多学生来听这个课程）


### 表结构

students , 学生表

id  | name
-- | --
1   | 小王
2   | 小明
3   | 小红

teachers, 老师表

id  | name
 -- | --
100 | 王老师
200 | 李老师


目前看来， 把外键，放在任何一个表中都不满足需求。 所以需要中间表: 课程。

lessons, 课程

id   |name    | student_id  |   teacher_id
---- |------- | ----------- |   -----------
1000 |物理课  | 1(小王id)   |   100(王老师）
2000 |物理课  | 2(小明id)   |   100(王老师）
3000 |物理课  | 3(小红id)   |   100(王老师）
4000 |化学课  | 1(小王id)   |   200(李老师）
5000 |化学课  | 3(小红id)   |   200(李老师）

从上表中，可以看出，

王老师， 上的是物理课， 教了 3个孩子：  小王，小明和小红
李老师， 上的是化学课， 教了 2个孩子：  小王和小红。

### 传统的SQL语句,其实很麻烦的.

小王都有哪些老师？ (一个SQL例子）

```
select teachers.*, students.*, lessons.*
    from lessons   //因为找的是老师，我们就要 from teachers ,

    join teachers
    on lessons.teacher_id = teachers.id  // 通过中间表，把老师 join 弄过来

    join students
    on lessons.student_id = students.id  // 通过中间表，把学生 join 弄过来

    where students.name = '小王'
```

这个 复杂的SQL, 会在where之前， 生成下面的表：

teachers. id |teachers. name |students. id |students. name |lessons. id |lessons. name |lessons. student_id| lessons. teacher_id
------------ |-------------- |------------ |-------------- |----------- |------------- |----------------- | ------
100         |   王老师     |  1         |   小王   |      1000   |  物理成绩   |    1            |      100
100         |   王老师     |  2         |   小明   |      2000   |  物理成绩   |    2            |      100
100         |   王老师     |  3         |   小红   |      3000   |  物理成绩   |    3            |      100
200         |   李老师     |  1         |   小王   |      4000   |  化学成绩   |    1            |      200
200         |   李老师     |  3         |   小王   |      5000   |  化学成绩   |    3            |      200

跟下面的"中间表"(这个中间表，指的是： 存在于多对多关系两个表 之间的表。 ）是严格相对的：

id   |name   |  student_id   |  teacher_id
 -- | -- | -- | --
1000 |物理成绩  | 1(小王id)  |    100(王老师）
2000 |物理成绩  | 2(小明id)  |    100(王老师）
3000 |物理成绩  | 3(小红id)  |    100(王老师）
4000 |化学成绩  | 1(小王id)  |    200(李老师）
5000 |化学成绩  | 3(小红id)  |    200(李老师）

### 用代码来表示

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

上面的代码定义完之后，就可以实现这个了：

小王都有哪些老师？ (同SQL例子）
```
Student.find_by_name('小王').teachers
```

如果你不需要查询：王老师，有哪些学生？，就不需要定义 class Teacher里的  has_many :students

所以说，rails中的定义非常灵活。 但是在实战中，建议大家都老老实实的加上。 这样当你的同事，
如果之前哪怕不知道有student这个model, 但看到了teacher这个model, 也就知道了teacher与student的关系了。

另外，从实现模式的角度讲， 也要两端都加上这个`has_many` 的声明。

### 注意： 多对多关联不要学习 `has_many_and_belongs_to`

为什么？

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

中间表，一定要有名字。不能叫： 中间表1， 中间表2.

有个不太好用，但是也将就能用的模式：  `A_Bs` , 例如： `student_teachers`, 但是它不如`lessons`可读性强。

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

总共16个. 其他的略.

不过,这些方法中,常用的只有一两个.大家可以参考文档.

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
