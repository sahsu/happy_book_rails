#發送短信
開發中，我們經常需要和用戶校驗身份，或者實時的通知用戶一些重要的信息，短信是比較方便直接的方式。下面介紹怎樣給用戶發送短信。
這裏我們使用[陽洋傳媒](http://www.ipyy.net/)的短信服務爲例([華信科技](http://www.ipyy.com/)方法類似)。其提供的HTTP藉口的方式完成信息發送，我們只需將特定參數以`POST`請求的方式訪問給定的接口即可完成短信發送。

羣發短信：
```javascript
//titanium demo
var client = Ti.Network.createHTTPClient();
client.open("POST","http://ipyy.net/WS/BatchSend.aspx");
var parameters = {
  CorpID: "用戶ID",
  Pwd: "用戶密碼",
  Mobile: "接收號碼，多個用逗號隔開，最多600個",
  Content: "短信內容",
  Cell: "子號（可爲空）",
  SendTime: "定時發送時間(爲空標示立即發送)"
}
client.send(parameters);
client.onload = function(){
  do_when_onload;
}
```
其他業務參數格式[HTTP接口](http://www.ipyy.net/http.asp)

其他短信平臺使用方法類似。
