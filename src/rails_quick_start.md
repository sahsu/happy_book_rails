# 最简单的rails 入门过程



先从一个例子来看：

http://localhost:3000/fruits/new

上面的url, 如果是按照rails的约定惯例来看的话，就是： new 一个 fruit.  (显示 新建fruit的页面）

所以，rails会把这个请求，根据路由中定义的规则，发送给 action。

1.一个用户在浏览器端输入了一个网址:

http://server.com/fruits/new

回车。(这会产生 一个 http request )

2.http request 从浏览器，发送到服务器端(server.com)之后， Rails就会 把这个请求交给 router 来处理。

(接下来的事儿，都发生在 服务器端, 见上面的小王例子。）

3.在服务器上，有个router 配置文件： `config/routes.rb` 中的配置：

```
Rails.application.routes.draw do
  resources :fruits
end
```

把这个请求，分发到： `fruits` controller中的`new` action.

4.`new` action 做处理，显示对应的erb文件

```
class FruitsController < ApplicationController
  def new

    # 方式1. 渲染 一段字符串
    #render :text => 'hihihi'

    # 方式2. 渲染 一个json
    #render  :json => {
    #  key: 'value',
    #  name: 'dashi',
    #  sex: 'male'
    #}

    # 方式3. 啥也不写，就渲染对应的
    #  app/views/fruits/new.html.erb
  end
end
```

5.如果要渲染的是一个 erb 页面， 我们可以这样写：

```
你好阿。
<% [1,2,3].each do |e| %>
  <%= e %> <br/>
<% end %>

```

6.有时候如果某个erb文件过于复杂了, 例如：20行。或者某些代码可以重用。

```
<!-- 下面这段是版权声明，多个页面都需要重用  -->
<footer>
  copyright@2016 xx.co.ltd
</footer>
```

那么就把它写成一个 partial (片段）(注意，文件名以 `_` 开头) `app/views/fruits/_footer.html.erb`

然后，我们就可以在对应的 erb文件中：

```
<%= render :partial => 'footer' %>
```

如果这个partial是需要参数的（例如:年份是个变量）

```

<!-- 下面这段是版权声明，多个页面都需要重用  -->
<footer>
  copyright@ <%= year %> sweetysoft.com
</footer>

```

那么在调用时, 就这样把参数传入到partial：

```
<%= render :partial => 'footer', :locals => {:year => 2018} %>
```

## 不用学的。

其他的没讲到的，都不用学。 例如：

- render 'filename'
- render xxx,  :collection ...
- render xxx,  :as ...
- render xxx,  :object ...


# 作业

1.创建一个rails项目. 例如:  market

2.把该项目在本地运行起来  http://localhost:3000

2.这个项目中, 大家可以访问这个路径  http://localhost:3000/fruits/list

打开后, 页面应该显示下面三行内容:

```
香蕉
苹果
橘子
```

3.上传你的个人github空间
