# 調試接口的工具

我們每天寫接口， 需要兩個調試用的東西：

1. 發送各種請求
2. 展示各種請求

僅僅使用chrome是不夠的。 因爲：瀏覽器的地址欄，只能發送GET請求。
JSON內容在瀏覽器中，也不會自動的格式化。 看起來亂糟糟的。

所以，我們要使用對應的工具，來提高效率。

## POSTMan

他是google chrome的插件。 使用它，可以發送任意類型（GET/POST/PUT/DELETE)的請求。還可以設置任意的
header, 總之，功能非常強大。

步驟：

1. 你要有個翻牆工具。 （否則進不了chrome store)
2. google postman （我搜到的地址是 https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop )
3. 打開。
4. 點擊右上角的 "add to chrome "按鈕。並且確認。
5. 安裝好了之後， 就可以看到： chrome的 應用程序列表（  chrome://apps/ ） 中，就可以看到了對應的圖標：
6. 點擊圖標，運行：
7. 點擊“ skip this, go stranght to the app"

## 使用方式：

1. 地址欄輸入 url, 選擇好請求的類型（GET  ， POST） ，點擊“SEND”
2. 就可以看到內容了。


## 發起POST請求

1. 選擇請求的類型爲POST， 輸入URL ，
在body中， 選擇 "form-data", 填好 key, value. 例如： name  李磊

## JSON View (格式化JSON的內容）

JSON 文件，默認是亂亂的， 沒有任何縮進。(連換行都沒有）  例如：

```
{"civil_cities":[{"initial":"熱門城市","cities":[{"id":1018,"name":"北京","code":1},{"id":1153,"name":"上海","code":2},{"id":1058,"name":"廣州","code":32},{"id":1154,"name":"深圳","code":30}]},{"initial":"A","cities":[{"id":191,"name":"阿壩","code":1838},{"id":192,"name":"阿克蘇","code":173},{"id":193,"name":"阿勒泰","code":175},{"id":194,"name":"阿里","code":97},{"id":195,"name":"安康","code":171},{"id":196,"name":"安慶","code":177},{"id":197,"name":"鞍山","code":178},{"id":198,"name":"安順","code":179},{"id":199,"name":"安陽","code":181}]},{"initial":"B","cities":[{"id":201,"name":"白城","code":1116},{"id":202,"name":"百色","code":1140},{"id":203,"name":"白沙","code":21025},{"id":204,"name":"白山","code":3886},{"id":205,"name":"白銀","code":1541},{"id":206,"name":"保定","code":185},{"id":207,"name":"寶雞","code":112},{"id":208,"name":"保山","code":197},{"id":209,"name":"包頭","code":141},{"id":210,"name":"巴彥淖爾","code":3887},{"id":211,"name":"巴中","code":3966},{"id":212,"name":"北海","code":189},{"id":213,"name":"北京","code":1},{"id":214,"name":"蚌埠","code":182},{"id":215,"name":"本溪","code":1155},{"id":216,"name":"畢節","code":22031},{"id":217,"name":"濱州","code":1820},{"id":218,"name":"亳州","code":1078}]},{"initial":"C","cities":[{"id":219,"name":"昌江","code":
```

所以，當一個文件一大，是無法肉眼識別的。

所以，我們要使用工具。 例如： json view.

### 安裝

1. google:  json view
2. 會得到一個地址： https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=ko
3. 點擊 'Add to Chome' 並且確定。
4. 安裝好之後， 刷新即可。

### 如果 沒有翻牆工具怎麼辦？

那就使用 在線格式化工具。 例如： json.cn 一看就會用，不說了。

但是，不如json view的chrome 插件管用。
