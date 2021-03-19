# rails+thin服務部署


## 介紹.
rails的 運行方式：  3種：

### 1.development.

日常開發使用的模式。 該模式下，我們對於rb文件的改動，會立即生效 （不用重啓服務器了！ ）

不要小看這一點。 在其他的語言，其他的框架中，都要重啓的。 （java => tomcat.   python => pyramid. )

這個特性，能爲我們省太多的事兒了。

注意： 開發模式下，如果修改 config 目錄下的內容， 就一定要重啓服務器。

### 2.production

生產模式。部署的時候，務必使用這個模式。

生產模式下，rails的所有文件，都會一次性的被加載到內存中。 所以它運行起來，速度
特別快。（development模式，則是： 每次接受到請求時，都會 重新加載資源，所以就慢，
）所以，該模式下，我們對rb文件的改動，必須重啓之後才能生效。

另外，在Rails 3.0以後，引入了： "asset pipline "

所以，在這個版本以後，部署就多了一些內容。(多運行一個命令)

### 3.test

一般人用不上。 但是我們要用。 這個是測試環境。 在運行單元測試的時候，使用。
它的特點： 每次運行測試前，數據庫的內容都會清空。

### 針對3個環境的配置文件

打開 `config/environments` 文件夾，可以看到3個配置文件。

```
▾ config/
  ▾ environments/
      development.rb
      production.rb
      test.rb
```

每個配置文件，對應一種 rails的 運行模式。

打開 config/database.yml, 也可以看到針對3個環境的不同配置：

```
 development:
   adapter: mysql2
   database: my_library
   username: root
   password: 666
   host: localhost

 production:
   adapter: mysql2
   database: my_library
   username: root
   password: 666
   host: localhost

 test:
   adapter: mysql2
   database: my_library
   username: root
   password: 666
   host: localhost
```


## 以development 模式運行

```
$ bundle exec rails server
```

它默認：

1. 跑在本地
2. 端口： 3000
3. 方式： development

啓動後,在瀏覽器中輸入 `http://localhost:3000` 即可訪問.

## production 模式。

下面是兩種進入到production模式的辦法：

### 1. 最快但是不推薦的辦法

```
$ bundle exec rails server -e production
```

最入門，也最low。 它用的服務器，是 rails自帶的服務器(webrick)。 性能不好(類似於數據庫中的 sqlite)。
同時10個請求訪問，就會卡。所以不要用。

而且css, images, 都不會正常顯示出來.

優點: 做 測試部署 的時候，可以用。 用這個命令，可以快速的判定，當前的環境能否適合部署。


### 2. 最常見的模式

