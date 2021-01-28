# 方法论

推荐先看我的这本书: [《软件开发之殇》](https://item.jd.com/12641896.html)

从事软件开发, 一定要有个好的方法论. 因为软件开发领域需要每天学习. 不能用笨方法去学习.

下面是我们从实战角度梳理出来的初学者最容易犯的错误.

如果您是老鸟，本节可以跳过去，不用看了。

# 搜索时间过多/过短.

花多少时间来搜索合适？

1. 先自己试着搜索1～2小时. 我的正常搜索时间： 5～20分钟。少数内容2小时内也基本搞定。
2. 如果2小时还搞不定，果断人肉问身边的同事同学。
3. 如果他还不知道，咱们就继续问别人。起码问3个。
4. 这时候，别人起码能给到你很多线索。再google/baidu.
5. 如果2小时后还不行，就上stackoverflow / tieba /zhidao /zhihu上发问。重要问题: 给额外的分数
（例如在stackoverflow上，别人回答一个题目，得10分。 如果你分数多，就可以设置bonus , 最高可以给到500）

我问过几个问题，90%都可以顺利在 stackoverflow上得到答案。 如果得不到的话，可能该问题就无解了。

# 官网上的内容比这本书的内容多的多？

该怎么办？ 比如log4r 的官网有好多内容。

http://log4r.rubyforge.org/manual.html

咱们的： http://web.siwei.tech/web_components/log4r.html

所以要知道80-20定律: 最有用的内容只有20%，但是它用在80%的地方.因此，我们的策略是：

1. 需求导向。 （我能解决实际的需求问题就行，其他的80%的内容，如果用不上，那就不学）

上面也回答了： 什么学，什么不学。 （看需求）

2. 在什么情况下学？

平时是不用学的。啥时候，老板说：这位同学，把这个需求作一下。这个时候才学。

# 小白怎么学习？

需求导向的话，要作的事儿看起来是一个点，但是官网中有一堆东西。该怎么定位？

1. 如何定位精准答案？

不要根据官网来一行文字一行文字的看。除非你的英语阅读能力很强，经验老道。

应该使用google. 例如：使用ruby on rails如何上传文件。

关键字是：`rails file upload`

会得到如下结果：

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

所以，根据经验来看，stackoverflow的内容是最精准的。

stackoverflow 上有两个问题， 一个问题15个星，一个问题35个星。 后者有62个回答。 而且内容最简单： （超级简单）

于是，我就知道了。官方网站就不用看了。

TODO: 好几个图。放到 methodologies 目录下。

# 如何搜索到这些知识？ (上面回答了，google）

# 大师是否一开始也看官网说明？

答案是：不看

对于：自己丝毫不了解的东西，我会先找到官方网站，看看LOGO啥的，找到文档的链接，看看hello world.
让自己心里有个底，知道这个东西的最权威的文档在哪里。


# 在ruby中，如何定位并且搜索？

例如：

```
$ gem install httparty
```

之后, 下面代码会报错：

```
require 'httparty'
response = HTTParty.get 'www.baidu.com'
puts response.body, response.code, response.headers
```

内容是：

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
我们如何定位问题呢？  要可以看懂这个 出错信息（ error stack)

90%的语言(java, ruby, javascript... )， 都是从下到上的执行顺序。 （python: 从上到下看。。）

这个代码的执行顺序是从下往上：

1. 先找到`abc.rb` 的第二行，
2. 再运行`httparty.rb` 598 行
3. 再运行`httparty.rb` 486 行
...

到最后， 执行的是 `/home/liyun/.rbenv/versions/2.2.1/lib/ruby/2.2.0/net/http.rb` 的 879行，出错信息是：

```
Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

上面的出错信息，就是我要搜索的内容。

为了定位准确，我加上文件名`http.rb`, 所以，我最终搜索的是下面的关键字：

```
http.rb:879:in `initialize': Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

结果： （截图）

发现第一个是push, 是gitlab 相关，我们不看（目测关联度极低）。
第二个结果： 跟ruby相关，果断点开， 发现是一个 rss 的问题。 跟httparty无关。 过。
第三个结果： 也是跟git相关。 跟httparty无关。 过。

反思： 搜索结果不准。 继续缩小范围。

于是，我加上 httpart , 搜索词换成了：

```
httparty http.rb:879:in `initialize': Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

发现结果没太大变化。因为google认为我们的搜索词没啥变化。

所以，我们修改关键词。（google 会自动忽略：879 这样的数字，有时候会，有时候又不会，我们就碰）

所以, 我们现在这样搜：

```
httparty Connection refused - connect(2) for nil port 80 (Errno::ECONNREFUSED)
```

找到第二个：

http://stackoverflow.com/questions/11768111/connection-refused-connect2-httparty

里面的一个答案：

```
I was using an incorrect url.
```

于是我们就修改代码：


```
response = HTTParty.get 'www.baidu.com'
```

改成：

```
response = HTTParty.get 'http://www.baidu.com'
```

上面就是一个完整的根据google来解决编程问题的例子。

## httparty , 在ruby中报错，跟在rails中报错，是不一样的。

rails增加了： 3个分类：

1. Application Trace
2. Framework trace
3. Full trace


### 1. Application Trace

这个是最重要的，几乎99%的错误都来自于这里，看起来如下：
```
app/controllers/books_controller.rb:8:in `index'
```

