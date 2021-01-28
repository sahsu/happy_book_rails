# 新手入门不用学的东西

以下内容在新手入门的时候不用学习，因为根据经验来看，这些内容会对新手造成困扰。

## `csrf_token` 在学习前可以省略掉。

在`application_controller.rb`注释掉 `protect_from_forgery`

```
class ApplicationController < ActionController::Base
#   protect_from_forgery with: :exception
end
```

##  asset pipe line

会在部署的时候给你带来大麻烦

可以在`config/application.rb`中暂时把它注释掉，这个可以在整体学完之后再学:

```
config.assets.enabled = false
```

## scaffold

仅用于新手入门和了解。但是做项目时，不要依赖它。

仅仅把它用在学习的过程中。例如，我希望知道，一个完整的 CRUD， 是需要哪些文件来配合的。那么一个最快速的办法就是使用

```
$ rails g scaffold users  name:string ..
```

这个命令来生成,就能看到：

会生成controller, model, view, helper ... 所有依赖的文件。也会生成 migration 等等。

根据我的经验，依赖这个命令（以及类似命令 rails g model, rails g controller）的新人，入门的速度会最长达3个月。
但是，不依赖这个命令，所有的CRUD都自己手写的人，可以在 2~3周入门。

## form validation 表单验证

在服务器端，验证一个 form object , 是否符合要求。例如，name是否是空, email 是否是xx@yy.com 这个格式。

除非特别重要，否则前端验证就足够了

解决办法：直接用jquery validate, 在client端进行验证。

所以，每个`_form.html.erb`中的内容，都要删掉：

```
  <% if @book.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@book.errors.count, "error") %> prohibited this book from being saved:</h2>

      <ul>
      <% @book.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>
```

## 关联关系: 多对多.

忘掉 `has_many_and_belongs_to` .

不用这个，我们要用`has_many` 来代替。

因为多对多的关系，不是由两个对象（表）来决定的,而是由3个表来决定的。例如：

老师-学生 = N:N

1. 有个老师表
2. 有个学生表
3. 有个中间表（课程，成绩）

所以，我们要使用 `has_many` 就可以了，不要用 `has_many_and_belongs_to`

## 尽量不用单表继承

假设有3个对象:

1. 男人
2. 女人
3. 生物

也可以这样设计：

只有一个表, 就叫creatures

```
creatures
-------
id: integer
name: string
type: string
```

表的内容就是:

```
id  name      type
-------------------------
1   '张三丰'  Man
2   '武则天'  Women
3   '青蛙'    Creature
```

对应的class是：

```
class Man < Creature
end

class Woman < Creature
end

class Creature < ActiveRecord::Base
end
```

这就是单表继承。我们可以了解, 但是不要在实际项目中使用。因为Rails中，充满了太多的"按照惯例编程"，这些惯例，很容易会被单表继承所破坏。

例如： `form_for @man` ,rails就会认为"传递给 form_for函数 的 参数@man 的class" 是`Man`, 而不是`Creature`, 那么，该form是要提交到哪个url？

```
- /creatures/2/update
- /men/2/update
```

总之，这里的坑很深，就老老实实的按照惯例编程，不要为了抽象而抽象。

另外，一旦rails用多了，我们就会发现，尽量不要改变`form_for`, `form_tag` 这样的功能。

## i18n 国际化

忘掉它。咱们国内项目永远用不到。而且国际化将来会为你带来巨大的麻烦。例如影响页面CSS的布局等等。

## Plugins

忘掉它。我从来没写过。在我使用ruby的第一年，好像官方就把它抛弃了。(deprecated)

可以写个新的gem

## 不要使用 nested form.

例如：  我在新建 一个文章的时候，就在页面上，增加针对文章的form.
不要：  在这个form中，又新增文章，又新增 该文章的评论。 (因为这个评论是属于这个文章的）

## 不要使用 respond_to 或者 类似的方法。

要么只返回html, 要么只返回json

下面的代码，同时支持两种格式： json, html, 实际上这是鸡肋。
```
def destroy
  @book.destroy
  respond_to do |format|
    format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
    format.json { head :no_content }
  end
end
```

我们在实际操作中，一个路由仅仅对应一种返回格式，这样更好写代码，安全性也更高例如：

```
GET /api/books    # 只支持json
GET /books        # 只支持html
```

## nested routes (嵌套的路由)

- 正常的路由：  `/comments/2`  表示id = 2 的 评论
- 奇怪的路由：  `/posts/50/comments/2`    表示 id = 50的文章的评论中， id = 2 的评论。

问题来了: 如果想找出"辽宁省阜新市海州区第三小学"该怎么找？

- 奇怪的路由：  `/provinces/4/cities/3/schools/2`
- 我干嘛不用：  `/schools/2`  呢？

如果一定要带上前面的参数的话，干嘛不直接这样:

- `/schools/2?province_id=4&city_id=3`

后者我可以加上100个参数，不超过64k的长度（或者2K长度，在IE下）就可以。
如果用 nested routes, 我们就没法开发了

极端例子： `/provinces/4/cities/3/schools/2/grade/5/class/3/student/2`

可惜的是，官方的rails guide中，第一个就是这个例子。

我的建议是：忘掉这个功能。

## routes中，只使用 resources,  不要使用其他的路由

下面这两种都尽量别用:

```
get 'welcome/index'
match ...
```

routes.rb中，只应该出现： `resources`, `root` 两种路由。

## params().require().permit

除非你对 `form_object` 很熟悉了, 否则很多新手会蒙。

应该直接使用`params[:users]`

可以在`config/application.rb`中关闭这个功能:

```
config.action_controller.permit_all_parameters = true
```

## 不要使用turbo links

这个技术，是为了让客户端减少对服务器端的请求。但是效果不理想，很容易引起js的错误。
那么我们在需要的场合，直接使用更加纯粹的single-page-app. (例如vuejs)

1.删掉Gemfile 中的gem:

```
gem 'turbolinks'
```

2.在`app/assets/javascripts/application.js` 中删掉下面的内容：

```
//= require turbolinks
```

3.在`app/views/layouts/application.html.erb` 中删掉下面的内容：

```
"data-turbolinks-track" => true
```
