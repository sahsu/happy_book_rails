# Routes 路由

路由就是告诉Web应用：应该用哪个controller/action来处理某个url.

路由看不懂，没法使用Rails, 也没法学会Controller, 没法学会`form_tag`

重点学会使用 `resources`路由。

下面3种路由了解即可：(自行到官网上看文档即可）

- namespace.
- match
- get ... to

其他的都不用看。

我们在项目中， 不用那些稀奇古怪的知识。

看到resources, 就应该能瞬间算出它生成的7种路由，能瞬间说出某个路由对应的action。

路由文件在Rails中是通过`config/routes.rb`这个文件定义的

## resources 路由

路由就是根据不同的请求类型和路径来获取各种资源。 下面是RESTful的7种路由：

- POST: `create`,  (创建资源）
- PUT或PATCH： `update`, (更新）
- GET:  `index`, `show`, `new`, `edit`(只读取数据，不修改数据)
- DELETE: `destroy` (删除)

所以， 在RESTful中，不同的http request类型，就决定了这个请求是要对数据库进行什么操作

在Rails中如何实现对RESTful进行解析的呢？

`config/routes.rb` 中：

```ruby
resources :books
```

上面一句，就直接定义了7种路由：

```
GET  /books         index     显示 book的列表页
GET  /books/new     new       显示 book的新建页面。
GET  /books/3       show      显示id是3的book
GET  /books/3/edit  edit      显示 book(id =3)的编辑页面。
PUT  /books/3       update    对id = 3的book进行修改 （后面还会紧跟一大串的参数)
POST /books         create    对books进行创建（后面也有一大堆参数)
DELETE  /books/3    destroy   对 id=3的 book 进行删除操作。
```

可以使用 `$ rake routes` 就可以查看当前项目中所有的路由

```
             POST     /books(.:format)             books#create
    new_book GET      /books/new(.:format)         books#new
   edit_book GET      /books/:id/edit(.:format)    books#edit
        book GET      /books/:id(.:format)         books#show
             PATCH    /books/:id(.:format)         books#update
             PUT      /books/:id(.:format)         books#update
             DELETE   /books/:id(.:format)         books#destroy
```

上面的表格写的比较简略，我们把它整理一下,如下表格：

|url 的名字|REST方法 | 对应的url 的表达式  |  对应的 controller#action|
|--:|---|---|---|
|books_path       | POST    |  /books(.:format)  |           books#create|
|new_book_path | GET     |  /books/new(.:format) |        books#new|
|edit_book_path | GET     | /books/:id/edit(.:format)   | books#edit|
|book_path | GET     | /books/:id(.:format)        | books#show|
|book_path | PATCH   | /books/:id(.:format)        | books#update|
|book_path | PUT     | /books/:id(.:format)        | books#update|
|book_path | DELETE  | /books/:id(.:format)        | books#destroy|

第一列中大家见到的`xx_path`,`xx_url`就是我们以后会经常见到的路由形式. `book_path`等同于`book_url`.


## resources下的collection路由

例如，我们希望创建一个新的路由，该路由的作用是允许用户根据作者名字进行查询，可以匹配下面的url请求：

- GET请求：`/books/search_by_author_name?name=罗贯中`
- GET请求：`/books/search_by_author_name?name=刘慈欣`

我们一般这样做：

为 `config/routes.rb`文件添加如下内容：

```
resources :books do
  collection do
    get :search_by_author_name
  end
end
```

然后，我们找到对应的`books_controller`, 添加这个action就可以了。

```
class BooksController < ApplicationController
  def search_by_author_name
    # 这里是处理代码。。。
  end
end
```

resources下也有一种member路由，这个路由跟collection几乎一样，所以略过。

## get 路由

```
get 'say/hi_names' => 'say#hi_names'
```
上面表示，对于任何`/say/hi_names`的GET请求，都由`say_controller`的`hi_names`action来处理

## root 路由

```
root 'say#hi'
```

上面表示：对于任何`/`的请求，都由`say_controller`的`hi`action来处理。

## match路由

```
match 'photos', to: 'photos#show', via: [:get, :post]
```

上面表示：对于任何`/photos`的请求(包括GET和POST两种方式), 都由`photos_controller`的`show`action来处理。

# 作业

本节没有作业，需要跟下一节：controller学习完之后再一起做。

