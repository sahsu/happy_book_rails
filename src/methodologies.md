# 方法論

推薦先看我的這本書: [《軟件開發之殤》](https://item.jd.com/12641896.html)

從事軟件開發, 一定要有個好的方法論. 因爲軟件開發領域需要每天學習. 不能用笨方法去學習.

下面是我們從實戰角度梳理出來的初學者最容易犯的錯誤.

如果您是老鳥，本節可以跳過去，不用看了。

# 搜索時間過多/過短.

花多少時間來搜索合適？

1. 先自己試着搜索1～2小時. 我的正常搜索時間： 5～20分鐘。少數內容2小時內也基本搞定。
2. 如果2小時還搞不定，果斷人肉問身邊的同事同學。
3. 如果他還不知道，咱們就繼續問別人。起碼問3個。
4. 這時候，別人起碼能給到你很多線索。再google/baidu.
5. 如果2小時後還不行，就上stackoverflow / tieba /zhidao /zhihu上發問。重要問題: 給額外的分數
（例如在stackoverflow上，別人回答一個題目，得10分。 如果你分數多，就可以設置bonus , 最高可以給到500）

我問過幾個問題，90%都可以順利在 stackoverflow上得到答案。 如果得不到的話，可能該問題就無解了。

# 官網上的內容比這本書的內容多的多？

該怎麼辦？ 比如log4r 的官網有好多內容。

http://log4r.rubyforge.org/manual.html

咱們的： http://web.siwei.tech/web_components/log4r.html

所以要知道80-20定律: 最有用的內容只有20%，但是它用在80%的地方.因此，我們的策略是：

1. 需求導向。 （我能解決實際的需求問題就行，其他的80%的內容，如果用不上，那就不學）

上面也回答了： 什麼學，什麼不學。 （看需求）

2. 在什麼情況下學？

平時是不用學的。啥時候，老闆說：這位同學，把這個需求作一下。這個時候才學。

# 小白怎麼學習？

需求導向的話，要作的事兒看起來是一個點，但是官網中有一堆東西。該怎麼定位？

1. 如何定位精準答案？

不要根據官網來一行文字一行文字的看。除非你的英語閱讀能力很強，經驗老道。

應該使用google. 例如：使用ruby on rails如何上傳文件。

關鍵字是：`rails file upload`

會得到如下結果：

```
Ruby on Rails File Uploading - TutorialsPoint
https://www.tutorialspoint.com/ruby...rails/rails-file-uploading.ht...
You may have a requirement in which you want your site visitors to upload a file on your server. Rails makes it very easy to handle this requirement. Now we will ...
ruby - Uploading a file in Rails - Stack Overflow
stackoverflow.com/questions/14174044/uploading-a-file-in-rails

2013. 1. 5. - While there are plenty of gems that solve file uploading pretty nicely (see https://www.ruby-toolbox.com/categories/rails_file_uploads for a list), rails ...
How to upload a file in ruby on rails? - Stack Overflow
stackoverflow.com/.../how-to-upload-a-file-in-ruby-on-rails

2012. 7. 5. - I'm very new in ruby on rails. I'm stuck with a problem. I want to make a ... Thank you for example, I study rails too! It works in rails 3.1. My code:
Form Helpers — Ruby on Rails Guides
guides.rubyonrails.org/form_helpers.html
What makes a file upload form different. How to post forms to external resources and specify setting an authenticity_token . How to build complex forms.
```

所以，根據經驗來看，stackoverflow的內容是最精準的。

stackoverflow 上有兩個問題， 一個問題15個星，一個問題35個星。 後者有62個回答。 而且內容最簡單： （超級簡單）

於是，我就知道了。官方網站就不用看了。

TODO: 好幾個圖。放到 methodologies 目錄下。

# 如何搜索到這些知識？ (上面回答了，google）

# 大師是否一開始也看官網說明？

答案是：不看

對於：自己絲毫不瞭解的東西，我會先找到官方網站，看看LOGO啥的，找到文檔的鏈接，看看hello world.
讓自己心裏有個底，知道這個東西的最權威的文檔在哪裏。


# 在ruby中，如何定位並且搜索？

例如：

```
$ gem install httparty
```

之後, 下面代碼會報錯：

```
require 'httparty'
response = HTTParty.get 'www.baidu.com'
puts response.body, response.code, response.headers
```

內容是：

```
liyun@hp:~/workspace/happy_book_rails$ ruby abc.rb
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `initialize': Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `open'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `block in connect'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/timeout.rb:74:in `timeout'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:878:in `connect'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:863:in `do_start'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:852:in `start'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:1375:in `request'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/httparty-0.14.0/lib/httparty/request.rb:118:in `perform'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/httparty-0.14.0/lib/httparty.rb:560:in `perform_request'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/httparty-0.14.0/lib/httparty.rb:486:in `get'
	from /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/httparty-0.14.0/lib/httparty.rb:598:in `get'
	from abc.rb:2:in `<main>'
```
我們如何定位問題呢？  要可以看懂這個 出錯信息（ error stack)

90%的語言(java, ruby, javascript... )， 都是從下到上的執行順序。 （python: 從上到下看。。）

這個代碼的執行順序是從下往上：

1. 先找到`abc.rb` 的第二行，
2. 再運行`httparty.rb` 598 行
3. 再運行`httparty.rb` 486 行
...

到最後， 執行的是 `/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb` 的 879行，出錯信息是：

```
Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

上面的出錯信息，就是我要搜索的內容。

爲了定位準確，我加上文件名`http.rb`, 所以，我最終搜索的是下面的關鍵字：

```
http.rb:879:in `initialize': Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

結果： （截圖）

發現第一個是push, 是gitlab 相關，我們不看（目測關聯度極低）。
第二個結果： 跟ruby相關，果斷點開， 發現是一個 rss 的問題。 跟httparty無關。 過。
第三個結果： 也是跟git相關。 跟httparty無關。 過。

反思： 搜索結果不準。 繼續縮小範圍。

於是，我加上 httpart , 搜索詞換成了：

```
httparty http.rb:879:in `initialize': Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

發現結果沒太大變化。因爲google認爲我們的搜索詞沒啥變化。

所以，我們修改關鍵詞。（google 會自動忽略：879 這樣的數字，有時候會，有時候又不會，我們就碰）

所以, 我們現在這樣搜：

```
httparty Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

找到第二個：

http://stackoverflow.com/questions/11768111/connection-refused-connect2-httparty

裏面的一個答案：

```
I was using an incorrect url.
```

於是我們就修改代碼：


```
response = HTTParty.get 'www.baidu.com'
```

改成：

```
response = HTTParty.get 'http://www.baidu.com'
```

上面就是一個完整的根據google來解決編程問題的例子。

## httparty , 在ruby中報錯，跟在rails中報錯，是不一樣的。

rails增加了： 3個分類：

1. Application Trace
2. Framework trace
3. Full trace


### 1. Application Trace

這個是最重要的，幾乎99%的錯誤都來自於這裏，看起來如下：
```
app/controllers/books_controller.rb:8:in `index'
```

### 2. Framework trace (增加了好多rails 框架的出錯路徑）

這裏可以看到完整的報錯路徑：

```
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `initialize'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `open'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `block in connect'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/timeout.rb:74:in `timeout'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:878:in `connect'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:863:in `do_start'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:852:in `start'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:1375:in `request'
 httparty (0.14.0) lib/httparty/request.rb:118:in `perform'
 httparty (0.14.0) lib/httparty.rb:560:in `perform_request'
 httparty (0.14.0) lib/httparty.rb:486:in `get'
 httparty (0.14.0) lib/httparty.rb:598:in `get'
 actionpack (4.2.1) lib/action_controller/metal/implicit_render.rb:4:in `send_action'
 actionpack (4.2.1) lib/abstract_controller/base.rb:198:in `process_action'
 actionpack (4.2.1) lib/action_controller/metal/rendering.rb:10:in `process_action'
 actionpack (4.2.1) lib/abstract_controller/callbacks.rb:20:in `block in process_action'
 activesupport (4.2.1) lib/active_support/callbacks.rb:117:in `call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:117:in `call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:555:in `block (2 levels) in compile'
 activesupport (4.2.1) lib/active_support/callbacks.rb:505:in `call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:505:in `call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:92:in `_run_callbacks'
 activesupport (4.2.1) lib/active_support/callbacks.rb:776:in `_run_process_action_callbacks'
 activesupport (4.2.1) lib/active_support/callbacks.rb:81:in `run_callbacks'
 actionpack (4.2.1) lib/abstract_controller/callbacks.rb:19:in `process_action'
 actionpack (4.2.1) lib/action_controller/metal/rescue.rb:29:in `process_action'
 actionpack (4.2.1) lib/action_controller/metal/instrumentation.rb:32:in `block in process_action'
 activesupport (4.2.1) lib/active_support/notifications.rb:164:in `block in instrument'
 activesupport (4.2.1) lib/active_support/notifications/instrumenter.rb:20:in `instrument'
 activesupport (4.2.1) lib/active_support/notifications.rb:164:in `instrument'
 actionpack (4.2.1) lib/action_controller/metal/instrumentation.rb:30:in `process_action'
 actionpack (4.2.1) lib/action_controller/metal/params_wrapper.rb:250:in `process_action'
 activerecord (4.2.1) lib/active_record/railties/controller_runtime.rb:18:in `process_action'
 actionpack (4.2.1) lib/abstract_controller/base.rb:137:in `process'
 actionview (4.2.1) lib/action_view/rendering.rb:30:in `process'
 actionpack (4.2.1) lib/action_controller/metal.rb:196:in `dispatch'
 actionpack (4.2.1) lib/action_controller/metal/rack_delegation.rb:13:in `dispatch'
 actionpack (4.2.1) lib/action_controller/metal.rb:237:in `block in action'
 actionpack (4.2.1) lib/action_dispatch/routing/route_set.rb:74:in `call'
 actionpack (4.2.1) lib/action_dispatch/routing/route_set.rb:74:in `dispatch'
 actionpack (4.2.1) lib/action_dispatch/routing/route_set.rb:43:in `serve'
 actionpack (4.2.1) lib/action_dispatch/journey/router.rb:43:in `block in serve'
 actionpack (4.2.1) lib/action_dispatch/journey/router.rb:30:in `each'
 actionpack (4.2.1) lib/action_dispatch/journey/router.rb:30:in `serve'
 actionpack (4.2.1) lib/action_dispatch/routing/route_set.rb:819:in `call'
 rack (1.6.4) lib/rack/etag.rb:24:in `call'
 rack (1.6.4) lib/rack/conditionalget.rb:25:in `call'
 rack (1.6.4) lib/rack/head.rb:13:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/params_parser.rb:27:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/flash.rb:260:in `call'
 rack (1.6.4) lib/rack/session/abstract/id.rb:225:in `context'
 rack (1.6.4) lib/rack/session/abstract/id.rb:220:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/cookies.rb:560:in `call'
 activerecord (4.2.1) lib/active_record/query_cache.rb:36:in `call'
 activerecord (4.2.1) lib/active_record/connection_adapters/abstract/connection_pool.rb:649:in `call'
 activerecord (4.2.1) lib/active_record/migration.rb:378:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/callbacks.rb:29:in `block in call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:88:in `call'
 activesupport (4.2.1) lib/active_support/callbacks.rb:88:in `_run_callbacks'
 activesupport (4.2.1) lib/active_support/callbacks.rb:776:in `_run_call_callbacks'
 activesupport (4.2.1) lib/active_support/callbacks.rb:81:in `run_callbacks'
 actionpack (4.2.1) lib/action_dispatch/middleware/callbacks.rb:27:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/reloader.rb:73:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/remote_ip.rb:78:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call'
 railties (4.2.1) lib/rails/rack/logger.rb:38:in `call_app'
 railties (4.2.1) lib/rails/rack/logger.rb:20:in `block in call'
 activesupport (4.2.1) lib/active_support/tagged_logging.rb:68:in `block in tagged'
 activesupport (4.2.1) lib/active_support/tagged_logging.rb:26:in `tagged'
 activesupport (4.2.1) lib/active_support/tagged_logging.rb:68:in `tagged'
 railties (4.2.1) lib/rails/rack/logger.rb:20:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/request_id.rb:21:in `call'
 rack (1.6.4) lib/rack/methodoverride.rb:22:in `call'
 rack (1.6.4) lib/rack/runtime.rb:18:in `call'
 activesupport (4.2.1) lib/active_support/cache/strategy/local_cache_middleware.rb:28:in `call'
 rack (1.6.4) lib/rack/lock.rb:17:in `call'
 actionpack (4.2.1) lib/action_dispatch/middleware/static.rb:113:in `call'
 rack (1.6.4) lib/rack/sendfile.rb:113:in `call'
 railties (4.2.1) lib/rails/engine.rb:518:in `call'
 railties (4.2.1) lib/rails/application.rb:164:in `call'
 rack (1.6.4) lib/rack/lock.rb:17:in `call'
 rack (1.6.4) lib/rack/content_length.rb:15:in `call'
 rack (1.6.4) lib/rack/handler/webrick.rb:88:in `service'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/webrick/httpserver.rb:138:in `service'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/webrick/httpserver.rb:94:in `run'
 /home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/webrick/server.rb:294:in `block in start_thread'
```


### 3. fulltrace 同上， 只不過增加了application trace 的內容：

```
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `initialize'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `open'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:879:in `block in connect'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/timeout.rb:74:in `timeout'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:878:in `connect'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:863:in `do_start'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:852:in `start'
/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb:1375:in `request'
httparty (0.14.0) lib/httparty/request.rb:118:in `perform'
httparty (0.14.0) lib/httparty.rb:560:in `perform_request'
httparty (0.14.0) lib/httparty.rb:486:in `get'
httparty (0.14.0) lib/httparty.rb:598:in `get'
app/controllers/books_controller.rb:8:in `index'
.... (以下同 framework trace )
```

# 以上報錯信息如何使用？

我個人直接看rails 給出的提示。 （包括HTML頁面的提示，和 rails server 的提示）

```
Completed 500 Internal Server Error in 3ms (ActiveRecord: 0.0ms)

Errno::ECONNREFUSED (Connection refused - connect(2) for nil port 80):
  app/controllers/books_controller.rb:8:in `index'

  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_source.erb (4.9ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (2.0ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (0.8ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout (17.4ms)
```

如果還沒有思路， 那麼直接看： full trace

# 對於一個新項目，如何着手做？

必須做到3點：

1. 要了解需求。
2. 要知道不同頁面之間的跳轉。
3. 要知道後臺數據庫的各個表之間的關係。

## 不瞭解需求怎麼辦？

多問。不要憋着。

不要自己猜，不要自己發揮，要讓最直接的人來回答問題。

不恥下問。忘掉玻璃心。(很多人，你問對方的時候，對方會不耐煩。爲啥不耐煩？以爲他已經給別人講過N遍了。
我們要發揚滾刀肉的精神，必須問清楚。帶着很專業的態度。讓它和自己心裏明白，如果我不懂，項目沒法作。

瞭解需求的時候，必須有個可以留存的東西（文字，圖片，語音）

做到一次弄明白。如果不明白的話，一定是對方的邏輯錯了，或者沒說明白，而不是我們忘了。

## 如果不熟悉頁面之間的跳轉，怎麼辦？

1. 自己親手來畫。頁面的跳轉關係。（加深印象）
2. 繼續問。

## 如何理清後臺數據庫的表之間的關係？

畫圖。

1. 畫出所有的表。(標出表的名字和主要的列即可）
2. 不要畫的漂亮。不要用尺子去比着畫，而是手繪，雖然歪歪扭扭的，但是很快，可以任意修改而不心疼。
3. 所有的表都畫出來之後，連接出各個表之間的關係。標註出哪邊是1，哪邊是多

以上幾點都做完之後，就容易了，直接把主要的表的CRUD做出來。

## 如何梳理需求？

1.要了解用例圖。把每個角色，要幹什麼事兒，寫出來。

```
學員  O    ----> 可以報名
     / \   ----> 可以查看課程分類
           ----> 可以查看課程詳情
           ----> 可以註冊
```


2.要了解類圖(class diagram). 畫出class 之間的對應關係（不需要把它的所有屬性都列出來）

3.要熟練掌握：時序圖（sequence diagram)

3.1 列出所有的角色

3.2 按照時間點，嚴格的一條一條的寫，從上到下

3.3 在 3.2的基礎上，每個角色, 找到誰，幹什麼事兒，都寫出來。


掌握上面三種UML圖就可以了。特別是第三種，是最強大的分析問題，梳理流程的方法。

忘掉：山寨圖。國內的人(特別是半吊子的人)很喜歡畫，例如: http://img5.imgtn.bdimg.com/it/u=3293013674,2839859845&fm=21&gp=0.jpg

1. 沒有起點
2. 沒有終點。
3. 三角幹嗎的，正方形幹嗎的，沒有規範。

一定要流程圖的話，也使用UML的活動圖。http://www.ibm.com/developerworks/cn/rational/tip-drawuml/figure1.gif

# 如何自學

## 1. 英語不能差。 英語對於程序員，就好比鼻子對於大廚。

與國外大牛交流， 要用英文。

看國外官方文檔， 都是英文（就連vuejs作者是中國人，官方文檔都是英文.ruby 日本人寫的，官方文檔還是英文）

看stackoverflow, 全都是英文。

Debug的時候，看到的報錯信息全是英文。

寫代碼的時候，聲明變量，方法等，也是用英文。

所以，英語不好，寸步難行.

## 2. 提高搜索，解決問題的能力。

遇到一個新技術，要有敏銳的嗅覺，要知道這個新技術的:

1. 官方網站在哪裏。
2. 源代碼地址在哪裏。
3. 再看這個新技術是否有前景。（一般搜索 “技術A怎麼樣？", 用英文，在google上搜，就會出來特別有價值的內容)
4. 如果有價值學習，那麼就來到官網，看tutorial。guide.
5. 隨着學習的深入，不斷的問其他人，不斷的參與新項目，要與人交流，所以ruby論壇，線上的要參加，線下的也要參加。
6. 多關注一些github。
