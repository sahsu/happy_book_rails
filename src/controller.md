# controller

Controller的作用是：

1. 处理request中的参数，例如用户提交的表单  (使用`params`)
2. 处理完毕后，进行页面的渲染或者跳转。(使用`redirect_to` 或者 `render`)

学习本节的时候，直接用最原始的HTML `form`, 不要使用Rails的`form_for`和`form_tag`.

## 开始之前

记得修改 `application_controller.rb` , 把它的 把它的`protect_from_forgery` 注释掉。

```
class ApplicationController < ActionController::Base
  # 注释掉下面这一行
  #protect_from_forgery with: :exception
end
```

上面的代码，要求我们提交表单时，多提交几个参数。我们从学习的目的出发，暂时先把它注释掉。

## 使用controller处理参数

我们知道，最常见的参数有两种来源：

1.url, 例如:  `/books?name=三体`
2.form, 例如：

```
<form action='/books'  method='POST'>
  <input type=text name='name' value='三体' />
  <input type=submit value='搜索' />
</form>
```

在对应的controller中, 可以获得该参数，并打印。

```
class BooksController < ApplicationController
  def index

    # 获得了参数
    name = params[:name]

    # 在控制台中打印了出来。
    puts name.inspect
  end
end
```

## 七个最基础的action

这七个Action都是Rails自带的特殊action, 用于"按照惯例编程".

