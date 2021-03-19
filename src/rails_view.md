# View的基本概念和用法

View在MVC中,一直是最簡單的概念. 大家要分分鐘入門.

視圖在Rails中, 就是 .html.erb 文件. 我們原則上把跟HTML有關的東西,都寫在 視圖中.

每個視圖都要由controller觸發. 所有的視圖文件,都放在: `app/views/` 目錄下. 例如: `app/views/books/new.html.erb` 這是Rails的約定 .

最基本用法

下面是一個最簡單的erb文件:

```
<p>當前時間是:  <%= Time.now %></p>
```
它會直接被轉換成下面的HTML:

```
<p>當前時間: 2016-10-08 21:01:35 +0800</p>
```

# `<% %>` 與 `<%= %>` 的區別

`<% %>` 表示僅運行代碼, 例如: `<% a = 1 %>`
`<%= %>` 表示,不但運行, 而且把結果渲染到html中. 例如: `<%= Time.now %>`

# Rails中的視圖在什麼時候被渲染?

Rails架構： M - V - C（幾乎是所有經典web項目的架構）. 其中:

- Model: 操作數據庫。
- Controller: 把每個 "http request" 分發到對應的 "Action( method)"來處理
- View: 顯示 HTML 頁面。

所以，我們用一個例子來說明, view在哪裏建立,在什麼時候渲染：

1.小王同學在瀏覽器端，輸入了一個網址: http://server.com/fruits/new ，回車。(這會產生一個 "http request" , 請求方式是 GET)

2."http request" 從瀏覽器，發送到服務器端(server.com)之後，
Rails就會 把這個請求交給 router 來處理。

(接下來的事兒，都發生在 服務器端）

3.router根據配置文件： config/routes.rb 中的配置：

```
Rails.application.routes.draw do
  resources :fruits # 根據這個路由配置
end
```

把這個request，分發到： `fruits` controller 中的 `new` action.

4.new action 做一些 處理， 顯示對應的 erb .

```
# 下面是 app/controllers/fruits_controller.rb 的內容:
class FruitsController < ApplicationController
  def new
    @hello = 'hellow, Rails!'
    # 啥也不寫，就直接渲染對應的 erb頁面:
    #  app/views/fruits/new.html.erb
  end
end
```

5. 上面的 `new` action 執行完, 會自動渲染 new.html.erb這個文件( 文件路徑: `app/views/books/new.html.erb` )
(爲什麼PHP 很好入門？ 就是因爲，PHP 上來就讓你寫這個）

```
<% [1,2,3].each do e %>
  <%= e %> <br/>
<% end %>
```

上面的視圖文件會被渲染成:

```
1 <br/> 2<br/> 3<br/>
```
(爲什麼PHP 入了門之後，就發現 到處都是坑？ 就是因爲PHP
中， 只有這個View(如果不使用框架的話).
同理， JSP， ASP 稍微好點，但是也是一樣。）

基本概念講完了,就是這麼簡單.

# 恰當的使用 @變量
大家記得, 任何 實例變量 (@name 這樣的), 都用於定義在controller中,然後在 view中被調用.

# Partial (片段)
有時候，如果某個erb文件， 過於複雜了。 例如： 20行。

或者， 某些代碼可以重用。

我們就用 Partial 來簡化我們的代碼,提取出公共的部分.

## 不帶參數的partial
例如:


```
<!-- 下面這段是版權聲明，多個頁面都需要重用  -->
<footer>
  copyright@2016 xx.co.ltd
</footer>
```

那麼就把它寫成一個 partial (片段）

全名是: `app/views/fruits/_footer.html.erb`(注意，文件名以`_`開頭)

然後，我們就可以在對應的 erb文件中：


```
<%= render :partial => 'footer' %>
```
注意: 上面的調用中, 直接使用了 'footer', 而不是 `_footer.html.erb` .這也是Rails的慣例.

## 帶參數的partial
如果，某個partial ,是需要參數的，（例如： 年份是個變量）


```
<!-- 下面這段是版權聲明，多個頁面都需要重用  -->
<footer>
  copyright@ <%= year %>xx.co.ltd
</footer>
```
那麼，在調用時，就：

```
<%= render :partial => 'footer', :locals => {:year => 2016} %>
```

可以看到, 使用了 locals 來傳遞參數.

## 不要使用嵌套層次過多的 partial

例如 partial A 嵌套 partial B , partial B 嵌套 partial C. 一旦發展下去,
你就會發現自己的代碼亂套了.

partial 失去了它簡化代碼的作用.

# helper 的用法

helper的目的是爲了讓view的代碼看起來更簡化.

它是一個ruby module, 可以定義在app/helpers 目錄下的任何文件中. 例如:

```
# app/helpers/application_helper.rb
module ApplicationHelper
end
```

## 添加一個helper

```
module ApplicationHelper
  def say_hi name
    "hi #{name}"
  end
end
```

那麼我就可以在 任意的view中,使用這個方法:

```
<%= hi "Jim" %>
```

我在任意的頁面中,可以調用定義在任意helper中的方法. 例如:

```
# app/helpers/foo_helper.rb
module FooHelper
  def say_hi
    "hi"
  end
end
```

## 不要過多的使用helper ,

因爲我們調用helper的時候,不會顯式的寫出caller. 例如:

```
# my_module 就是 say_hi 的caller
my_module.say_hi

# 下面,沒有一個顯式的caller, 那麼,我們就不知道這個find_me方法定義在哪裏.
find_me
```

另外, ruby本身就是動態語言.(它的很多方法,都不知道聲明在哪裏)


```
<%= show_header %>

<%= book.show_header %>
```
可以看出,下面的 book 是一個非常明顯的caller. 我們在實戰中,最好把方法,都定義在 model, controller中.
(model中的方法定義,更多一些)


# 不用學的
其他的沒講到的，都不用學。實戰中根本用不到. 或者只是增加了複雜性 . 例如：

```
render 'filename'
render xxx,  :collection ...
render xxx,  :as ...
render xxx,  :object ...
```

# 課程的作業
1. 創建一個rails應用.
2. 創建一個controller:  my_views_controller
3. 創建action: simplest_view, 訪問後, 可以顯示當前時間.
"當前時間是:  2016 Nov 16 .... " (提示: 使用Time.now方法即可)
4. 創建action: hello_from_action. 在該action中定義一個變量 @name,
然後,訪問頁面時, 可以顯示 "xx, 你好!"
5. 創建action: show_footer. 在對應的視圖中,調用一個名爲 "_footer.html.erb"的partial.
該partial中的內容如:  "copyright@2016, by <你的名字>"  . "你的名字"是通過變量
傳入到這個partial中的.
6. 創建action: show_a_list, 在對應的view中, 創建一個數組, 然後使用<ul>, <li>標籤顯示出來,
例如:

```
<ul>
  <li>Banana</li>
  <li>Apple</li>
  <li>Orange</li>
</ul>
```


- 顯示當前時間
- 在controller中定義一個變量, 然後把它在view中顯示出來.
- 定義一個partial, 然後在view中調用它.

# 本節示例代碼

本節中的例子，對應的源代碼，可以來這裏下載： https://github.com/sg552/rails_lesson_3_view

本節對應的ppt, 可以來這裏下載： http://siwei.me/about-me/speaks


# todo : raw
