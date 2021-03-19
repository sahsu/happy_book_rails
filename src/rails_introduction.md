# Web開發框架爲什麼選擇Rails

世界上的編程語言有很多: java, javascript, php, python, ruby... 學習了之後我們發現，只能寫個算法。此外不能做任何事兒:

- 在網頁上顯示個表單
- 處理一個request請求
- 處理數據庫
- 無法在桌面上，顯示一個對話框。

想做的話，需要做大量的底層工作。（把一個請求，轉換成XX類，再借助YY類力量，使用W方法）

所以，我們做任何事情，都需要使用框架。(Framework)

常見的框架有：

- java:  Spring, Struts, Hiberate ...
- PHP:  phpcake, ThinkPHP, ...
- Ruby: Rails, Sinatra
- Python: Django, Tornado
- javascript: Vuejs,Angular, React ..

有了框架，我們做起事情來，纔會特別簡單，得心應手。

在已知的web開發框架中, Rails完勝其他框架。什麼叫完勝呢？

1. 開發速度第一: 其他框架一個月，Rails 1～2周。
2. rails把其他的框架的優點,都整合到了一起.
rails = spring + struts + hibernate  + django

學會了rails , 看其他框架,都是換湯不換藥. 比如: 上手vuejs就特別快.

另外，現在大火的spring boot等，也都能看到rails的影子

## 開發語言和框架非常重要

例如，PHP開發不是web開發的首選：

1. PHP代碼很羅嗦, 跟java一樣羅嗦。導致了項目一大，php的代碼量跟java 是一樣的。
2. 在項目初期，php的代碼的開發速度比java快，但是，只要在java項目中，不使用java bean, 那麼JSP跟PHP是一樣的。
可以認爲java的開發速度比php 慢的原因是java在開發時要遵循的條條框框太多了。
3. 維護上：php的代碼跟java幾乎一樣，導致了php 的代碼比ruby 代碼多的多（可以認爲是4，5倍）代碼越多， 維護起來就越困難。

當我們面對幾根頭髮的時候，可以很容易的理順。 (Ruby > python)
當我們面對一個線團的時候，就沒法弄了。  （PHP ,java）

Ruby的代碼量大約是 Python的 80%。
Ruby的代碼量大約是 java的 25%, 或者更少。

所以，我們維護php/java代碼的時候會發現，我們需要在各種文件(class)中 跳來跳去。眼花繚亂。

PHP之所以在國內流行，還是因爲國人英語差了些。外面教的人很多。

## 數據庫遷移

什麼是數據庫遷移？對數據庫的表結構的 修改的管理，或者說，是對數據庫的版本控制。

### 數據庫遷移的起源

我們知道，管理代碼版本，是使用SCM(git, svn)

管理數據庫的表結構，則是使用 database migration

git ： 可以取出任意時刻的代碼
migration: 可以取出任意時刻的你的數據庫的表結構。

所以，它的出現，是爲了解決下面的實際問題：兩個程序員之間的對於數據庫的修改衝突。

小王和小李是兩個程序員，一起在做一個項目。

小王，昨天，新增了兩個表，改動一個表（刪除了一個列，又增加了2個列）

小李，今天早上9點，更新代碼，然後運行, 崩潰了。

小李怎麼辦？

選擇1. 在菜鳥項目組。小李問小王： 我崩了。 小王回答：笨蛋。我把我的數據庫導出一份給你。小李說，好的，你等着。

第二天，小王更新代碼，崩潰了。找小李. 小李說：笨蛋，我把我的數據庫導出一份給你。

所以，這個項目組，以後，誰改動數據庫，都得吼一聲。

選擇2. 在好一點兒的項目組：每次數據庫結構有了更新，都要導出一個 表的結構的文件, 放到SCM（GIT/SVN）中。其他人
更新代碼後，都要把這個表結構文件導入到數據庫。

表的結構問題暫時解決了。但是，更大的問題來了：原來的測試數據都沒了。

所以，我們的database migration就是爲了解決這個問題的。

方式：

把對數據庫的操作，變成：

1. 不是通過SQL語句來人肉修改。 而是通過代碼來修改。（把對數據庫的操作，放到專門的代碼文件中，例如  `db/migration/*.rb`, `*.java`)
2. 一個migration, 佔用一個文件。

### 例子

例如，我們希望創建一個表 apples, 包含2個列：name, color, 都是字符串類型類型(varchar(255))

1.新建一個文件：    `db/migration/001-create-apples.rb`

```
class CreateApples
  # 每次migrate都會自動執行 up 方法
  def self.up

    create_table 'apples' do  |t|
      add_column 'name', String
      add_column 'color', String
    end
  end

  # 每次回滾，都會自動執行 down方法
  def self.down
    drop_table 'apples'
  end
end
```

說明：

    1.任何一個migration, 都要有 up, down, 這樣的話，它才能遷移。（前進的時候調用up, rollback 的時候，調用down)

    2.up 和 down, 永遠是對立的操作。

2.運行migration

```
$ rake db:migrate
```

這樣就會生成SQL，並且執行。

- `self.up`  會生成 `create table 'apples' .....`
- `slef.down`   會生成   `drop table 'apples' ..`

有了這個形式，小王和小李就可以開心的一起協作了。

每次小王，都把對數據庫的改動寫進migration中，小李更新完代碼後，直接執行 rake db:migrate 就可以了。原來的數據還能保留。

如果在部署的時候發現新的數據庫結構不合理，還能rollback回去。