- `index`: 列表页
- `new`: 新建页。用户在该页面上输入一些数据，点击确定按钮后，会触发create action。
- `create： 创建数据的action. 处理`new`中的form传递过来的参数，保存到数据库。
- `edit`: 显示编辑的页面。 用户在这个页面上输入编辑的数据, 在点击确定按钮后，会触发update action
- `update： 保存数据的action. 处理 `edit` 中的form传递过来的参数，保存到数据库。
- `show`: 详情页 (往往用户是在列表页中，点击某一行的记录，就会跳转到该记录的详情页了）
- `destroy`: 删除action. (往往用户是在列表页中，点击某一行中的“删除”按钮，就会触发该action）

所以，上面7个action, 4个有页面（index, show, edit, new) , 3个无页面(直接操作数据库，操作完之后跳转到某个页面)（例如，显示列表页）

下面我们来依次说明。

### 创建对应的controller和routes

假设，我们在路由(`config/routes.rb`中，定义了：　

```ruby
Rails.application.routes.draw do
  resources :books
end
```

并且，我们定好对应的controller: `app/controllers/books_controller.rb`

```ruby
# 现在这里是一个空的controller, 随着下面的学习，我们会陆续增加7种最基础的action
class BooksController < ApplicationController
end
```

### index (列表)

我们在books controller中，增加：

```ruby
def index
  @books = Book.all
end
```

2.在view( `app/views/books/index.html.erb`) 中显示就可以了：

```
<% @books.each do |book| %>
   <%= book.inspect %>
<% end %>
```

3.在浏览器中，输入`/books` 就可以看到页面了。如下图所示。


### new 与 create

1.回顾下路由：　

```
GET /books/new
POST /books
```

2.在视图中，创建： `app/views/books/new.html.erb`

```
请输入：
<form action='/books' method='POST'>
  <input type='text' name='the_name'/>
  <input type='submit' value='确定'/>
</form>
```

3.在controller中：

```
  def new
  end

  def create
    Book.create :name => params[:the_name]
    redirect_to books_path
  end
```

4.这时候，用户直接打开　`/books/new`，　就可以看到　'new'这个页面。

5.输入数据之后，点击“确定”，　就会触发 `create` action
,就可以看到数据库中多了一条这个记录。 并且，会跳转到　`/books`这个页面。

### edit 与 update

1.回顾一下，`resources :books`会提供7种路由，跟edit相关的路由是：

```
GET /books/:id/edit
PUT /books/:id
PATCH /books/:id
```

`PUT`与`PATCH`都对应着`update`action. 所以，我们忽略PATCH这个路由。

2.在列表页中， 为每个记录，都增加一个链接：
修改 `app/views/books/index.html.erb`

```erb
<% @books.each do |book| %>
  <%= book.inspect%> ,
  <%= link_to '编辑', edit_book_path( :id => book.id )%>
  <br/>
<% end %>
```

3.在“编辑页”中，增加一个表单。
修改 `app/views/books/edit.html.erb`

```html
请输入：
<form action='/books' method='POST'>
  <input type='text' name='the_name'/>
  <input type='submit' value='确定'/>
</form>
```

4.增加`edit`action

```
def edit
  @book = Book.find params[:id]
end
```

5.在view中增加表单的默认值, 把原来的`input name='the_name'`,修改成：　
```
<input type='text' name='the_name' value=<%= @book.name  %>/>
```

5.继续修改view, 增加下面的`<hidden>`标签:

```
<input type='hidden' name='_method' value='put' />
```
`_method=put`告诉rails这个form 是以put形式发起的请求, Rails才会把这个form用对应的action来处理（update）

6.修改`form`的`action`：
```
<form action="/books/<%= @teacher.id %>/edit" method='POST'>
```

完整的view

```
请输入：
<form action="/books/<%= @teacher.id %>" method='POST'>
  <input type='hidden' name='_method' value='put' />
  <input type='text' name='the_name' value='<%= @teacher.name %>'/>
  <input type='submit' value='确定'/>
</form>
```

生成的 html例子：

```
请输入：
<form action="/books/14" method='POST'>
  <input type='hidden' name='_method' value='put' />
  <input type='text' name='the_name' value='linux的安装调试'/>
  <input type='submit' value='确定'/>
</form>
```

输入值，点击 确认， 就会发起一个请求：

```
PUT /books/14
```

7.增加`update` action:
```
def update
  book = Book.find params[:id]
  book.name = params[:the_name]
  book.save
  redirect_to books_path
end
```

### 查看详情

1.根据路由

```
GET    /books/:id
```

2.在controller中，增加　

```
def show
  @book = Book.find [:id]
end
```

3.在`app/views/books/show.html.erb`中，增加:
```html
<h3>详情页</h3>
<%= @book.name %>
```

### 删除


1.根据路由：

```
DELETE /books/:id
```

2.在列表页中为每个记录都增加一个链接. 修改 `app/views/books/index.html.erb`文件

```
<% @books.each do |book| %>
  <%= book.inspect%> ,
  <%= link_to "删除", "/books/#{book.id}", :method => 'delete'%>
  <br/>
<% end %>
```

3.在controller中，增加　

```
def destroy
  @book = Book.find [:id]
  @book.delete
  redirect_to books_path
end
```

4.在列表页中，点击任意一行记录对应的删除，就可以触发这个`destroy` action了。

数据库就会删除对应的记录，然后页面会显示 “列表页”


## redirect_to 的用法

1.可以跳转到有效的URL, 例如：

```
redirect_to books_path
redirect_to '/books'
```

2.也可以使用`:back`(最新Rails版本不支持) .

```
redirect_to :back
```

## 军规

1.7个默认的路由(`index`, `show`, `new`, `edit`, `update`, `destroy`, `create`)，不能被覆盖。 例如：

```
resouces :books do
  collection do
    get :new  # 这样不行，不要重复定义路由。
  end
end
```

2.`redirect_to` 或者`render`只能有一个。并且这两者都只能出现在action的最后一行.
它们相当于方法的`return`，执行完之后不会往下面继续执行。

```
def create
  Teacher.create :name => params[:the_name]

  # 下面的render 与redirect_to 不能同时存在，否则会报错
  render :text => 'ok'
  redirect_to books_path
end
```

## 作业

1.新建rails项目, market

2.新建两个页面:

2.1 水果列表页,`/fruits/list` 内容显示　三种水果列表就可以了．

2.2 水果的新建页, `/fruits/new` 显示啥都行

3.列表页中，下方有个链接，可以跳转到新建页．

4.新建页中，下方有个链接，可以跳转到列表页．

要使用`named_routes`  (`xx_path`) 这样的形式．　

- (错误例子)　`<a href='/fruits/list'>xx</a>`
- (正确例子)　`<a href='<%= list_fruits_path %>'>xx</a>`
- (正确例子)　`<%= link_to 'xx', list_fruits_path %>`

5.要有`root_path` (访问 `/`  的时候，　要显示页面，"欢迎来到某某水果超市!" )

6.有个接口:  访问 `/interface/fruits/all` 的时候, 要给到json结果:

(提示: 使用namespace路由)

```
{
  "result": ['香蕉', '苹果', '橘子']
}

```

(渲染json 的时候, 使用 render :json => ... )

7.实现对fruits 的列表页，新增，编辑，删除功能。

8.列表页要有查询，例如输入 "葡"，就会显示名字中带有"葡"的水果
