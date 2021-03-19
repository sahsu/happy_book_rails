# 新手入門不用學的東西

以下內容在新手入門的時候不用學習，因爲根據經驗來看，這些內容會對新手造成困擾。

## `csrf_token` 在學習前可以省略掉。

在`application_controller.rb`註釋掉 `protect_from_forgery`

```
class ApplicationController < ActionController::Base
#   protect_from_forgery with: :exception
end
```

##  asset pipe line

會在部署的時候給你帶來大麻煩

可以在`config/application.rb`中暫時把它註釋掉，這個可以在整體學完之後再學:

```
config.assets.enabled = false
```

## scaffold

僅用於新手入門和了解。但是做項目時，不要依賴它。

僅僅把它用在學習的過程中。例如，我希望知道，一個完整的 CRUD， 是需要哪些文件來配合的。那麼一個最快速的辦法就是使用

```
$ rails g scaffold users  name:string ..
```

這個命令來生成,就能看到：

會生成controller, model, view, helper ... 所有依賴的文件。也會生成 migration 等等。

根據我的經驗，依賴這個命令（以及類似命令 rails g model, rails g controller）的新人，入門的速度會最長達3個月。
但是，不依賴這個命令，所有的CRUD都自己手寫的人，可以在 2~3周入門。

## form validation 表單驗證

在服務器端，驗證一個 form object , 是否符合要求。例如，name是否是空, email 是否是xx@yy.com 這個格式。

除非特別重要，否則前端驗證就足夠了

解決辦法：直接用jquery validate, 在client端進行驗證。

所以，每個`_form.html.erb`中的內容，都要刪掉：

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

## 關聯關係: 多對多.

忘掉 `has_many_and_belongs_to` .

不用這個，我們要用`has_many` 來代替。

因爲多對多的關係，不是由兩個對象（表）來決定的,而是由3個表來決定的。例如：

老師-學生 = N:N

1. 有個老師表
2. 有個學生表
3. 有個中間表（課程，成績）

所以，我們要使用 `has_many` 就可以了，不要用 `has_many_and_belongs_to`

## 儘量不用單表繼承

假設有3個對象:

1. 男人
2. 女人
3. 生物

也可以這樣設計：

只有一個表, 就叫creatures

```
creatures
-------
id: integer
name: string
type: string
```

表的內容就是:

```
id  name      type
-------------------------
1   '張三丰'  Man
2   '武則天'  Women
3   '青蛙'    Creature
```

對應的class是：

```
class Man < Creature
end

class Woman < Creature
end

class Creature < ActiveRecord::Base
end
```

這就是單表繼承。我們可以瞭解, 但是不要在實際項目中使用。因爲Rails中，充滿了太多的"按照慣例編程"，這些慣例，很容易會被單表繼承所破壞。

例如： `form_for @man` ,rails就會認爲"傳遞給 form_for函數 的 參數@man 的class" 是`Man`, 而不是`Creature`, 那麼，該form是要提交到哪個url？

```
- /creatures/2/update
- /men/2/update
```

總之，這裏的坑很深，就老老實實的按照慣例編程，不要爲了抽象而抽象。

另外，一旦rails用多了，我們就會發現，儘量不要改變`form_for`, `form_tag` 這樣的功能。

## i18n 國際化

忘掉它。咱們國內項目永遠用不到。而且國際化將來會爲你帶來巨大的麻煩。例如影響頁面CSS的佈局等等。

## Plugins

忘掉它。我從來沒寫過。在我使用ruby的第一年，好像官方就把它拋棄了。(deprecated)

可以寫個新的gem

## 不要使用 nested form.

例如：  我在新建 一個文章的時候，就在頁面上，增加針對文章的form.
不要：  在這個form中，又新增文章，又新增 該文章的評論。 (因爲這個評論是屬於這個文章的）

## 不要使用 respond_to 或者 類似的方法。

要麼只返回html, 要麼只返回json

下面的代碼，同時支持兩種格式： json, html, 實際上這是雞肋。
```
def destroy
  @book.destroy
  respond_to do |format|
    format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
    format.json { head :no_content }
  end
end
```

我們在實際操作中，一個路由僅僅對應一種返回格式，這樣更好寫代碼，安全性也更高例如：

```
GET /api/books    # 只支持json
GET /books        # 只支持html
```

## nested routes (嵌套的路由)

- 正常的路由：  `/comments/2`  表示id = 2 的 評論
- 奇怪的路由：  `/posts/50/comments/2`    表示 id = 50的文章的評論中， id = 2 的評論。

問題來了: 如果想找出"遼寧省阜新市海州區第三小學"該怎麼找？

- 奇怪的路由：  `/provinces/4/cities/3/schools/2`
- 我幹嘛不用：  `/schools/2`  呢？

如果一定要帶上前面的參數的話，幹嘛不直接這樣:

- `/schools/2?province_id=4&city_id=3`

後者我可以加上100個參數，不超過64k的長度（或者2K長度，在IE下）就可以。
如果用 nested routes, 我們就沒法開發了

極端例子： `/provinces/4/cities/3/schools/2/grade/5/class/3/student/2`

可惜的是，官方的rails guide中，第一個就是這個例子。

我的建議是：忘掉這個功能。

## routes中，只使用 resources,  不要使用其他的路由

下面這兩種都儘量別用:

```
get 'welcome/index'
match ...
```

routes.rb中，只應該出現： `resources`, `root` 兩種路由。

## params().require().permit

除非你對 `form_object` 很熟悉了, 否則很多新手會蒙。

應該直接使用`params[:users]`

可以在`config/application.rb`中關閉這個功能:

```
config.action_controller.permit_all_parameters = true
```

## 不要使用turbo links

這個技術，是爲了讓客戶端減少對服務器端的請求。但是效果不理想，很容易引起js的錯誤。
那麼我們在需要的場合，直接使用更加純粹的single-page-app. (例如vuejs)

1.刪掉Gemfile 中的gem:

```
gem 'turbolinks'
```

2.在`app/assets/javascripts/application.js` 中刪掉下面的內容：

```
//= require turbolinks
```

3.在`app/views/layouts/application.html.erb` 中刪掉下面的內容：

```
"data-turbolinks-track" => true
```
