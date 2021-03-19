
# 分頁(Pagination)

## 介紹

在任何一個語言中，分頁功能都是最重要的功能之一。

它的基本原理是： 給出第幾頁，每頁多少條記錄，就能在數據庫中查找對應的記錄。

在MySQL中，使用 limit + offset 關鍵字，  在其他數據庫中也有對應的內容。

在2000年左右，曾經流行過一種分頁方式：一次性讀出所有的數據庫記錄，然後在前臺決定是否展示。 不過由於這種方法在邏輯上是很低效的，所以我們一般不採納。

在Rails2，3的時代，我們使用 will pagination, 在Rails3 之後，我們都使用Kaminari
( https://github.com/amatsuda/kaminari )

![一個例子](/images/pagination.png)

## 使用

假設我們在一個Rails3 的項目中：

修改 `Gemfile`:
```
gem 'kaminari'
```

然後 ` $ bundle install`

例如，我們要按照每頁 100條記錄， 查找第二頁的User內容：

```
users = User.page(2).per(100)
users.each do |user|
  puts "user: #{user.inspect}"
end
```

非常簡單吧？ 上面的 users 是一個Array.

使用步驟：

1. 在View中：

```
<%= paginate @users %>
```
上述代碼會產生一個分頁的鏈接組，形如：  `« First ‹ Prev ... 2 3 4 5 6 7 8 9 10 ... Next › Last »`,  點擊其中任意一頁，就會跳轉到形如：`/users?page=2`

2. 在controller中：

```
@users = User.page(params[:page]).per(100)
```
在 controller中，你也完全可以把per, page 與查詢語句where ,order等混用：

```
@users = User.where('name like ?', '%jim%').order('name').page(params[:page]).per(100)
```

## 配置文件： config/initializers/

可以通過下列命令生成全局配置文件：
```bash
$ bundle exec rails g kaminari:config
```

該文件具體看起來是：

```ruby
default_per_page      # 25 by default
max_per_page          # nil by default
max_pages             # nil by default
window                # 4 by default
outer_window          # 0 by default
left                  # 0 by default
right                 # 0 by default
page_method_name      # :page by default
param_name            # :page by default
params_on_first_page  # false by default
```

你可以根據自己的喜好來修改。

## i18n

默認情況下，分頁產生的鏈接形如： `first, previous`, 需要把它漢化，我們可以這樣：

1. 設置rails的 locale是zh-CN
2. 在Rails.root/config/locales 中，增加一個語言文件(zh-CN.yml)

```yml
# 以下文件只是示例，不完整。
zh-CN:
  views:
    pagination:
      first: "&laquo; 首頁"
      last: "末頁 &raquo;"
      previous: "&lsaquo; 上頁"
      next: "下頁 &rsaquo;"
```

Karminari還有更多的作用，例如在Sinatra等框架中使用，爲普通的Array做分頁，針對Mongoid做分頁等等。 具體請看官方文檔。

## config/routes.rb中，root路徑要放在下面，否則會引起分頁鏈接錯誤

今天很奇怪，遇到一個問題： kaminari 在分頁時 ，如果 被分頁內容是 root_path, 那麼在分頁helper中的路徑， 就不是完整的。形式（例如 /client/pids?page=2 ) ，而是以 '/？page=2' 這樣的形式顯示。 ( today I met a problem caused by a root_path declaration in the top of my routes.rb file .  the problem is : the links in pagination helper is not displayed as standard path, but a root path)

解決辦法： 把 config/routes.rb中的 root聲明放在 下面

```
# in config/routes.rb
   match '/logout' => "users#logout", :as => :logout
   namespace "client" do
     resources "vendors", "pids", "os", "pid_logs",
     ......
     end
   end

  root :to => 'users#index'
```
