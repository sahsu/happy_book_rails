# 發送 HTTP RESTFul 請求 send http request

主要靠：  httparty 這個gem 來搞定。

RESTful

HTTP 的幾種請求方法（http request methods)

refer to:  http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html

這只是個 規格說明，用來建議各大browser廠商所遵循，而事實上的類型目前只有GET, POST。

restful中所使用的僅僅是：GET, POST, PUT, DELETE。

可以認爲HTTP 請求，分成四類：

- GET： 發起請求，不改變服務器狀態。例如查看某個用戶，某個訂單
- POST ：新建數據, 需要在服務器上做新建操作。例如新建一個訂單。
- PUT ： 修改數據, 例如：修改一個用戶的名字。
- DELETE ： 刪除數據. 例如：刪掉一個用戶。


值得一提的是， 在發送request的時候，一般都會有一個header. 例如：

```
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Encoding:gzip, deflate, sdch
Accept-Language:zh-CN,zh;q=0.8,en;q=0.6
```

目前，瀏覽器中事實上存在的只有GET 和 POST兩種請求。其他的請求（例如PUT, DELETE)
需要在客戶端中模擬，並且在Rails框架中解析纔算做實現。

## 安裝

$ gem install httparty

## 發起一個 GET請求

```ruby
require 'httparty'
response = HTTParty.get 'www.baidu.com'
puts response.body, response.code, response.headers
```

## 發起請求，帶headers

```ruby
require 'httparty'
response = HTTParty.get 'www.baidu.com',  headers: {"User-Agent" => APPLICATION_NAME}
puts response.body, response.code, response.headers
```

## 發起POST 請求

```ruby
class Partay
  include HTTParty
  base_uri 'http://localhost:3000'
end

options = {
  body: {
    pear: { # your resource
      foo: '123', # your columns/data
      bar: 'second',
      baz: 'last thing'
    }
  }
}

pp Partay.post('/pears.xml', options)
```

## 使用 代理服務器

```ruby
class Foo
  include HTTParty
  http_proxy 'http://foo.com', 80, 'user', 'pass'
end
```
## 使用timeout

timeout（超時）特別重要。默認一般是30秒，你可以把它縮短成5秒甚至更少。 

```ruby
# -*- encoding : utf-8 -*-
class StaticFilesController < ApplicationController
  include HTTParty
  default_timeout 3

  def get_generator_plans
    self.class.get 'some/url'
  end
end
```

## 一個例子： 抓取並且分析遠程的接口的數據

以抓取 PPTV 在 豌豆莢的首頁 的排名爲例子。

這個接口就是： http://112.5.16.36:3011/wdj/http://startpage.wandoujia.com/api/v1/fetch?f=phoenix2&max=5&netStatus=WIFI&net=WIFI×tamp=1434693333387&id=wandoujia_android&v=4.17.1&u=7139c1b794754b9a957557a21f024fd7ba26b4ca&launchedCount=31&start=0&token=34ce2e167a88c88cc53a842665c06690&entry=other§ionItemNum=3&vc=6708&ch=wx_baidu_mm_float

用ruby 模擬這個過程：

```ruby
require 'httparty'
url  = 'http://112.5.16.36:3011/wdj/http://startpage.wandoujia.com/api/v1/fetch?f=phoenix2&max=5&netStatus=WIFI&net=WIFI×tamp=1434693333387&id=wandoujia_android&v=4.17.1&u=7139c1b794754b9a957557a21f024fd7ba26b4ca&launchedCount=31&start=0&token=34ce2e167a88c88cc53a842665c06690&entry=other§ionItemNum=3&vc=6708&ch=wx_baidu_mm_float'
response = HTTParty.get(url)

# 把response.body 轉換成JSON對象。
result =  JSON.parse(response.body)

# 通過觀察，發現該接口返回的數據中, cards是個節點。包含了我們要抓取的內容。所以，
result['cards'].each_with_index do |e, index|
    # 這裏就可以獲得 PPTV 所在的位置了。
    puts "#{e['feedItem']['title']}, index: #{index}"
end
```

下面是結果：

```bash
口袋成語, index: 0
中華英雄傳, index: 1
我愛封神, index: 2
KK唱響, index: 3
.....
PPTV聚力, index: 49
QQ瀏覽器, index: 50
...
```

注意:

1.  對於某些接口,需要用漢字轉換到 unicode , 見:  http://pages.ucsd.edu/~dkjordan/resources/unicodemaker.html

2. 對於 url, 有時候轉到的是原始URL, 有的是 編碼後的URL, 在這裏也可以轉換: http://meyerweb.com/eric/tools/dencoder/