使用 (應用服務器）`thin/unicorn/passenger` + (靜態服務器）`nginx` 的方式來部署。

- 應用服務器:  專門負責生成動態的內容(例如：rails/java)的服務器。 （例如： erb => html )

- 靜態服務器： 跟應用的語言無關。 只處理靜態的資源。 （例如：

  - 返回  jpg 圖片。
  - 返回  css
  - 返回 靜態的 html 頁面 (500, 404）
  - 返回  "應用服務器” 處理好的 html 頁面）

也就是說， 靜態服務器，可以直接 運行 靜態站點。


策略：

1.請求的是： rails 的資源, 那麼請求就會 先被 nginx 攔截。
之後，nginx發現；這個資源應該由  rails服務器來處理。 再把請求交給
rails服務器。

rails服務器處理好之後， 把結果返回給nginx, nginx再把結果返回給瀏覽器。

2.如果請求的是： css/js/普通的html頁面， 那麼 nginx 就直接處理，返回給瀏覽器。

```
browser          |    nginx               |        thin
request(1個)     <=>    80端口(一個請求）  <=>    3001
                                           <=>    3002
                                           <=>    3003
                                           <=>    3004
```

## 幾個rails服務器的對比

### 1. passenger

是跟nginx 結合的特別密切的服務器。 不建議使用。

普通使用： 沒問題。

缺點：
如果一臺服務器上，部署了10個rails 的項目。 那麼：
每次重啓passenger, 10個項目都要一起重啓。 或者： 一起關閉。這個是不合理的。

問題在下列情況會特別凸顯：

例如： 在優酷，當時我們有20個rails子項目。 其中19個，訪問量，佔了 0.04%。
另外一個應用的訪問量： 99.96% .   它必須 24x7的跑着。不能有當機時間。30秒都不行。

那麼問題來了：  我只希望部署一個rails應用，但是，passenger 要求我強制重啓
20個rails應用，每次整體一重啓, 各種報警全面飆紅（在運維同學的後臺上），相關
的負責人，手機卡卡報警短信。

所以，不要用passenger. 無論rails的作者怎麼鼓吹（現在也不提了）。

### 2. unicorn

我沒用過。不提了。 但是看過別人用。配置麻煩，調試麻煩，不適合新手。
執行效率也沒見的提高多少。

### 3. webrick

rails 自帶的服務器。 官方不提倡使用。它的性能不好。 優點：
直接上手 。 加個參數 就可以用了, 例如：

```
$ bundle exec rails server -e production
```

### 4. mongrel

`Thin` 的前身。 10年以前很多人用。 後來 mongrel 項目停掉了。 用起來跟Thin一樣.

### 5. Thin.

提倡使用。 優點：

5.1 上手特別簡單。`$ bundle exec thin start/stop/restart -C config.yml`
5.2 性能特別好。
5.3 調試方便。
5.4 非常方便的可以與nginx做整合。

## 如何使用Thin?

官網： http://code.macournoyer.com/thin/

1.在Gemfile中，增加內容：

```
gem 'thin'
```

2.安裝gem:

```
$ bundle install
```

3.啓動

```
$ bundle exec thin start
Using rack adapter
Thin web server (v1.7.0 codename Dunder Mifflin)
Maximum connections set to 1024
Listening on 0.0.0.0:3000, CTRL+C to stop
```

這時, Rails服務器默認啓動在 3000端口， 使用development模式。

4.使用 production模式

雖然 thin 也支持 各種參數（修改`port`, `host` , `environment` ... ）跟 `rails server` 一樣，

但是我們在實戰中，使用配置文件來運行.（最大的好處： 一次可以啓動多個thin進程，跑在不同
的端口上）

配置文件如下：

```
# 文件名: config/thin.yml
chdir: /opt/app/siwei.me/current   # 你的rails 應用的所在目錄
environment: production    # 指定了 是 production模式
address: 0.0.0.0
port: 3001                 # 端口號。
timeout: 30
max_conns: 1024
max_persistent_conns: 100
require: []
wait: 30
servers: 2                 # 很重要。希望啓動的thin 的進程數。
daemonize: true
```

上面，需要注意的，就是幾個：

- `chdir`: 進程的初始位置。務必與rails項目路徑相同。
- `environment`： production/development
- `port`: 起始的端口號。 例如： 3001
- `servers`: 希望啓動的thin 的總進程數。 例如：我寫成4. 那麼啓動thin之後，
就會有4個thin的進程，分別運行在：  3001, 3002, 3003, 3004 端口上。


啓動production模式的Rails 之前, 記得在 `config/secrets.yml` 中，加上以下內容:
```
production:
  secret_key_base: a1b2c3d4a5d6...z100 #該內容應該隨機生成
```

### 啓動Thin

配置文件寫好後， 啓動 它:

```
$ bundle exec thin start -C config/thin.yml
Starting server on 0.0.0.0:3001 ...
Starting server on 0.0.0.0:3002 ...
Starting server on 0.0.0.0:3003 ...
Starting server on 0.0.0.0:3004 ...
```

### 停止Thin

```
$ bundle exec thin stop -C config/thin.yml
```

### 重啓Thin

```
$ bundle exec thin restart -C config/thin.yml
```


## 使用 thin + nginx 來部署。

前提：

1. 要使用 asset pipeline. 對現有的 asset pipeline進行編譯:

```
$ bundle exec rake assets:precompile RAILS_ENV=production
```

以上操作大約耗時1-15分鐘不等. 看你用的asset pipeline如何了.
它會生成大量的assets 編譯後的文件.

2. 在nginx中，進行設置。 讓nginx來響應對於 css， js的請求。

修改 nginx的配置文件如下：( 注意： `location ~ ^/assets/` 這句話。 )

```
  server {
          listen       80;
          server_name  railsgirlsbeijing.com;
          charset utf-8;
          location / {
              proxy_pass          http://rails_girls_site;
              proxy_redirect      default;
              proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header    X-Real-IP $remote_addr;
              proxy_set_header    Host $http_host;
              proxy_next_upstream http_502 http_504 error timeout invalid_header;
          }
          # 這句話，最重要。
          # 表示，所有url中，以 /assets 開頭的 url， 都會被nginx所響應。
          location ~ ^/assets/ {

            # 表示，處理這些請求的話，應該從哪個文件夾開始。
            root /opt/app/siwei/rails_girls_cn/shared;
            expires 1y;
            add_header Cache-Control public;
            add_header ETag "";
            break;
          }
  }
  upstream rails_girls_site{
    server localhost:3560;
    server localhost:3561;
  }
```

記得在 config/environments/production.rb文件中：

```
Cms::Application.configure do
    # 不讓 rails 來處理 /assets 開頭的 url, 這些要交給nginx來處理.
    config.serve_static_assets = false
end
```

修改好配置後, 記得重啓nginx:

```
$ sudo nginx -s reload   # 重啓服務器
```

## 調試Rails 服務器:

手段是看Log(日誌).

不管你用哪種服務器(thin, passenger ... ), 日誌會被放在 `log`目錄下。 例如：

```
$ ls log
development.log  thin.3001.log	thin.3003.log
production.log	 thin.3002.log	thin.3004.log
```

當你的rails項目沒有跑起來時，就來這裏看log。

```
$ ps -ef | grep thin
siwei   21020     1  8 10:06 ?        00:00:02 thin server (0.0.0.0:3001)
siwei   21030     1  9 10:06 ?        00:00:02 thin server (0.0.0.0:3002)
siwei   21040     1  9 10:06 ?        00:00:02 thin server (0.0.0.0:3003)
siwei   21052     1  7 10:06 ?        00:00:02 thin server (0.0.0.0:3004)
siwei   21069 19171  0 10:06 pts/2    00:00:00 grep thin
```

優酷的項目， 都是  `nginx + thin`

## 問題： 開多少個thin進程合適？

有多少個CPU內核，就開多少個thin進程。
例如： 4核CPU， 一般開： 4個 thin 進程。（同理， nginx的  worker也是一樣）

# 作業：

1. 在服務器上， 建立一個靜態站點。
2. 在服務器上， 運行 rails的production 模式。

# nginx 內容： 見 operation.siwei.tech

