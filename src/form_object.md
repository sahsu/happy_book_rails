#  form 與 表單對象。

前方高能：

1. 本節是rails三大難之一。比較燒腦。大家要務必作作業。不動手，學不會。
2. 關於提到的各種helper, 多看官方文檔：

- 英文： http://guides.rubyonrails.org/form_helpers.html
- 中文： http://guides.ruby-china.org/form_helpers.html
- 也可以看API中的文檔（寫的也特別細） http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for

## 軍規

老老實實的使用 `<%= form_for @book do |f| %>` 這樣的標準形式( `@變量`, 不是`:變量`, 不要有奇葩的action, 不要讓model 對應的class
對不上號)

初學者不要使用 `simple_form_for`, `nested_form` 這樣的插件. 對於老手也不建議在商業 項目中使用.

## 目錄：

1. 十年前的  form 表單，在後臺是如何處理的。
2. 演進過程。
3. 表單對象的優缺點，好處

## 複習： 瀏覽器，傳數據給服務器，能傳幾種數據類型？

三種.

1.字符串.例如:  `/some_url?a=123`

`a = '123'`

2.數組. 例如: `/some_url?a[]=1&a[]=2&a[]=3`

可以知道, `a = ['1', '2', '3']`

對於Rails的Controller, 可以處理爲:

```
Started GET "/books?a[]=1&a[]=2&a[]=3" for 127.0.0.1 at 2016-10-06 15:48:10 +0800
Processing by BooksController#index as HTML
  Parameters: {"a"=>["1", "2", "3"]}
```
可以看到 Rails中, 也是一樣處理的.

3.Hash. 例如:

`/some_url?student[name]=jim&student[age]=20`

`student = { name: "jim", age: "20" }`

對於Rails的日誌:

```
Started GET "/books?student[name]=jim&student[age]=20" for 127.0.0.1 at 2016-10-06 15:48:52 +0800
Processing by BooksController#index as HTML
  Parameters: {"student"=>{"name"=>"jim", "age"=>"20"}}
```

以上形式, 對於所有類型的http request都使用.

如果我要發起一個POST 請求
```
POST    /ooxx.html      (form)
```
就要參數放到form 表單中。

```
<form action='ooxx.html' method=POST>
  <input name='a' value='1'/>
  <input name='b' value='1'/>
  ....
</form>
```