### 2. Framework trace (增加了好多rails 框架的出错路径）

这里可以看到完整的报错路径：

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


### 3. fulltrace 同上， 只不过增加了application trace 的内容：

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

# 以上报错信息如何使用？

我个人直接看rails 给出的提示。 （包括HTML页面的提示，和 rails server 的提示）

```
Completed 500 Internal Server Error in 3ms (ActiveRecord: 0.0ms)

Errno::ECONNREFUSED (Connection refused - connect(2) for nil port 80):
  app/controllers/books_controller.rb:8:in `index'

  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_source.erb (4.9ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (2.0ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (0.8ms)
  Rendered /home/liyun/.rbenv/versions/2.2.1/lib/ruby/gems/2.2.0/gems/actionpack-4.2.1/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout (17.4ms)
```

如果还没有思路， 那么直接看： full trace

# 对于一个新项目，如何着手做？

必须做到3点：

1. 要了解需求。
2. 要知道不同页面之间的跳转。
3. 要知道后台数据库的各个表之间的关系。

## 不了解需求怎么办？

多问。不要憋着。

不要自己猜，不要自己发挥，要让最直接的人来回答问题。

不耻下问。忘掉玻璃心。(很多人，你问对方的时候，对方会不耐烦。为啥不耐烦？以为他已经给别人讲过N遍了。
我们要发扬滚刀肉的精神，必须问清楚。带着很专业的态度。让它和自己心里明白，如果我不懂，项目没法作。

了解需求的时候，必须有个可以留存的东西（文字，图片，语音）

做到一次弄明白。如果不明白的话，一定是对方的逻辑错了，或者没说明白，而不是我们忘了。

## 如果不熟悉页面之间的跳转，怎么办？

1. 自己亲手来画。页面的跳转关系。（加深印象）
2. 继续问。

## 如何理清后台数据库的表之间的关系？

画图。

1. 画出所有的表。(标出表的名字和主要的列即可）
2. 不要画的漂亮。不要用尺子去比着画，而是手绘，虽然歪歪扭扭的，但是很快，可以任意修改而不心疼。
3. 所有的表都画出来之后，连接出各个表之间的关系。标注出哪边是1，哪边是多

以上几点都做完之后，就容易了，直接把主要的表的CRUD做出来。

## 如何梳理需求？

1.要了解用例图。把每个角色，要干什么事儿，写出来。

```
学员  O    ----> 可以报名
     / \   ----> 可以查看课程分类
           ----> 可以查看课程详情
           ----> 可以注册
```


2.要了解类图(class diagram). 画出class 之间的对应关系（不需要把它的所有属性都列出来）

3.要熟练掌握：时序图（sequence diagram)

3.1 列出所有的角色

3.2 按照时间点，严格的一条一条的写，从上到下

3.3 在 3.2的基础上，每个角色, 找到谁，干什么事儿，都写出来。


掌握上面三种UML图就可以了。特别是第三种，是最强大的分析问题，梳理流程的方法。

忘掉：山寨图。国内的人(特别是半吊子的人)很喜欢画，例如: http://img5.imgtn.bdimg.com/it/u=3293013674,2839859845&fm=21&gp=0.jpg

1. 没有起点
2. 没有终点。
3. 三角干吗的，正方形干吗的，没有规范。

一定要流程图的话，也使用UML的活动图。http://www.ibm.com/developerworks/cn/rational/tip-drawuml/figure1.gif

# 如何自学

## 1. 英语不能差。 英语对于程序员，就好比鼻子对于大厨。

与国外大牛交流， 要用英文。

看国外官方文档， 都是英文（就连vuejs作者是中国人，官方文档都是英文.ruby 日本人写的，官方文档还是英文）

看stackoverflow, 全都是英文。

Debug的时候，看到的报错信息全是英文。

写代码的时候，声明变量，方法等，也是用英文。

所以，英语不好，寸步难行.

## 2. 提高搜索，解决问题的能力。

遇到一个新技术，要有敏锐的嗅觉，要知道这个新技术的:

1. 官方网站在哪里。
2. 源代码地址在哪里。
3. 再看这个新技术是否有前景。（一般搜索 “技术A怎么样？", 用英文，在google上搜，就会出来特别有价值的内容)
4. 如果有价值学习，那么就来到官网，看tutorial。guide.
5. 随着学习的深入，不断的问其他人，不断的参与新项目，要与人交流，所以ruby论坛，线上的要参加，线下的也要参加。
6. 多关注一些github。
