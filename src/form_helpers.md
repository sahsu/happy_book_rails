# form helpers 表單輔助方法

## 軍規

一定要熟悉好標準的HTML表單標籤. 否則你一定會問出小白問題.

在rails的頭一年, 我們一定要玩命看官方的文檔:

form helper: http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html

form tag helper: http://api.rubyonrails.org/classes/ActionView/Helpers/FormTagHelper.html

## 本節文檔.

本節, 文檔: http://guides.rubyonrails.org/form_helpers.html

可以看API:  http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html


## form_for 的完整形式

```
<%= form_for @article do %>
```

等同於：

兩個形式：

1.(@article 是 Article.new的時候）
```
<%= form_for :article , :url => article_path, :method => 'post'  do %>
```

2.(@article 是 Article.find(2)的時候）
```
<%= form_for :article , :url => update_article_path(:id => 2), :method => 'put'  do %>
```

注意：

1. 忘掉   `form_for :xx` 的形式， 使用 `form_for @xx` .
2. 只要當前操作與 數據庫有關係，那麼就用  `form_for` ，會讓你特別省力。  除非有必要，才
使用  `form_tag`
例如：

`form_for`  對應：  創建， 更新操作。
`form_tag`  對應：  某個列表頁的搜索。


## `form_for` 與 `form_tag` 的區別和聯繫

如果我們在controller中定義了:

```
@book = Book.new
```

那麼,在view中， 下面兩個是相同的：

```
<%= form_for @book do |f|%>
  <%= f.text_field :title %>
<% end %>

<%= form_tag '/books' do %>
  <%= text_field_tag 'book[title]', '' %>
<% end %>
```



### form 中的authentity_token （也叫csrf token)

每一個 `<form>` 中,都有一個`authentity_token`. 防止注入攻擊(XSS).

比如說,我在購物時,需要提交表單, 付費 . 這個表單當中,很可能就是:

```
<form ... >
  <input name='price' value='1000'/>
</form>
```

這個form 是非常好僞造的. 所以,需要用authentity_token 來識別.

```
<form ... >
  <input type='hidden' name='authentity_token' value='a1b2c3d4.....' />
  <input name='price' value='1000'/>
</form>
```

`authentity_token` 是由服務器端(rails)生成的.  它針對不同的browser/session 生成不同的token .
於是我們就可以在服務器端做驗證了.

```
class PostsController ...
  protec_from_forgery  # 這行代碼的作用: 對每個form 做驗證,看裏面的token 是否跟服務器端匹配.
end
```

```
<% if @post.id.present? %>
  <form action='/posts/3/edit' method = 'put' >
<% else %>
  <form action='/posts' method = 'post' >
<% end %>
    <input type='hidden' name='token' value='<%= generate_token %>' />
```

所以使用`form tag` ， 就再也不用人肉寫上面那行的代碼了。
```
    <input type='hidden' name='token' value='<%= generate_token %>' />
```

如果使用了form tag, 就可以自動生成 csrf token了.:

```
<%= form_for @post do |f| %>
```

## 接下來演示的前提

我們已經定義好了 `class Article`, 形如:

```
class Article < ActiveRecord::Base
end
```

表 `articles` 有個列: title

假設 @article 是 Article 的一個實例.

## FormHelper FormTagHelper.

兩個例子，來對比說明。

區別:

1.`form helper`:

```
  <%= f.text_field :title %>
```

1.1. 需要與 form object ( `<%= form_for @book do |f| %>  .. .<% end %>` )配合使用。
1.2  對於生成的`<input type='text' name="student[age]"/>`中,
  它的`name` 是自動生成的。 例如：  `name="student[age]"`
    `student` 必須是某個model的實例
    並且， `age` 必須是form object的方法（也就是 數據庫的列。)

  優點： 可以簡化我們對錶單項的操作。（例如： 下拉單 或 文本框的 默認值）

2.`form tag helper`:
```
  <%= text_field_tag 'my_title' %>
```

  2.1 可以獨立使用。 跟表單對象無關。
  2.2 名字可以隨意取。 name='abc'
  優點： 特別靈活。  可以脫離表單對象使用。  而且 便於理解。

相同點：   作用是一樣的。

例如：

```
  <%= f.submit "OK"%>
  <%= submit_tag "OK" %>
```

都會生成：
```
<input type="submit" name="commit" value="OK">
```

例子2：

```
  <%= f.text_field :title %>
  <%= text_field_tag 'article[title]' %>
```

都會生成：

```
  <input type="text" name="article[title]" id="article_title">
```

所以說， `form helper` 與 `form tag helper` 都是一樣的。 一個東西。寫法不同。

甚至， 我們在API文檔上，都可以看到 xx_field 的文檔中，會說： 請參考  xx_field_tag . 例如：

time_field 中：
```
Options: Accepts same options as time_field_tag
```

提示： 我們做rails的前半年，一定要多翻： 上面兩個文檔。

## 注意：

api 的文檔， 跟真正的用法，有一定區別。
http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-label

api 中寫着：

```
text_field(object, method, options={})
```

實際問題來了：
(前提： `@article` 是在 controller中定義好的）
下面，兩個`input`， 是一樣的。

```
<%= form_for @article do |f| %>
  title: <%= f.text_field :title %>
  <%= text_field :article, :title %>
end
```

都會生成：

```
<input type="text" name="article[title]" id="article_title">
```

但是，實戰當中， 我們都是用 `f.text_field('method')` 這樣的 簡寫形式。
不會使用 `text_field('object', 'method')` 這樣的形式

API 那樣寫，是因爲在API文檔中沒有上下文。 所以它那麼表示的。（深層會有很多邏輯，很多
動態生成的代碼，我們不考慮）
## text_field 的兩種不同寫法

API寫法:

```
  <%= text_field :article, :title %>
```

form object中的寫法:

```
  <%= f.text_field :title %>
```

兩個都會生成一樣的內容, 我們實戰中 只用 `f.text_field` 這樣的形式.

## text_field 與 text_field_tag

用法:

```
<%= form_for @article do |f| %>
  <%= f.text_field :title %>
  <%= text_field :article, :title %>
  <%= text_field_tag 'article[title]' %>
<% end %>
```
會生成:

```
<input type='text' name='article[title]' />
```

`f.text_field` 會自帶默認值, 如果希望 `text_field_tag` 也有默認值的話,就要:

```
<%= text_field_tag 'article[title]', '三體' %>
```

## select , select_tag 與 options helper

```
<%= select_tag 'sex', options_for_select(['男', '女']) %>
```

會生成:
```
<select id="sex" name="sex">
	<option value="male">男</option>
	<option value="female">女</option>
</select>
```

也就是說, 上面的 `select_tag` 會生成:


```
<select id="sex" name="sex">
</select>
```

`options_for_select(['男', '女'])` 會生成:

```
<option value="male">男</option>
<option value="female">女</option>
```

### options_from_collection_for_select

如果這些options 來自於 數據庫, 假設已經存在一個表`books`, 有兩個列: `id`, `title`,

這個表的值是:

id | title
-- | --
1 | 三體1
2 | 三體2
3 | 三體3

於是,
```
<%= options_from_collection_for_select Book.all, :id, :title %>
```
會生成:

```
<option value="1">三體1</option>
<option value="2">三體2</option>
<option value="3">三體3</option>
```

### collection_select

我們也可以直接使用 `collection_select`, 替代`select` 與 `options_from_collection_for_select`.

```
# 假設 f 是 book的表單對象.
<%= f.collection_select :title, Book.all, :id, :title %>
```

會生成:

```
<select name="book[title]">
	<option value="1">三體1</option>
	<option value="2">三體2</option>
	<option value="3">三體3</option>
</select>
```

但是這種寫法往往不夠靈活, 所以我們用的不多.

## textarea, password 與 hidden_field

```
<%= text_area_tag(:message, "Hi, nice site", size: "24x6") %>
<%= password_field_tag(:password) %>
<%= hidden_field_tag(:parent_id, "5") %>
```
會依次生成:

```
<textarea id="message" name="message" cols="24" rows="6">Hi, nice site</textarea>
<input id="password" name="password" type="password" />
<input id="parent_id" name="parent_id" type="hidden" value="5" />
```

## checkbox 多選 與 radio button 單選

多選的例子:

```
<%= check_box_tag(:banana) %>
<%= label_tag(:banana, "我喜歡香蕉") %>
<%= check_box_tag(:orange) %>
<%= label_tag(:orange, "我喜歡橘子") %>
```

會依次生成:

```
<input id="banana" name="banana" type="checkbox" value="1" />
<label for="banana">我喜歡香蕉</label>
<input id="orange" name="orange" type="checkbox" value="1" />
<label for="orange">我喜歡橘子</label>
```

單選的例子:

```
<%= radio_button_tag(:sex, "male") %>
<%= label_tag(:sex_male, "男") %>
<%= radio_button_tag(:sex, "female") %>
<%= label_tag(:sex_female, "女") %>

```

會依次生成:

```
<input id="sex_male" name="sex" type="radio" value="male" />
<label for="sex_male">男</label>
<input id="sex_female" name="sex" type="radio" value="female" />
<label for="sex_female">女</label>
```

## 其他 helper

可以查看官方文檔. 以及我們的demo

## 作業

1. 使用 form_tag 和其他自定義標籤, 寫出一個表單, 包含:


提示:  form_tag 跟model 無關

2. 使用 form_for 和其他自定義標籤, 寫出一個表單.

提示: 需要創建一個model, 然後使用form_for , f.text_field 這樣的形式來生成.

- select
- options
- input type = text
- input type = hidden
- input type = password
- input type = file
- textarea
- checkbox
- radio
