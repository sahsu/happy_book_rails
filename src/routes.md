# Routes 路由

路由就是告訴Web應用：應該用哪個controller/action來處理某個url.

路由看不懂，沒法使用Rails, 也沒法學會Controller, 沒法學會`form_tag`

重點學會使用 `resources`路由。

下面3種路由瞭解即可：(自行到官網上看文檔即可）

- namespace.
- match
- get ... to

其他的都不用看。

我們在項目中， 不用那些稀奇古怪的知識。

看到resources, 就應該能瞬間算出它生成的7種路由，能瞬間說出某個路由對應的action。

路由文件在Rails中是通過`config/routes.rb`這個文件定義的

## resources 路由

路由就是根據不同的請求類型和路徑來獲取各種資源。 下面是RESTful的7種路由：

- POST: `create`,  (創建資源）
- PUT或PATCH： `update`, (更新）
- GET:  `index`, `show`, `new`, `edit`(只讀取數據，不修改數據)
- DELETE: `destroy` (刪除)

所以， 在RESTful中，不同的http request類型，就決定了這個請求是要對數據庫進行什麼操作

在Rails中如何實現對RESTful進行解析的呢？

`config/routes.rb` 中：

```ruby
resources :books
```

上面一句，就直接定義了7種路由：

```
GET  /books         index     顯示 book的列表頁
GET  /books/new     new       顯示 book的新建頁面。
GET  /books/3       show      顯示id是3的book
GET  /books/3/edit  edit      顯示 book(id =3)的編輯頁面。
PUT  /books/3       update    對id = 3的book進行修改 （後面還會緊跟一大串的參數)
POST /books         create    對books進行創建（後面也有一大堆參數)
DELETE  /books/3    destroy   對 id=3的 book 進行刪除操作。
```

可以使用 `$ rake routes` 就可以查看當前項目中所有的路由

```
             POST     /books(.:format)             books#create
    new_book GET      /books/new(.:format)         books#new
   edit_book GET      /books/:id/edit(.:format)    books#edit
        book GET      /books/:id(.:format)         books#show
             PATCH    /books/:id(.:format)         books#update
             PUT      /books/:id(.:format)         books#update
             DELETE   /books/:id(.:format)         books#destroy
```

上面的表格寫的比較簡略，我們把它整理一下,如下表格：

|url 的名字|REST方法 | 對應的url 的表達式  |  對應的 controller#action|
|--:|---|---|---|
|books_path       | POST    |  /books(.:format)  |           books#create|
|new_book_path | GET     |  /books/new(.:format) |        books#new|
|edit_book_path | GET     | /books/:id/edit(.:format)   | books#edit|
|book_path | GET     | /books/:id(.:format)        | books#show|
|book_path | PATCH   | /books/:id(.:format)        | books#update|
|book_path | PUT     | /books/:id(.:format)        | books#update|
|book_path | DELETE  | /books/:id(.:format)        | books#destroy|

第一列中大家見到的`xx_path`,`xx_url`就是我們以後會經常見到的路由形式. `book_path`等同於`book_url`.


## resources下的collection路由

例如，我們希望創建一個新的路由，該路由的作用是允許用戶根據作者名字進行查詢，可以匹配下面的url請求：

- GET請求：`/books/search_by_author_name?name=羅貫中`
- GET請求：`/books/search_by_author_name?name=劉慈欣`

我們一般這樣做：

爲 `config/routes.rb`文件添加如下內容：

```
resources :books do
  collection do
    get :search_by_author_name
  end
end
```

然後，我們找到對應的`books_controller`, 添加這個action就可以了。

```
class BooksController < ApplicationController
  def search_by_author_name
    # 這裏是處理代碼。。。
  end
end
```

resources下也有一種member路由，這個路由跟collection幾乎一樣，所以略過。

## get 路由

```
get 'say/hi_names' => 'say#hi_names'
```
上面表示，對於任何`/say/hi_names`的GET請求，都由`say_controller`的`hi_names`action來處理

## root 路由

```
root 'say#hi'
```

上面表示：對於任何`/`的請求，都由`say_controller`的`hi`action來處理。

## match路由

```
match 'photos', to: 'photos#show', via: [:get, :post]
```

## namespace

```
namespace :api do
  resources :books do
    get :search
  end
end

```

上面代碼表示：對於任何`/api/books/search`的GET請求,都由下面的action處理：

```
class Api::BooksController < ApplicationController
  def search
    # 邏輯代碼...
  end
end
```

上面表示：對於任何`/photos`的請求(包括GET和POST兩種方式), 都由`photos_controller`的`show`action來處理。

# 作業

本節沒有作業，需要跟下一節：controller學習完之後再一起做。

