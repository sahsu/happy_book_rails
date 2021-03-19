# controller

Controller的作用是：

1. 處理request中的參數，例如用戶提交的表單  (使用`params`)
2. 處理完畢後，進行頁面的渲染或者跳轉。(使用`redirect_to` 或者 `render`)

學習本節的時候，直接用最原始的HTML `form`, 不要使用Rails的`form_for`和`form_tag`.

## 開始之前

記得修改 `application_controller.rb` , 把它的 把它的`protect_from_forgery` 註釋掉。

```
class ApplicationController < ActionController::Base
  # 註釋掉下面這一行
  #protect_from_forgery with: :exception
end
```

上面的代碼，要求我們提交表單時，多提交幾個參數。我們從學習的目的出發，暫時先把它註釋掉。

## 使用controller處理參數

我們知道，最常見的參數有兩種來源：

1.url, 例如:  `/books?name=三體`
2.form, 例如：

```
<form action='/books'  method='POST'>
  <input type=text name='name' value='三體' />
  <input type=submit value='搜索' />
</form>
```

在對應的controller中, 可以獲得該參數，並打印。

```
class BooksController < ApplicationController
  def index

    # 獲得了參數
    name = params[:name]

    # 在控制檯中打印了出來。
    puts name.inspect
  end
end
```

## 七個最基礎的action

這七個Action都是Rails自帶的特殊action, 用於"按照慣例編程".

