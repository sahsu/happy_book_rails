#  如何寫接口 (下面有很多在app端的內容)

## 一個例子。

(務必先安裝一個json的插件，例如：jsonview)

文檔看起來是：

```
展示所有案例列表

前臺請求入口：進入home頁面後，點擊悅案例
後臺操作入口： 案例管理 -> 新增案例管理
URL： /interface/cases/all_cases
http://yuehouse.happysoft.cc/interface/cases/all_cases
參數： 無
請求方式：GET

例子：
/interface/cases/all_cases

返回結果：


{

    success: true,
    result: []
}
```


## 如何寫接口？

看前面的文檔。



## 文檔很重要。
把文檔寫出來（接口文檔是必須的，內容有： 名字，用途，例子，必要的說明）

## 寫接口的原則

1. 文檔務必有，這個文檔是給自己看的。
2. 所有的圖片，文件，務必用絕對路徑。 例如：

```json
{
  result: {

    # 這個是錯誤的。
    image: "/my_image/1.jpg"

    # 這個是正確的。
    image: "http://image.your_domain.com/my_image/1.jpg"
  }
}
```

3. 所有的http 請求，都要寫在一個配置文件中。例如：

我們的站點：  jiayou.com

接口：

我們有三個接口（後臺上）：  用戶列表，案例列表，監理列表。

-用戶列表：   /interface/users
-案例列表：   /interface/cases
-監理列表：   /interface/supervisors

那麼，我們在 app中，要怎麼寫呢？

1. 請求的時候，一般這麼寫：

```
SETTING = {
  host = 'http://jiayou.com'
}
xhr = Ti.Network.HTTPClient();
...

xhr.open('GET', SETTING.host + "/interface/users")
xhr.send()
```

也就是說，把能提取出來的配置項，都放到配置文件中。例如： 後端站點的域名。


## 接口的另一個原則： 只增不減。

08 年： 寫了 10個接口
09年： 寫了20個接口
。。。
15年： 再寫XX個接口。

那麼，08， 09年寫的老接口，不要刪。

1.0版本的接口，可能到了2.0 就沒用了。但是，老接口永遠不要刪。 因爲，你不知道還有多少人在用1.0的版本。

比如： 優酷。 13年的時候，客戶端到了3.0版本。但是，對於老版本（1.X的版本），只支持android 2.x的，

全國有3%的人在用。  600萬。

## 接口的第三個原則：儘量照顧後續的統計功能，和其他功能。

在訪問接口時，把機器的型號，android、ios，GUID，和其他的東東，都作爲參數，發送到服務器端。

機器型號： 可以獲得的（ phone, pad, tv)

系統版本： 4,0,  4.2  5.0 SDK,  IOS7/8

操作系統： android/ios

pid 渠道id.  （用戶獲取app的渠道，例如： 360，appstore, 應用寶）

 pid:     360:   001

          appstore:  002

          應用寶：  003

md5    : 爲了服務器的安全。   ( timestamp, token , )

詳細請看：

2015-01-03 接口的訪問基本機制：服務器端的認證 ( web interface basics: server side authentication)
2015-01-03 接口的訪問基本機制：User Agent (web interface basic: user-agent)
2015-01-03 接口的訪問基本機制：渠道id ( web interface basics: channel id)
2015-01-01 接口的訪問基本機制：安全控制-神祕的md5參數（ web interface basic: how to secure your web access? md5, guid, sign )
