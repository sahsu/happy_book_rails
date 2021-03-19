# 本書緣起

我在2014年出來創業, 之後一直招不到Rails的成手,只好自己培養。但是Rails的官方教程入門不好入，特別是guides第一章，
不好入門。於是我便按照日常給大家授課的大綱重新安排，細化，便慢慢的形成了教材。

市面上的rails入門書特別厚, 像塊磚頭一樣，其實都不適合做入門。

我在rails 2.x 的年代把rails guide打印出來過. 400多頁A4紙. 讓新手望而卻步.

# 學習原則：入門應該簡單

1. 首先確定一些內容是不學的.(見本文內容)

2. 剩下的內容, 是要有學習過程的.

這裏我要吐槽rails的官方文檔( https://guides.rubyonrails.org ). 它的第一章 rails tutorial 完全不是入門, 而是一種 "技能的炫耀".

這個教程, 我讓30個小白紙(都是應屆畢業生) 來學, 學習2周, 沒有一個能看懂. 就是因爲它是rails的特性的炫耀,
上來就給出一堆花裏胡哨的概念和技巧, 充滿了各種縮寫, 各種概念和各種晦澀的東西.

當年我做了3年半的java web開發, 買了兩本書(ruby 鋤頭書 和 rails滑板書), 結果還是無法快速入門rails.

後來創業後, 我招不到人, 就只能自己培養, 於是發現對於新手, 教學的時候務必要一點一點的教,
前面一個概念弄明白了, 我再講後面的概念. 絕對不能把 router, controller, 表單對象和model的東西放在一堂課中講.

# 正確的學習路徑

對於小白紙, 正確的入門路徑如下:

## 1.學習好 HTML + css

這個很重要. 學習好了html的標籤,就知道後面的 form_for, select_tag, link_to 都是什麼了.

HTML可以讓小白紙對於web開發有個基本認識。 CSS則是目前的web開發程序員必備. 這些都是基礎中的基礎。

一般用1周的時間去學習。學習完畢後，需要可以根據靜態圖和輔助工具（例如查看ps原圖的標記）來還原一個靜態HTML頁面

## （可選）學習好git, vim的使用。

git 是程序員必會。具體教程我做了2個視頻, 網上也有很多。

Git視頻教程： http://edu.51cto.com/course/course_id-8363.html

vim文字教程： https://github.com/sg552/my_vim

## 2.學習好ruby語言.

只學習最常見的20%功能即可. 能知道最最基本的語法, symbol是什麼, 常見的簡寫方式,
理解block的概念, 知道"@"變量 就可以了.

視頻教程在這裏：http://www.imooc.com/learn/765

## 3.學習好數據庫.

只需要學習下面內容即可。

- select, insert, update, delete 這些基本語句
- where 查詢語句
- join 語句, 知道什麼是關聯和外鍵即可.

## 4.rails第一課

- 如何安裝rails,
- 知道bundler是什麼, gem是什麼
- 寫個hello world並顯示出來. (務必不要學習增刪改查)

## 5.rails第二課. router（路由）

只學習最常用的restful路由即可.

這裏是rails 最最複雜的三大概念之一. 路由的作用跟脊柱一樣, 把M-V-C 這三大塊都串聯了一起. 所以務必單獨拿出來學習.

而新手往往苦於對路由不熟悉, 結果後面的controller, form object都沒辦法學.

## 6.rails第三課  view（視圖）

視圖相對來說簡單, 需要學習的前提知識是 router 和 html. 所以放在router之後講. 側重於學習它的展現方面的知識.

(在其他語言中, PHP,JSP 有視圖的知識就可以入門了,所以國內學PHP的人總認爲它好學)

## 7.rails第四課 命令行, database migration 和 model 層.

7.1 先講 rails的命令行, 因爲只有在命令行下面才能使用 migration

7.2 再講數據庫額的配置和遷移. migration 是rails的自帶王牌. 學習的前提知識是 數據庫的知識.
要熟悉對數據庫的基本操作和關聯關係. 所以放在這裏. 我們這一課只講 migration.

7.3 再講model.  務必記得model不要跟 form object 和 controller 一起學習, 新手一定會蒙圈.
所有model的操作(增刪改查)都要放在 rails console中講解. 這樣才能不跟view, controller混在一起
切記切記.

這些內容關聯的特別緊密.

## 8.rails第五課. Controller 和 form object.

到現在,我們終於可以學習controller 的知識了. 有了前面router, view的鋪墊, 同學們對於controller
上手就會特別容易.

重點是 form object, 這裏是rails三大難之二. 沒有表單對象這個web實現模式的同學, 都是難以理解
rails中的各種`form_for`, `form_tag`, `form_helpers`的.  所以,這裏我們要向大家展開一扇新的大門.
學會了form object, 那麼 java 世界的第一個框架 struts 就基本學到手了.

然後是 form helpers. 它是把 `<input>`, `<select>` 等表單標籤使用rails的形式來表示的組件. 這裏的
前提知識是 html form 標籤. 知道了這些, 就知道如何使用了.

最後,就是如何在controller中讀取request中傳遞過來的參數(往往是 form object的形式).

(其實學習到了這裏, rails 的最常見的知識就學習完了. 小白紙們可以幹活兒了)

## 9.rails第六課. layout, asset pipeline 與 部署.

layout: 佈局. 它的學習前提知識是 : view, controller. 所以在這裏學習. layout也是一種關鍵的實現模式: 簡單,有效.

asset pipeline , 是rails三大難之三. 哪怕是老手, 我都遇到過完全搞不定這個東東的朋友.

我覺得它的難點在於:

- 前提知識: layout, view helper 和 tcp協議的優化知識.
- 部署時會遇到 linux 的權限知識
- 調試時會遇到 nginx 的調試知識

所以, 只要用到的知識點一多, 這個環節就不好學.

最後,是 rails的部署. 這裏不難.幾個命令搞定. 或者按照給定的nginx配置去做就可以了.

## 10.rails 第七課. 常用的組件

這些都是我統計了自己所有的web項目後,總結出來的跟 web後端相關的組件.

都是輪子,我們按照官方網站的介紹拿過來用就可以.

10.1 分頁(Kaminari)，上傳圖片(carrier wave)，上傳到upyun，發送短信， 所見即所得編輯器(WYSIWYG editor)，

10.2 發送http 請求（httparty）, 日誌工具(log4r)， 全局配置工具(rails-config), HTML 分析工具（nokogiri）, migration註釋，

10.3 bootstrap-rails, 執行定時任務（rufu-scheduler）, 執行後臺任務(god),  執行延時任務（delayed_job）, 使用capistrano 進行自動化部署。

基本上, 學習了這些, 就是一個合格的rails小鮮肉了~

# 開始學習

要記住：光看不練，絕對學不會！

老老實實的拿出鍵盤，看一段敲一段 就能記住！ 只看不練，學不會記不住！
