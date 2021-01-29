# Web开发框架为什么选择Rails

世界上的编程语言有很多: java, javascript, php, python, ruby... 学习了之后我们发现，只能写个算法。此外不能做任何事儿:

- 在网页上显示个表单
- 处理一个request请求
- 处理数据库
- 无法在桌面上，显示一个对话框。

想做的话，需要做大量的底层工作。（把一个请求，转换成XX类，再借助YY类力量，使用W方法）

所以，我们做任何事情，都需要使用框架。(Framework)

常见的框架有：

- java:  Spring, Struts, Hiberate ...
- PHP:  phpcake, ThinkPHP, ...
- Ruby: Rails, Sinatra
- Python: Django, Tornado
- javascript: Vuejs,Angular, React ..

有了框架，我们做起事情来，才会特别简单，得心应手。

在已知的web开发框架中, Rails完胜其他框架。什么叫完胜呢？

1. 开发速度第一: 其他框架一个月，Rails 1～2周。
2. rails把其他的框架的优点,都整合到了一起.
rails = spring + struts + hibernate  + django

学会了rails , 看其他框架,都是换汤不换药. 比如: 上手vuejs就特别快.

另外，现在大火的spring boot等，也都能看到rails的影子

## 开发语言和框架非常重要

例如，PHP开发不是web开发的首选：

1. PHP代码很罗嗦, 跟java一样罗嗦。导致了项目一大，php的代码量跟java 是一样的。
2. 在项目初期，php的代码的开发速度比java快，但是，只要在java项目中，不使用java bean, 那么JSP跟PHP是一样的。
可以认为java的开发速度比php 慢的原因是java在开发时要遵循的条条框框太多了。
3. 维护上：php的代码跟java几乎一样，导致了php 的代码比ruby 代码多的多（可以认为是4，5倍）代码越多， 维护起来就越困难。

当我们面对几根头发的时候，可以很容易的理顺。 (Ruby > python)
当我们面对一个线团的时候，就没法弄了。  （PHP ,java）

Ruby的代码量大约是 Python的 80%。
Ruby的代码量大约是 java的 25%, 或者更少。

所以，我们维护php/java代码的时候会发现，我们需要在各种文件(class)中 跳来跳去。眼花缭乱。

PHP之所以在国内流行，还是因为国人英语差了些。外面教的人很多。

## 数据库迁移

什么是数据库迁移？对数据库的表结构的 修改的管理，或者说，是对数据库的版本控制。

### 数据库迁移的起源

我们知道，管理代码版本，是使用SCM(git, svn)

管理数据库的表结构，则是使用 database migration

git ： 可以取出任意时刻的代码
migration: 可以取出任意时刻的你的数据库的表结构。

所以，它的出现，是为了解决下面的实际问题：两个程序员之间的对于数据库的修改冲突。

小王和小李是两个程序员，一起在做一个项目。

小王，昨天，新增了两个表，改动一个表（删除了一个列，又增加了2个列）

小李，今天早上9点，更新代码，然后运行, 崩溃了。

小李怎么办？

选择1. 在菜鸟项目组。小李问小王： 我崩了。 小王回答：笨蛋。我把我的数据库导出一份给你。小李说，好的，你等着。

第二天，小王更新代码，崩溃了。找小李. 小李说：笨蛋，我把我的数据库导出一份给你。

所以，这个项目组，以后，谁改动数据库，都得吼一声。

选择2. 在好一点儿的项目组：每次数据库结构有了更新，都要导出一个 表的结构的文件, 放到SCM（GIT/SVN）中。其他人
更新代码后，都要把这个表结构文件导入到数据库。

表的结构问题暂时解决了。但是，更大的问题来了：原来的测试数据都没了。

所以，我们的database migration就是为了解决这个问题的。

方式：

把对数据库的操作，变成：

1. 不是通过SQL语句来人肉修改。 而是通过代码来修改。（把对数据库的操作，放到专门的代码文件中，例如  `db/migration/*.rb`, `*.java`)
2. 一个migration, 占用一个文件。

### 例子

例如，我们希望创建一个表 apples, 包含2个列：name, color, 都是字符串类型类型(varchar(255))

1.新建一个文件：    `db/migration/001-create-apples.rb`

```
class CreateApples
  # 每次migrate都会自动执行 up 方法
  def self.up

    create_table 'apples' do  |t|
      add_column 'name', String
      add_column 'color', String
    end
  end

  # 每次回滚，都会自动执行 down方法
  def self.down
    drop_table 'apples'
  end
end
```

说明：

    1.任何一个migration, 都要有 up, down, 这样的话，它才能迁移。（前进的时候调用up, rollback 的时候，调用down)

    2.up 和 down, 永远是对立的操作。

2.运行migration

```
$ rake db:migrate
```

这样就会生成SQL，并且执行。

- `self.up`  会生成 `create table 'apples' .....`
- `slef.down`   会生成   `drop table 'apples' ..`

有了这个形式，小王和小李就可以开心的一起协作了。

每次小王，都把对数据库的改动写进migration中，小李更新完代码后，直接执行 rake db:migrate 就可以了。原来的数据还能保留。

如果在部署的时候发现新的数据库结构不合理，还能rollback回去。
