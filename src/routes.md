# 路由

## 学习目的

了解一些： namespace.
了解一些： match
了解一些:  get ... to
就够了。

其他的都不用看。
非资源式路由。
定制资源式路由，不用看。

我们在项目中， 不用那些稀奇古怪的知识。

看到 resources, 就应该能瞬间算出它生成的7种路由，能瞬间说出某个路由对应的action。

## 概念

路由，就是根据不同的请求类型和路径，来获取各种资源。

- POST: create,  (创建资源）
- PUT/PATCH： update, (更新）
- GET:  index, show, new, edit, (只读取数据，不修改数据)
- DELETE: destroy (删除)

所以， 在RESTful中，不同的http request类型，就决定了你是要对数据库进行什么操作（增，删，改，还是只读？）

在Rails中如何实现对RESTful进行解析的呢？

`config/routes.rb` 中：

```ruby
resources :users
```

上面一句，就直接定义了7种路由：

```
GET  /users         index     显示 user的列表页
GET  /users/new     new       显示 user的新建页面。
GET  /users/3       show      显示id是3的user
GET  /users/3/edit  edit      显示 user(id =3)的编辑页面。
PUT  /users/3       update    对id = 3的user进行修改 （后面还会紧跟一大串的参数)
POST /users         create    对users进行创建（后面也有一大堆参数)
DELETE  /users/3    destroy   对 id=3的 user 进行删除操作。
```

可以使用 `$ rake routes` 就可以查看当前项目中所有的路由


## Rails中的各种 `_path`,`_url` 的来历

下面的代码, 来自某个项目中的命令:  `$ rake routes`:

```
             POST     /travels(.:format)             travels#create
  new_travel GET      /travels/new(.:format)         travels#new
 edit_travel GET      /travels/:id/edit(.:format)    travels#edit
      travel GET      /travels/:id(.:format)         travels#show
             PATCH    /travels/:id(.:format)         travels#update
             PUT      /travels/:id(.:format)         travels#update
             DELETE   /travels/:id(.:format)         travels#destroy
```

我把它整理一下,大家就知道内容是什么了:

|url 的名字|REST方法 | 对应的url 的表达式  |  对应的 controller#action|
|--:|---|---|---|
|travels_path       | POST    |  /travels(.:format)  |           travels#create|
|new_travel_path | GET     |  /travels/new(.:format) |        travels#new|
|edit_travel_path | GET     | /travels/:id/edit(.:format)   | travels#edit|
|travel_path | GET     | /travels/:id(.:format)        | travels#show|
|travel_path | PATCH   | /travels/:id(.:format)        | travels#update|
|travel_path | PUT     | /travels/:id(.:format)        | travels#update|
|travel_path | DELETE  | /travels/:id(.:format)        | travels#destroy|

所以, 第一列中大家见到的 `xx_path`, `xx_url` 就是从这里来的. 另外, `travel_path`等同于`travel_url`.

## `<%= form_for %>` 中的 `edit_user_path @user` 是什么东东?

如何编辑某个user?

"/users/1/edit"

写成ruby代码:
1. "/users/" + user.id + "/edit"
2. "/users/#{user.id}/edit"  # string interpolation 插入插值

实际上上面这两种形式，都是外行的风格（比如，之前做java 的同学，
来写ruby , 就是这个风格）

下面是 Rails风格(把可读性发挥到极致）的写法：

最初的形式：
```
<%= edit_user_url({:id => User.first.id}) %>
```

然后，ruby的最外层的方法调用的 ()可以省略：
```
<%= edit_user_url {:id => User.first.id} %> <br/>
```

ruby的最外层的 hash的 {} 可以省略：

```
<%= edit_user_url :id => User.first.id %> <br/>
```

对于rails来说，每个数据库的对象，转换成 string interpolation 的时候，都是默认调用
id方法。

所以,一个默认的model  当它 to_string的时候, 是要返回 id 的.

所以,最终,也就有了这样的写法:

```
<%= edit_user_url User.first %>
```

## controller中的redirect_to 对应的路由

在 controller中，  在 create/ update/ 方法的尾部， 我们需要跳转到其他URL。
会看到这样的代码：

```
def create
  book = Book.create params[:book]
  redirect_to book
end
```

上面的 redirect_to book, 等同于下面2种的任一一种：

```
  redirect_to book_path(:id => book.id)
  redirect_to '/books/' + book.id
```

所以，严格意义上来说，上面的代码是一种简写

# 作业

1.新建rails项目, market

2.新建两个页面:

2.1 水果列表页,`/fruits/list` 内容显示　三种水果列表就可以了．

2.2 水果的新建页, `/fruits/new` 显示啥都行

3.列表页中，下方有个链接，可以跳转到新建页．

4.新建页中，下方有个链接，可以跳转到列表页．

要使用　"named_routes"  (xx_path) 这样的形式．　

- (错误例子)　`<a href='/fruits/list'>xx</a>`
- (正确例子)　`<a href='<%= list_fruits_path %>'>xx</a>`
- (正确例子)　`<%= link_to 'xx', list_fruits_path %>`

5.要有root_path (访问　 /  的时候，　要显示页面，"欢迎来到某某水果超市!" )

6.有个接口:  访问 `/interface/fruits/all` 的时候, 要给到json结果:
(提示: 使用namespace路由)

```
{
  "result": ['香蕉', '苹果', '橘子']
}

```

(渲染json 的时候, 使用 render :json => ... )

7.还可以访问这个url:  `/taste_good` ,  显示页面:  "好好吃啊!"

(提示,使用 match ... to 的写法)


