#Bootstrap & Rails
Bootstrap是一個非常棒的CSS/HTML的框架，最初來自Twitter。它能讓我們很快開發出很多web應用，並且適配各種屏幕和項目。

關於Bootstrap的介紹就不多講了，畢竟它現在是最流行的HTML,CSS,JS框架。當我們把它和Rails一起來用的時候，會給我們帶來更多的便利，我們就來看看如何把bootstarp與rails結合使用。

##下載
首先下載可以去bootstrap官網下載，官網提供三種下載：一是編譯並壓縮後的 CSS、JavaScript 和字體文件。不包含文檔和源碼文件；二是Less、JavaScript 和 字體文件的源碼，並且帶有文檔。需要 Less 編譯器和一些設置工作。三是 Bootstrap 從 Less 到 Sass 的源碼移植項目，用於快速地在 Rails、Compass 或 只針對 Sass 的項目中引入。

我們可以選擇任一種，只是第三種對rails進行了特定設置，使用的時候會相對更方便些。下面我們就來看看第三種的用法。

##用法
在Rails中`bootstrap-sass`是一個gem，使用起來非常簡單。

Gem:

gem 'twitter-bootstrap-rails', '3.2.0'

$ bundle install

$ rails generate bootstrap:install static

修改application.js:

+//= require twitter/bootstrap

修改 application.css:

+ *= require bootstrap_and_overrides.css

## 去掉  turbo-links

-  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
-  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
+  <%= stylesheet_link_tag    'application', media: 'all' %>
+  <%= javascript_include_tag 'application' %>


然後就可以開始在代碼中使用bootstrap了。
