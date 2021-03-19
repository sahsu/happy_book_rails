# 最簡單的rails 入門過程

我們創建一個新的頁面，並顯示：

## 修改路由

修改`config/routes.rb`：

```ruby
Rails.application.routes.draw do
  get 'say/hi' => 'say#hi'
end
```

這裏表示： 對於所有 `/say/hi` 的請求，都使用 `says_controller.rb` 中的`hi` action來處理。

## 修改controller

創建`app/controllers/say_controller.rb`, 內容如下：

```ruby
class SayController < ApplicationController
  def hi
  end
end
```

## 創建對應的view

創建`app/views/say/hi.html.erb`, 內容如下：

```ruby
你好啊，這是我的Rails第一個頁面
```

## 讀取頁面傳入的參數

修改`app/controllers/say_controller.rb`, 增加一個新的action

```ruby
class SayController < ApplicationController
  # 增加這個action
  def hi_with_name

    # params[:name] 用來從 request中讀取參數name,  params是Rails的內置方法
    # @name 可以在該action對應的erb文件中直接使用
    @name = params[:name]
  end
end
```

增加路由, 修改`config/routes.rb`, 增加下面內容:

```ruby
get 'say/hi_with_name' => 'say#hi_with_name'
```

增加`app/views/say/hi_with_name.html.erb`, 內容如下：

```ruby
你好阿, <%= @name %>
```

上面的代碼中，

- `<%= %>`是專門用來執行ruby代碼的區域。
- `<%= @name %>` 是顯示@name 這個變量

然後，我們訪問 `http://localhost:3000/say/hi_with_name?name=略略略

![hi_with_name](images/lesson_1_say_hi_with_name.jpeg)

## 循環顯示數組

繼續增加一個新的action, 在`app/controllers/say_controller` 中， 增加:

```ruby
class SayController < ApplicationController

  # 增加這個action
  def hi_names
  end

end
```

然後，在路由`config/routes.rb`中，增加：

```ruby
Rails.application.routes.draw do
  # 增加這個路由
  get 'say/hi_names' => 'say#hi_names'
end
```

增加視圖文件：`app/views/say/hi_names.html.erb`

```ruby
<% ['張大帥', '李大帥', '王大帥'].each do |name| %>
  你好啊，<%= name %>
  <br/>
<% end %>
```

在上面的代碼中，

- `<% %>` 是僅僅執行ruby代碼
- `<% ['張大帥', '李大帥', '王大帥'].each do ... end %>` 是一段ruby代碼,用於循環

訪問 http://localhost:3000/say/hi_names 就可以看到：

![hi_names](images/lesson_1_hi_names.jpeg)

## 不用學的。

其他的沒講到的，都不用學。 例如：

- render 'filename'
- render xxx,  :collection ...
- render xxx,  :as ...
- render xxx,  :object ...


# 作業

1.創建一個rails項目. 例如:  market

2.把該項目在本地運行起來  http://localhost:3000

3.這個項目中, 可以訪問這個路徑  http://localhost:3000/fruits/list

打開後, 頁面應該顯示下面三行內容:

```
香蕉
蘋果
橘子
```

3.上傳你的個人github空間