如果我有一個對象，叫  article(中文名： 帖子）,  它有兩個屬性：  `title`, `content`.

那麼，我們在Rails中，約定， 對應的html表單，就應該寫成：：

```
<form action='/articles'  method='post' >
  <input type='text' name='article[title]' value= '我是標題' />
  <input type='text' name='article[content]' value= '我是正文' />
</form>
```

這樣, 我們傳到服務器端的參數, 就是:

```
{
    article: {
        title: "我是標題",
        content: "我是正文"
    }
}
```

於是，就可以很方便的讓我們後端的代碼來處理。後端代碼可以非常的簡單的
把上面的hash轉換成對應的對象。


rails是可以自動分辨, 某個參數的值，是：  字符串，數組， 還是hash
```
<form action='..' method='..'>
   <input type='text' name='article[title]' value='三體'/>        params[:article][:title]  => '三體'

   <input type='text' name='colors[]' value='green'/>
   <input type='text' name='colors[]' value='red'/>
   <input type='text' name='colors[]' value='yellow'/>
                                                     params[:colors]   => ['green', 'red', 'yellow']
   <input type='text' name='article[readers][]' value='jim'/>
   <input type='text' name='article[readers][]' value='lilei'/>
                                                     params[:article][:readers] => ["jim", "lilei"]

</form>
```

上面的form表單, 傳遞的參數, 實際上是一個大hash, 形如:

```
  {
     article: {
        title: '三體',
        colors: ['green', 'red', 'yellow'],
        readers : [
          "jim",
          "lilei"
        ],
     }
  }
```

(也可以在hash裏面，放數組，再放hash, 再數組。 總之，可以各種混用。
但是： 實際工作中，不要這樣用。會被同事罵。 也會把自己繞蒙）

# 於是,我們從十年前,比較原始的web開發時代開始說起.

對於下面的這個表單：
```
<form action='/articles'  method='post' >
  <input type='text' name='article[title]' value= '我是標題' />
  <input type='text' name='article[content]' value= '我是正文' />
</form>
```

它傳給後端的值也就是:

```
{
    article: {
        title: "我是標題",
        content: "我是正文"
    }
}
```

10 年前的java代碼，是如何處理的呢？

```java
// request 是 一個內置的對象
// step1. 獲取瀏覽器傳過來的所有參數
String title = request.getParameter('article["title"]');
String content = request.getParameter('article["content"]');

// step2. 初始化一個 model.  並且 設置它的各種值
Article article = new Article();
article.setTitle(title);
article.setContent(content);

// step3. 保存
article.save();
```

## 問題就出現了: 一個form 表單有很多個參數怎麼辦?

對象的屬性越多，傳遞過來的參數就越多，上面的賦值語句就越多。

我曾經見過 有20行語句， 都是： `request.getParameter('...')`

所以，解決方法：  使用表單對象 `form object`。來對這麼多個參數進行封裝.

最開始的表單對象： 需要手動創建一個object:


##### 這個model  用來操作數據庫的。

(java struts框架的裏面的 臭名昭著的東東, 2005年)
```
class Article {
  private String title;
  private String content;

  //getter, setter...

}

```

所以這就尷尬了：  表單對象，跟數據庫的ORM對象，一模一樣。導致了同樣的代碼出現在了 兩個文件當中。

## 知識點: 使用ORM後,做數據庫操作時, 有三個層次要參與:

1.  form object
2.  ORM model
3.  數據庫table

以上面的  `article` 爲例子。  有兩個屬性：  `title`, `content`.

純HTML   |  form object  |  ORM model  |  DB TABLE
------- | ---- | ---- | ---

###  1. 純html

rails是可以自動分辨, 某個參數的值，是：  字符串，數組， 還是hash
```
<form action='..' method='..'>
   <input type='text' name='article[title]'/>        params[:article][:title]
   <input type='content' name='article[content]'/>   params[:article][:content]
</form>
```

### 2. form object:

在rails中是隱形的。你看不到它的聲明。因爲：它是在運行時，被rails中的某些方法動態創建的。

p.s. 動態創建方法的例子（javascript)

```
my_string = 'function hi(){  console.info("hi") }'
"function hi(){  console.info("hi") }"
eval(my_string)
undefined
hi()  # =
```

(在其他語言和框架中，這個對象，都是 顯式 聲明的（你的手寫出來）, 在struts中就要這樣）

rails中， 動態創建的form object, 理論上是這樣：
(form 中包含什麼參數, 或者說數據庫中有多少列, 就有多少attribute)

```
class Article
  attr_accessor :title
  attr_accessor :content
end
```

# 通過 form_for 來使用表單對象.

所以，rails中， form 就要這樣寫：

```
<% form_for @aritcle do |f| %>
  <%= f.text_field :title %>
  <%= f.text_field :content %>
<% end %>

```
上面的重點，在於：  `do ... end`.  它說明了rails 是如何調用 上面的隱形的表單對象的。


這一句:

```
  <%= f.text_field :title %>
```

就是調用了 上面的 `Article`的 `attr_accessor :title`.

如果說`article` 是個表單對象的話,

- 編輯 article的時候， 要顯示原來的值， 就是： `article.get_title`
- 保存 article的時候， 要保存傳過來的值，就是：  `article.title=`

在上面的 `do |f| ... end`中, 這個`f` 就是表單對象.

`f.text_field :title` 不但會生成一個`<input type='text' />`標籤,而且還會通過調用表單對象的 `.get_title` 方法,
來爲這個`<input/>`標籤設置初始值.

### 3. ORM model.

app/models 目錄下的article.rb：
```
class Article < ActiveRecord::Base
  # rails會自動生成：  title, content 的 accessor
end
```

(也可以認爲， 在Rails中， ORM model 跟 form object model 是一個文件。

### 4. DB table:

|articles表:|
|--|
|第一個列：title|
|第二個列：content|


## 表單對象與持久層,在Rails中是一個.

1. 表單對象（處理表單代碼時, 把參數保存到 對象中）
2. 持久層（把對象中的數據保存到DB）

在rails中這兩個是一樣的東東。

## 使用Hash爲Model賦值.

Rails形式： 它的宗旨就是 方便程序員， 對人友好：

回到剛纔的java代碼： 可以看到，給對象的賦值是一個一個來的：

// 這個就是form 提交過來的 參數：
{
    article: {
        title: "我是標題",
        content: "我是正文"
    }
}

```java
String title = request.getParameter('article["title"]');
String content = request.getParameter('article["content"]');
Article article = new Article();
article.setTitle(title);
article.setContent(content);
article.save();
```

### 演變1： (一個屬性一個屬性的賦值)

該寫法常見於： 從java轉行過來的rails程序員。

```ruby
article = Article.new({
    :title => params['article']['title'],
    :content => params['article']['content']
})
article.save  # 在這裏執行  insert into articles values (...)
```

### 演變2：(直接給構造函數一個hash , 再save)

```
article = Article.new params['article']
article.save
```

### 演變3：(把 `new ... save` 的步驟, 省略成: `create`)

```
Article.create params['article']
```


## 引申： java 與 ruby的不同（  語言能力上的，特別是元編程的不同）

# 對於持久層的model 聲明:

我們假設`articles` 表， 有兩個列：  `title`, `content`:

```
class Article < ActiveRecord::Base
end
```

它就會自動出現下面的方法：

```
article = Article.create ...
article.title   # => 獲得title
article.content # => 獲得content
```

java代碼則是任何方法都要手寫：

```
public Article extends ...{
   private String title;
   public String getTitle() { ...}  // 需要手動定義
   public void setTitle() { ... }
}
```

# TODO 送給好奇寶寶
# 元編程動態聲明方法的例子：

可以看出ruby元編程極其簡單.

```
class Post
end

post = Post.new
post.instance_eval("
  def say_hi
    puts 'hihihi'
  end
")
post.say_hi
# => 'hihihi'

```

## form_for

下面是一個最常見的Rails表單:

```
<%= form_for @user do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

`form_for` 是個方法。
要三個參數：

```
form_for(record, options = {}, &block)
```


對於下面的代碼:
```
<%= form_for @user do |f| %>
```

`record`:是 `@user`,
`options`, 就是 `{}`, 所以被省略掉了。
最後一個參數，是 `block`.

1. 爲什麼，第二個參數可以被省略掉？

因爲， 在ruby當中， 規定： 如果一個函數的參數中，有block, 那麼這個block,
必須是最後一個參數。

所以，ruby ，要解析一個函數的時候，一開始，就能知道， do ... end 之間，這是一個
block, 所以，它就是最後的參數。

而： form_for @user, 表示， form_for的第一個參數，就是 @user.

所以，根據form_for的定義：

1. 第一個參數，有了。
2. 第二個參數，在定義中，就是： 可選的。 ( options = {} )
3. 第三個參數：( &block ) 也有了。

所以這個函數就完整了，可以正常運行了。

下面的 `f.label`, `f.text_field`, `f.submit`, 中的 `f`:

```
<%= form_for @user do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

這個`f`, 就是block中的參數，也可以直接把它看成： `form object`. (表單對象)

## 預習 rails中的簡寫。

1. 爲什麼有時候是 :var,  有時候是 @var
由 api 決定的。  以及  rails  的省略手法決定的。

例如：
我們要訪問某個 controller的某個action:

```
打開：  http://localhost:3000/users?name=dashi
```

如果我要獲取到這個url 的參數：

在rails中，有三種方式：

```
params[:name]
params['name']
params["name"]
```

所以，form_for 的第一個參數，也可以寫成下面的三種形式。
```
<%=  form_for @name  %>   寫成這樣。  下面兩種，不推薦。除非你特別有把握。
<%=  form_for :name  %>
<%=  form_for 'name' %>
```

"name" |  'name' | :name
---
string |  string |  symbol

symbol:  不變的字符串。  ruby 的概念。

```
<%= form_for @post do |f| %>
  ...
<% end %>
```
就等同於：

```
<%= form_for @post,
    as: :post,
    url: post_path(@post),
    method: :patch,
    html: { class: "edit_post", id: "edit_post_45" }
    do |f| %>

    # 其他代碼

<% end %>
```

問題來了：  上面的代碼中， form_for 有多少個參數呢？

如果你看了API， 就知道了，它有3個參數。

但是，爲什麼， as, url, method, 都不是參數呢？ 因爲，他們是一個hash,
在ruby中， hash最外層的大括號很多時候可以省略。

哪些時候可以省略呢？

該hash作爲參數時，如果它不是最後一個非block參數。它就可以省略大括號。

```
form_for  @user,   { url: '', method: '' } do |f| ...
end
```

## 那麼問題來了：

爲什麼要用rails的自定義html 標籤呢？ , 例如:

```
form_for,
form_tag,
text_field,
select_tag
```

而不是:
```
<form>  , <input> ...
```

答： 爲了更加簡單

例如, 比較下面兩種寫法:

1.form的rails寫法:
```
<%= form_for @post, html: { class: "edit_post", id: "edit_post_45" } do |f| %>
  <%= f.text :title, '我是標題' %>
<% end %>
```
2.form的HTML寫法:
```
<form action='/posts'  method='post' class='edit_post' id='edit_post_45' >
  <input type='text' name='post[title]' value= '我是標題' />
</form>
```

我們發現兩者差別不大.

但是, 在做 編輯某個記錄的時候, 我需要:
1. 生成一個form object
2. 生成的html 標籤,帶有默認值.

(下面就是php風格：)
```
<form action=.. >
  <input type='text' name='post[title]' value=<%= @post.title %> />
  <input type='text' name='post[content]' value=<%= @post.content %> />
</form>
```

(下面就是ruby風格)
```
<%= form_for @post do |f| %>
  <%= f.text_field :title %>
<% end %>
```

所以，php的代碼，看起來就是場 噩夢。

例如：某個下拉框，有100個選項. 就要搞100次循環。然後，還要判斷默認值。
那個時候，就會覺得代碼特別的臃腫。

TODO: 把臃腫的代碼，COPY到這裏。或者做個截圖.

## form_for 很智能的地方。

過程:  rails發現了 `form_for` 的唯一參數: @post, 它就會開始按照"約定" 來猜測
各種參數: `form_object`, `method`, `action` ...

所以,對於 新建操作的form:

```
<form action='/articles' method = 'post' >
</form>
```

和對於 編輯操作的form:
```
<form action='/articles/3/edit' method = 'post' >
  <input type='hidden' name='_method' value='put'/>
</form>
```

變成ruby代碼的話就是:

```
<% if @article.id.present? %>
  <form action='/articles/3/edit' method = 'put' >
<% else %>
  <form action='/articles' method = 'post' >
<% end %>
```

於是,我們就可以用:

```
<%= form_for @post %>
```

這段代碼, 來表示上面提到的兩種場合(@post 是已經存在的記錄,還是沒有存在的記錄).


## 使用form object 生成輸入項的默認值.

text_field,  select
如何保證在編輯某個屬性的時候, 它能選中了某個默認值?
```
<select>
  <option name=...> value</option>
  <option name=... <%=if @post.title == 'xx'  %> selected <% end %>> value</option>
  <option name=... selected> value</option>
  <option name=...> value</option>
</select>
```

在rails中,可以使用 `select`的輔助方法.

```
<%= select_tag options_for_select([1,2,3], default_value ) %>
```


作業：

1. 新建一個項目, 就是對學生的增刪改查.
2. 實現一個form ,  form中，包含：
  2.1 姓名 string
  2.2 性別 單選 radio  , 選項: male, female
  2.3 愛好 多選 checkbox, 選項: lol, dota, cf, music
  2.4 自我評價 textarea
  2.5 星座 ( select)
  ( 把上面幾個學好就可以。 不用學的：   日期輸入框,數字， url, phone .. 其他的都不用學。)

要使用form_for

TODO 下面作業是下節課的

3. 把new.html.erb和 edit.html.erb中的 form_for 提取成爲一個partial.

3. 實現一個 select （ 選擇框，下拉單， drop down (US 叫法））
裏面的選項， 來自於： 數據庫。  舉個例子：

3.1
數據庫中，有兩個表，books(書） , 一個是： publisher （出版社）   books :  publisher = n : 1

books表， 有下面的列：

id    title    publisher_id
-- |  -- |  --
1  |   java入門  |
2  |   ruby 入門  |
3  |   javascript 入門 |

publisher 表只有兩個列：

id,   name
--- | ---
10  | 人民教育出版社
20  | 商務印書館
30  | 電子工業出版社

3.2
寫出下面的 html: (使用  select_tag  與 options_from_collection_for_select )

```
選擇出版社：
<select name='books[publisher_id]' >
  <option value='10'>人民教育出版社</option>
  <option value='20'>商務印書館</option>
  <option value='30'>電子工業出版社</option>
</select>
```

3.3
在新建或者 編輯 books的頁面中，  可以對publisher 進行選擇。

並且，可以在後臺(create, update action中）保存。



再進一步的細化提示：
   1. 創建兩個表。 (rails generate migration )
   2. 有相關的 model ( app/models/book.rb,  publisher.rb )
   3. 查看(實現形式1）： select_tag, options_from_collection_for_select
   4. 查看(實現形式2）： select_tag , options_for_select


