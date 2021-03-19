# 關於密碼校驗

## 密碼的產生過程。

明文 -> md5(明文）  ->  'a1b2c3d4 .... z20' -> 保存到數據庫。

永遠不要把明文密碼保存在數據庫中。永遠要使用md5加密的方式。

在rails/ java 等 框架中，正確的做法是： md5加密是框架自動做的。

例如：

```
user = User.create  :name => 'Jim',  :password => '123456'
```

然後我們登錄到MYSQL 查看password 這個列的時候，會發現，已經被自動加密過了。

## WEB 端， 也不是每次都需要校驗密碼。

靠的是： session.

session: 會話。保存在服務器端的狀態數據。
可以認爲，服務器跟客戶端保持的一種持續的狀態。（例如： 30分鐘內不需要登錄）

例如： 對於某個論壇，如果當前有3個人在線，服務器端，對就會專門記錄這三個客戶端的session_id:

```
sessions:
  1#:
    session_id: a1b2c3d4...
    is_logged_in: true

  2#: e1f2g3...
    is_logged_in: nil
  3#: e1f2g4....

```

總之，每個session 都不一樣。
從上面的代碼中，如果對於同樣的一段erb代碼（服務器端）:

```ruby
<%=  session[:is_logged_in] %>
```

在1# 客戶端上， 就會顯示：  true

在2#， 3#客戶端上，就會顯示：    （空）

cookie:

保存在客戶端的變量。

## Devise 中的密碼體系

例如，我們有個 User 表，它由devise 進行控制。那麼，默認這個表(User)有若干列：

1. email
2. encrypted_password

然後，user 還有個屬性（attribute) :   password

所以，每當我們新建一個model的時候， ：

User.create :email => 'someone@fake.com', :password => '88888888'

於是，新的user 記錄就會自動生成，並且，數據庫中它的encrypted_password 會根據 '88888888'來
自動生成。

3. 根據上面生成的記錄， devise 還能自動的根據encrypted_password, 得到真正的password.

```
user = User.last # 獲取到剛纔新建的用戶
user.password  # => 88888888
```

所以，在devise所作用的user表中，是沒有password這個列存在的,它是一個獨立的屬性, 可以
供我們訪問。

## 移動端，不是每次都需要密碼。
大家可以認爲：在移動端，沒有session這個概念。

## 如何在移動端，判斷當前用戶是否正確登錄？

1. 身份的驗證。  客戶端： 發送 用戶名 + 密碼， 服務器端認證。
2. 每次由 客戶端，向 服務器端，發送請求的時候，要附帶一段 “密碼字符串”，它的作用等同於密碼。

例如：
1. 身份驗證後：

app ：  /interface/login?name=xiaowang&password=123456

服務器端： 對該request處理。 正確的話，返回：

```
{
  result: 'success',
  token: 'abc'
}
```

2. 接下來，app端，就把該token保存在本地數據庫，然後，每次發送請求到服務器時，
都附帶上這個token:

app:

```
GET  /interface/create_case?token=abc
GET  /interface/delete_case?id=3&token=abc
```


這樣的話，我們在服務器端，每次都可以針對一個request做驗證：

```ruby
class Interface < ActionController::Base

  def create_case
    if params[:token].blank? || params[:token].is_invalid?
      render :json => {
        message: '您沒有登錄'
      }
    end
    Case.create ....
    render :json => {
      result: 'success',
      ...
    }
  end

end
```

在實際的操作當中，如果嚴格一些的話，每次發起的請求，不僅有token ,還應該有
md5的值，有當前的時間戳。有pid ... guid ...

## 如果根據 token找到對應的用戶呢？

User表：

```
id  | name  |   encrypted_password  | token
1   | jim   |   a1b2c3...           | abc
2   | Lilei |   c3d4e5...           | efg
```

token是可以變的。我們可以讓它具有一定的時效性：

改良後的：User表：

```
id  | name  |   encrypted_password  | token | expires_at
1   | jim   |   a1b2c3...           | abc   | 2015-10-30
2   | Lilei |   c3d4e5...           | efg   | 2015-11-5
```

那麼，這樣的話，我們就可以根據某個user記錄的expires_at 來判斷，該用戶的token是否有效。

然後，在每次登錄的時候，更新 token 和 expires_at .


## 所以app的發起request，要有一個實現模式

1. 要有一個統一的方法來發起get/post 請求


```
// 就是確保每次發起請求的時候，都要給到服務器端：  token,pid, guid....
function send_request(url){

  final_url =  url + "&token=" + get_token() + "&pid=" + get_pid() ...
  // 把這個final_url 發送出去
}
```