- `index`: 列表頁
- `new`: 新建頁。用戶在該頁面上輸入一些數據，點擊確定按鈕後，會觸發create action。
- `create： 創建數據的action. 處理`new`中的form傳遞過來的參數，保存到數據庫。
- `edit`: 顯示編輯的頁面。 用戶在這個頁面上輸入編輯的數據, 在點擊確定按鈕後，會觸發update action
- `update： 保存數據的action. 處理 `edit` 中的form傳遞過來的參數，保存到數據庫。
- `show`: 詳情頁 (往往用戶是在列表頁中，點擊某一行的記錄，就會跳轉到該記錄的詳情頁了）
- `destroy`: 刪除action. (往往用戶是在列表頁中，點擊某一行中的“刪除”按鈕，就會觸發該action）

所以，上面7個action, 4個有頁面（index, show, edit, new) , 3個無頁面(直接操作數據庫，操作完之後跳轉到某個頁面)（例如，顯示列表頁）

下面我們來依次說明。

### 創建對應的controller和routes

假設，我們在路由(`config/routes.rb`中，定義了：　

```ruby
Rails.application.routes.draw do
  resources :books
end
```

並且，我們定好對應的controller: `app/controllers/books_controller.rb`

```ruby
# 現在這裏是一個空的controller, 隨着下面的學習，我們會陸續增加7種最基礎的action
class BooksController < ApplicationController
end
```

### index (列表)

我們在books controller中，增加：

```ruby
def index
  @books = Book.all
end
```

2.在view( `app/views/books/index.html.erb`) 中顯示就可以了：

```
<% @books.each do |book| %>
   <%= book.inspect %>
<% end %>
```

3.在瀏覽器中，輸入`/books` 就可以看到頁面了。如下圖所示。


### new 與 create

1.回顧下路由：　

```
GET /books/new
POST /books
```

2.在視圖中，創建： `app/views/books/new.html.erb`

```
請輸入：
<form action='/books' method='POST'>
  <input type='text' name='the_name'/>
  <input type='submit' value='確定'/>
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

4.這時候，用戶直接打開　`/books/new`，　就可以看到　'new'這個頁面。

5.輸入數據之後，點擊“確定”，　就會觸發 `create` action
,就可以看到數據庫中多了一條這個記錄。 並且，會跳轉到　`/books`這個頁面。

### edit 與 update

1.回顧一下，`resources :books`會提供7種路由，跟edit相關的路由是：

```
GET /books/:id/edit
PUT /books/:id
PATCH /books/:id
```

`PUT`與`PATCH`都對應着`update`action. 所以，我們忽略PATCH這個路由。

2.在列表頁中， 爲每個記錄，都增加一個鏈接：
修改 `app/views/books/index.html.erb`

```erb
<% @books.each do |book| %>
  <%= book.inspect%> ,
  <%= link_to '編輯', edit_book_path( :id => book.id )%>
  <br/>
<% end %>
```

3.在“編輯頁”中，增加一個表單。
修改 `app/views/books/edit.html.erb`

```html
請輸入：
<form action='/books' method='POST'>
  <input type='text' name='the_name'/>
  <input type='submit' value='確定'/>
</form>
```

4.增加`edit`action

```
def edit
  @book = Book.find params[:id]
end
```

5.在view中增加表單的默認值, 把原來的`input name='the_name'`,修改成：　
```
<input type='text' name='the_name' value=<%= @book.name  %>/>
```

5.繼續修改view, 增加下面的`<hidden>`標籤:

```
<input type='hidden' name='_method' value='put' />
```
`_method=put`告訴rails這個form 是以put形式發起的請求, Rails纔會把這個form用對應的action來處理（update）

6.修改`form`的`action`：
```
<form action="/books/<%= @teacher.id %>/edit" method='POST'>
```

完整的view

```
請輸入：
<form action="/books/<%= @teacher.id %>" method='POST'>
  <input type='hidden' name='_method' value='put' />
  <input type='text' name='the_name' value='<%= @teacher.name %>'/>
  <input type='submit' value='確定'/>
</form>
```

生成的 html例子：

```
請輸入：
<form action="/books/14" method='POST'>
  <input type='hidden' name='_method' value='put' />
  <input type='text' name='the_name' value='linux的安裝調試'/>
  <input type='submit' value='確定'/>
</form>
```

輸入值，點擊 確認， 就會發起一個請求：

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

### 查看詳情

1.根據路由

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
<h3>詳情頁</h3>
<%= @book.name %>
```

### 刪除


1.根據路由：

```
DELETE /books/:id
```

2.在列表頁中爲每個記錄都增加一個鏈接. 修改 `app/views/books/index.html.erb`文件

```
<% @books.each do |book| %>
  <%= book.inspect%> ,
  <%= link_to "刪除", "/books/#{book.id}", :method => 'delete'%>
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

4.在列表頁中，點擊任意一行記錄對應的刪除，就可以觸發這個`destroy` action了。

數據庫就會刪除對應的記錄，然後頁面會顯示 “列表頁”


## redirect_to 的用法

1.可以跳轉到有效的URL, 例如：

```
redirect_to books_path
redirect_to '/books'
```

2.也可以使用`:back`(最新Rails版本不支持) .

```
redirect_to :back
```

## 軍規

1.7個默認的路由(`index`, `show`, `new`, `edit`, `update`, `destroy`, `create`)，不能被覆蓋。 例如：

```
resouces :books do
  collection do
    get :new  # 這樣不行，不要重複定義路由。
  end
end
```

2.`redirect_to` 或者`render`只能有一個。並且這兩者都只能出現在action的最後一行.
它們相當於方法的`return`，執行完之後不會往下面繼續執行。

```
def create
  Teacher.create :name => params[:the_name]

  # 下面的render 與redirect_to 不能同時存在，否則會報錯
  render :text => 'ok'
  redirect_to books_path
end
```

## 作業

1.新建rails項目, market

2.新建兩個頁面:

2.1 水果列表頁,`/fruits/list` 內容顯示　三種水果列表就可以了．

2.2 水果的新建頁, `/fruits/new` 顯示啥都行

3.列表頁中，下方有個鏈接，可以跳轉到新建頁．

4.新建頁中，下方有個鏈接，可以跳轉到列表頁．

要使用`named_routes`  (`xx_path`) 這樣的形式．　

- (錯誤例子)　`<a href='/fruits/list'>xx</a>`
- (正確例子)　`<a href='<%= list_fruits_path %>'>xx</a>`
- (正確例子)　`<%= link_to 'xx', list_fruits_path %>`

5.要有`root_path` (訪問 `/`  的時候，　要顯示頁面，"歡迎來到某某水果超市!" )

6.有個接口:  訪問 `/interface/fruits/all` 的時候, 要給到json結果:

(提示: 使用namespace路由)

```
{
  "result": ['香蕉', '蘋果', '橘子']
}

```

(渲染json 的時候, 使用 render :json => ... )

7.實現對fruits 的列表頁，新增，編輯，刪除功能。

8.列表頁要有查詢，例如輸入 "葡"，就會顯示名字中帶有"葡"的水果
