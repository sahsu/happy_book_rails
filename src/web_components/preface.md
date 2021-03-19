# 引言

要有自我學習能力！

我們作項目，90%的時候，都要用別人的輪子。 不要自己作。

舉個例子：

輪播圖。

在10年前， 沒有人手寫輪播圖。  都是拿來主義。 現在，有了jQuery, 寫輪播圖，也是個麻煩事兒。
所以，我們要： 會用別人的輪子。

## 怎麼發現輪子？

對於技術層面的輪子，不要baidu。 一定要英文google。 因爲：國外的輪子是最圓的。

舉個例子：
  國內有個日曆控件。  m91 ? 很奇怪的名字。 國外： jquery-ui : datepicker.
後者在質量上還是在UI上， 都碾壓前者。

關鍵： 要知道 輪子的英文名稱。

輪播圖。 slider
日曆     心裏認爲： calender,   事實上叫： date picker
提示框。 （背景變黑， 中間出現個彈窗）國內目前沒有統一的叫法。 國外： modal dialog.
標籤頁： tabs
標籤： tag
分頁： pagination

我們要知道 一系列的名字，才能google 。

## 從標準內容看項目

補充：  每個插件，必然有自己的官方網站。  例如：  jquery-validate
很有可能有個自己的獨立的網站：  https://jqueryvalidation.org/
除了官方網站， 還會有自己的github ( 源代碼位置） https://github.com/jzaefferer/jquery-validation
而且：還要有文檔。 文檔分成兩種:
1. 入門文檔（ guides, tutorial, document ) ,例如： https://jqueryvalidation.org/documentation/
2. API 文檔（ https://jqueryvalidation.org/documentation/#link-api-documentation)

還要有個DEMO：
https://jqueryvalidation.org/files/demo/

對於Rails和很多其他組件來說， 文檔 跟 API 是分開的。例如：

http://guides.rubyonrails.org/
http://api.rubyonrails.org/

### 如果不知道官方的名字，如何找到它的官方網址呢？

例如，我們在文檔中，看到 一段代碼：

<script type="text/javascript" src="js/jquery.banner.js"></script>

我們搜索  'jquery banner js' 是搜不到結果的。

繼續找線索，可以發現，下面有一段對於該組建的調用：

```
    $(".banner").swBanner();
```

所以， `swBanner` 就是我們要搜的內容。    "jQuery swBanner"
然後，就可以在google中，看到： http://www.jstxdm.com/show-16-547.html

居然是國內的網站。

我們不知道這個東西是哪裏做的。因爲它： 1. 沒有表示自己是該組件的官網。 2. 沒有github.
3. 沒有詳細的文檔。 4. 還沒有API。 我認爲它就是個轉載。

但是需要確認。

1. 找到demo.  (http://www.jstxdm.com/demo.php?url=http://d.jstxdm.com/upfiles/demo/2016/0307/1457351735/index.html )
2. 看該demo 的源代碼。
3. 發現源代碼如圖

				jQuery(".focusBox").slide({ titCell:".num li", mainCell:".pic",effect:"fold", autoPlay:true,trigger:"click",startFun:function(i){
					jQuery(".focusBox .txt li").eq(i).animate({"bottom":0}).siblings().animate({"bottom":-36});}
				});

4. 經過我們的搜索，發現，該源代碼位於： http://www.jstxdm.com/statics/jqdemo2/js/w3cer.js

源代碼裏面定義的不是 swBanner, 而是 slider

也可以從側面看出，國內的項目，不規範， 連github都沒有。 大夥不知道應該往哪裏貢獻代碼， 那麼，
這個項目，是沒有生命力的。

再看jquery:

```
/*! jQuery v@1.8.0 jquery.com | jquery.org/license */
(function(a,b){function G(a){var b=F[a]={};return p.each(a.split(s),function(a,c){b[c]=!0}
```

代碼的第一行，就能看到：  項目名稱 版本號， 官方， 版權聲明（LICENSE) 。

jquery 文檔： http://contribute.jquery.org/documentation/
api: http://api.jquery.com/

## 如何使用輪子

1. 找到官方站點。
2. 查看官方文檔和例子
3. 照着做就可以了。


舉個例子：  我們希望某個web頁面， 裏面有很多圖片， 在最初加載的時候， 使用一個默認圖片來代替它。
（你們看看 今日頭條， 就知道這個感覺了）

google:  web images load jquery
（爲什麼要用jquery呢？ 因爲我們用的js框架就是jquery)
我會發現很多頁面， 出現了一個關鍵字： lazy . 所以，我們就可以把這個關鍵字，記錄下來，再次搜索：

web images lazy load jquery

然後，結果能更加精準一些。

我們找到了： https://responsivedesign.is/resources/javascript-jquery/lazy-load-jquery
（全都是英文）

看了3分鐘， 找到了兩個關鍵點：

1. demo地址： http://www.appelsiini.net/projects/lazyload/enabled.html
2. github地址： https://github.com/tuupola/jquery_lazyload

github地址找到了，就可以認爲它的官方地址找到了。

如何安裝，如何使用，就都知道了。


