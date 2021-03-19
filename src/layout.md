# Layout(佈局)

## 概念

所有的action 在渲染頁面的時候，都會把動態內容的外層，包裹一個HTML頁面。
這個HTML頁面，就是一個layout.

都放在 `app/views/layouts/` 目錄下.

## 例子

從一個例子看起：

假設我們有兩個頁面：

page1.html.erb

```
<html>
  <head>
    <title>圖書管理系統</title>
    <script src='jquery.js'></script>
  </head>
  <body>
    <div> 我是頁面1 </div>
    <div class='footer'>
      copyright(at)2015 xx.co.ltd
    </div>
  </body>
</html>
```

page2:

```
<html>
  <head>
    <title>圖書管理系統</title>
    <script src='jquery.js'></script>
  </head>
  <body>
    <div> 我是頁面2 </div>
    <div class='footer'>
      copyright(at)2015 xx.co.ltd
    </div>
  </body>
</html>
```

可以看出，代碼重複率，高達90%。

我3年前，在優酷接手過一個遺留項目。做了半年，新功能增加無數。到最後一統計，代碼量從4萬行，變成2萬行。

去掉的，就是上面兩個示例頁面的重複代碼。

怎麼去掉的呢？ 用 Layout (佈局).

## 解決辦法

把公共的代碼提取出來：

新建一個頁面： `app/views/layouts/application.html.erb`:

```
<html>
  <head>
    <title>圖書管理系統</title>
    <script src='jquery.js'></script>
  </head>
  <body>
    <%= yield %>
    <div class='footer'>
      copyright(at)2015 xx.co.ltd
    </div>
  </body>
</html>
```

其中的 `<%= yield %>` 區域，規定了會變化的內容。其他的內容，都是固定的。

這就是最簡單的也是最常見的layout.

使用方式：

在 `controller` 中， 默認就會加載  `application.html.erb` 這個文件，作爲layout.
也可以顯式的給它標記出來：

```
class BooksController < ApplicationController
  # 這個是Rails的慣例，其實不用寫。
  layout 'application'
end
```

## 如何使用不同的layout?

例如：  在不同的 controller中使用 不同的 layout：

```
class BooksController < ApplicationController
  layout 'one'
end

class FruitsController < ApplicationController
  layout 'two'
end
```


## 在同一個 controller中，不同的action使用不同的layout:


```
  def index
    render layout: "two"
  end

  def edit
    render layout: "one"
  end
```

## 我不想使用layout呢？

可以如下面所示:

```
  def index
    render layout: false
  end
```


## 什麼是`<%= yield %>` ?

回答： yield 是把某個block調用後， 在該位置顯示 結果。
也就是，所有你們寫的 erb文件的選然後的內容，最後都嵌到了這個 layout中。

(帶領大家想一下當初的ruby基礎)
例如, 我們可以定義一個ruby方法：

```
def execute_code
  puts "=== before ==="
  yield
  puts "=== after ==="
end
```
然後,執行它:

```
execute_code do
  puts "我是一段來自block的代碼"
end
```

結果：

```
=== before ===
我是一段來自block的代碼
=== after ===
```

## 佈局中，如何放 js, css ?

1.按照傳統的形式直接寫上去。
```
<link href="http://cdn.dfile.cn/v/1434451523/i1/css/dict.min.css" media="screen" rel="stylesheet" type="text/css" />
```

2.使用 `javascript_include_tag` 和 `stylesheet_link_tag`

例如，原始的html:
```
<script src="./static/javascript/jquery.min.js"></script>
<script src="./static/javascript/jqueryui.min.js"></script>
<script src="./static/javascript/bootstrap.min.js"></script>
```

在rails當中，往往把所有的js文件，都放到 `app/assets/javascripts` 目錄下。

然後：
```
<%= javascript_include_tag 'jquery.min.js' %>
<%= javascript_include_tag 'jqueryui.min.js' %>
<%= javascript_include_tag 'bootstrap.min.js' %>
```

最大的優點：`js/css` 在不同的模式下（development, production) 的路徑是不同的。
rails 會自動識別它的路徑。

以上兩種辦法法不推薦，一旦引用的外部js/css寫多了，會直接拖慢頁面打開速度.

3.使用asset pipeline

見下一章的內容.

## 實戰中不用學的

其他的都不用學。

