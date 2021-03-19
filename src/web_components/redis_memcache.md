#Redis

Redis一個鍵值儲存系統，也就是我們說得NOSQL數據庫。

##優點
數據保存在硬盤上，讀取快；佔用更小的內存；當然還有和其他數據庫一樣的特性，像集羣，數據庫複製等。

##安裝
```shell
$ wGET http://download.redis.io/releases/redis-3.0.4.tar.gz
$ tar xzf redis-3.0.4.tar.gz
$ cd redis-3.0.4
$ make
```
##啓動服務
```shell
$ src/redis-server
```

##運行
```shell
$ src/redis-cli
redis> SET foo bar
OK
redis> GET foo
"bar"
```

##使用
###基本操作
`SET Key Value #設置鍵和值`

`SET floor 10`

`GET Key #獲得鍵的值`

`GET floor => 10`

`INCR Value #值自動加一`

`INCR floor => 11`

`DEL Value #刪除鍵`

`DEL floor`

`EXPIRE Key Seconds #設置鍵在多少秒後自動銷燬`

```
SET resource "Demo"
EXPIRE resource 120
```

`TTL Key #顯示鍵在多少秒後銷燬`

```
TTL resource => 120
TTL resource => -2 #-2代表鍵已銷燬
```

`TTL Key=> -1 # -1代表這個鍵沒有設置自動銷燬`

###List操作

```
RPUSH friends "Lily" #在list尾增加值
RPUSH friends "Lucy"
LPUSH friends "Alan" #在list首增加值

LRANGE friends 0 -1 => 1) "Alan", 2) "Lily", 3) "Lucy" #顯示所有值
LRANGE friends 0 1 => 1) "Alan", 2) "Lily"
LRANGE friends 1 2 => 1) "Lily", 2) "Lucy"

LLEN friends => 3 #顯示值個數
LPOP friends => "Alan" #移除第一個值
RPOP friends => "Lucy" #移除最後一個值
```
###Set操作
>於List的不同之處在於他沒有固定的順序和他的值可能只出現一次

```
SADD friends "Alan"
SADD friends "Lucy"
SADD friends "Lily"

SMEMBERS friends => 1) "Lily" 2) "Lucy"` 3) "Alan" #顯示所有的值

SREM friends "Alan" #在set中刪除這個值

SISMEMBER friends "Lucy" => 1 #1代表set中存在該值
SISMEMBER friends "Alan" => 0 #0代表set中不存在該值

SADD enemy "Jack"
SADD enemy "Zed"
SUNION friends enemy => 1) "Jack" 2) "Lucy" 3) "Lily" 4) "Zed"

SADD runner 1009 "Alan"
SADD runner 1000 "Jack"
SADD runner 1003 "Hoan"

ZRANGE runner 1 2 => 1) "Hoan" 2) "Alan" #在Redit1.2中增加了set得排序功能
```
###Hash操作
```
HSET user:1000 name "Jack"
HSET user:1000 address "Beijing chaoyang"

HMSET user:1000 name "Jack" address "Beijing chaoyang" #以上這兩種鍵值設置方法都可以

HGET user:1000 name => "Jack" #得到鍵的值
HGETALL user:1000 => 1) "name" 2) "Jack" 3) "address" 4) "Beijing chaoyang"

HSET user:1000 visits 100
HINCRBY user:1000 visits 1 => 101 #HASH值的增加
HINCRBY user:1000 visits 100 => 201
HDEL user:1000
```


#緩存服務器：MemCache

&emsp;&emsp; Memcache是一免費開源、性能高、具有分佈式對象的緩存系統。目前大都用於大負載網站的數據庫分壓。其工作機制是在內存中開闢一塊空間然後建立HashTable。
##工作原理

&emsp;&emsp; memcached(MemCache在服務器端的主程序文件名)以守護程序方式運行在一或多個服務器中，隨時接受來自客戶端的請求。

*注：MemCache爲項目名稱，memcached是MemCache在服務器端的主程序文件名。*

##操作流程

>1. 檢查客戶端的請求數據是否在memcached中，有數據則把請求數據返回並且不對數據庫進行操作；沒有則查找數據庫並且把從數據庫中獲取的數據返回給客戶端，同時將數據庫緩存一份到memcached中。
>2. 爲保證數據的一致性，更新數據庫的同時更行memcached中的數據。
>3. 如果分配給memcached的內存空間用完後，使用LRU（Least Recently Used,最近最少使用）策略加上到期失效策略，失效數據先被替換然後替換掉最近最少被使用的數據。

##MemCache的安裝和啓動
###Mac下安裝
>**Step1 Homebrew（系統軟件管理程序)安裝**
>
```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
也可以參考http://blog.zerosharp.com/installing-ruby-with-homebrew-and-rbenv-on-mac-os-x-mountain-lion/ 下載homebrew

>**Step2 安裝memcached**
>
```
$ brew search memcache
```
返回結果：
>
```
libmemcached    memcache-top    memcached   memcacheq
```
則安裝服務器端：
>
```
$ brew install memcached
```
>完成後查看安裝結果
>
```
>$ which memcached
>$ memcached -h
```
>**Step3 安裝libmemcached**
>安裝客戶端
>```
>$ brew install libmemcached
```
>**Step4 啓動服務器**

>默認參數啓動：
>
```
$ /usr/local/bin/memcached -d
```
>**Step5 測試**

>以守護程序的形式啓動 memcached（-d），爲其分配2GB內存（-m 2048），並指定監聽 localhost端口 11211
>```
$ ./memcached -d -m 2048 -l 10.0.0.40 -p 11211
```

>使用一個簡單的telnet客戶機連接到memcached服務器
>
```
>$ telnet localhost 11211
```
>成功則返回 Connected to localhost（已經連接到 localhost）。


##命令行介紹


### 六項存命令

>- Set：添加一個新條目到memcached或是用新的數據替換替換掉已存在的條目。
存入命令格式爲:

>```
><command> <key> <flags> <exptime> <bytes>
>
```
例如存入key爲yanmin的yanmin.in值：
>
```
$ set yanmin 0 0 9
$ yanmin.in
```

>- Add：當KEY不存在的情況下，它向memcached存數據，否則，返回NOT_STORED響應
>- Replace：當KEY存在的情況下，它纔會向memcached存數據，否則返回NOT_STORED響應
>- Cas:改變一個存在的KEY值 ，但它還帶了檢查的功能
>- Append:在這個值後面插入新值
>- Prepend:在這個值前面插入新值


###兩項取命令
>- Get:取單個值 ，從緩存中返回數據時，將在第一行得到KEY的名字，flag的值和返回的value長度，真正的數據在第二行，最後返回END，如KEY不存在，第一行就直接返回END 。
例如：

>```
>$ get yanmin
>```
>返回：

>```
>VALUE yanmin 0 9
yanmin.in
```
>- Get_multi：一次性取多個值

###一項刪除命令
>Delete


