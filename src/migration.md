# Model基礎1: 數據庫遷移

## 軍規

migration 一旦建立好,就不要修改! 不要刪除!

每一次對數據庫的修改，都對應一個新的migration文件。

## 起源

數據庫遷移是一個很高級的概念。

在Web程序開發的上古時代（也就是15年以前...）我們修改DB的時候，原始的辦法是：

1. 把建表的SQL語句放到cvs/svn中.
2. 小李如果修改了表結構, 那麼就提交一個commit, 更新SQL語句
3. 小王每次更新代碼後, 都要重新把SQL文件導入到數據庫中.

但是這樣做有不小的缺點：

1. 測試數據很寶貴，很多測試數據是非常複雜的，例如：有5個表，每個表之間都有互相的依賴關係。
那麼，一旦小王把數據庫的表結構變化，小李重新導入sql文件後，小李本地原來的測試數據都沒有了。
重新構建測試數據又要半天.
2. 大家不知道什麼時候SQL發生了改變.

所以，我們要找到一種辦法來解決上面遇到的問題. 讓它:

- 可以自動化的執行.
- 不必對現有的測試代碼造成影響. (只修改應該修改的地方)
- 可以對數據庫進行高級的操作: 例如回滾到某個時間點.

這個辦法, 就是 Database Migration.

下面是數據庫遷移的一個例子: 在某個商業項目中, 從2016年2月,到 2016年9月, 數據庫的結構發生了177次變化.

![例子](images/真實項目中的migrations.gif)

每個文件名都由兩部分組成:  時間戳 + 事件.

```
20150529080834_create_download_counts.rb
20150529092141_create_positions.rb
20150601090602_add_name_to_price_strategies.rb
```

所以，當團隊中，任意一個新手，加入的話，不需要你提供給他任何sql文件。讓他直接運行 `$ rake db:migrate `就可以了。

我也可以使用 `rake db:rollback` 回退到任意時刻。

所以，可以認爲，migration 是衡量一個項目的水平的重要指標。 如果一個項目，沒有migration的話, 這個項目就特別難於開發. 原因在於：

- 數據庫結構難以獲取
- 開發成員之間的表結構難以統一。

所以, 數據庫遷移是極其重要的.


## Migration初體驗

在Rails中, 所有的migration, 都是用命令 `$ rails generate migration`創建出來的.它位於 `db/migrate`目錄下.

### 開始Migration

下面是一個最簡單的migration 的例子:

`$ bundle exec rails g migration create_books name:string`

```
invoke  active_record
create    db/migrate/20210129061951_create_books.rb
```

會發現在`db/migrate`目錄下新建了一個文件：`20210129061951_create_books.rb`, 內容如下：

```
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
    end
  end
end
```

爲了更好的便於大家的理解，我們把它的內容修改一下，修改後的內容如下：
```
class CreateBooks < ActiveRecord::Migration

  # 新建表 books
  def up
    create_table :books do |t|
      # 創建了一個列name, 類型是varchar
      t.string :name
    end
  end

  # 刪除表 books
  def down
    drop_table :books
  end
end
```

上面代碼，代表了一個migration. 叫做: `CreateBooks`.

每個migration, 都有2個方法.  `up`和`down`. (在Rails4以後，這兩個方法進化成了`change`這一個方法)

- up ：  就是從過去，往未來的時間方向上發展
- down:  在時間上倒退。

(因爲它可以移過來，再移回去。 在不斷的up/down中,數據庫實現了遷移. 這就是這個名字的由來.)

對於新手, 建議使用 `up/down` 方法, 這樣可以更好的理解和掌握。

### 運行migration

接下來, 運行

`$ bundle exec rake db:migrate`

結果如下：
```
== 20210129061951 CreateBooks: migrating ======================================
-- create_table(:books)
   -> 0.0267s
== 20210129061951 CreateBooks: migrated (0.0268s) =============================
```

我們打開這個數據庫，發現數據庫中，新增了一個表 `books`.

```
mysql> show tables;
+-----------------------+
| Tables_in_study_rails |
+-----------------------+
| books                 |
| schema_migrations     |
+-----------------------+
2 rows in set (0.00 sec)
```

可以查看該表的結構：

```
mysql> show create table books;
+-------+-------------------------------
| Table | Create Table                                                                                                                                                 |
+-------+-------------------------------
| books | CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------+-------------------------------
1 row in set (0.00 sec)
```

### 回滾

回滾，就是通過一條命令，`rake db:rollback` 來執行對應的migration中的`down`方法。

`$ bundle exec rake db:rollback`

結果如下：
```
== 20210129061951 CreateBooks: reverting ======================================
-- drop_table(:books)
   -> 0.0135s
== 20210129061951 CreateBooks: reverted (0.0181s) =============================
```

可以看到，books table已經被刪掉了

```
mysql> show tables;
+-----------------------+
| Tables_in_study_rails |
+-----------------------+
| schema_migrations     |
+-----------------------+
1 row in set (0.00 sec)
```

## schema_migrations: 記錄遷移過程的表

可能有的同學會比較奇怪： `schema_migrations`, 這個是幹嘛的呢？

這個表專門記錄當前數據庫的 "遷移ID" 是多少。 Rails就是通過比較它和 `db/migrate` 中文件的差異來判斷，
當前的rails，的數據庫，是否是最新的。

例如, 運行 `CreateBooks` 這個migration之前：

```
sqlite> select * from schema_migrations;
20201023070737
```

運行完之後：

```
sqlite> select * from schema_migrations;
20201023070737
20210129125025
```

多出來的一行：  `20210129125025` , 剛好就是我們新建的migration : `20210129125025_create_books`名字的一部分。

## 如何修改一個列？

錯誤的做法：

1. 運行回滾操作: `rake db:rollback`
2. 修改migration文件的內容。 在其中增加 `change_column`方法. (具體代碼略)
3. `$ rake db:migrate`

絕對錯誤！記住： 一旦創建好migration文件（特別是已經提交到了遠程的話），就絕對不要去修改它！

因爲一rollback的話，遷移的時間線就立馬亂了。

正確的做法是：

1. 新建個migration. (在這個migration中，使用 `change_column` 方法，來修改）
2. 運行它

### 常見的migration方法

注: 以下方法都寫在`up`, `down` 或者`change`方法中.

#### create_table

例如, 創建表 'students' :

```
create_table :students do |t|
  t.string :chinese_name
  t.integer :age
  t.timestamps
end

```

上面的 `t.timestamps`, 會創建兩個列： `created_at`, `updated_at`.

  - created_at:  表示 該條記錄，在什麼時間被創建的。
  - updated_at:  表示 該條記錄，在什麼時間被修改的。


等同於：
```
  t.datetime :created_at
  t.datetime :updated_at
```

rails中幾乎每個表，都默認有這兩個列。

#### drop_table

例如,刪掉表'students' :

```
drop_table :students
```

#### add_column

例如, 向'students' 表中,增加一個列'name', 它的類型是字符串:

```
add_column :students, :name, :string
```

#### remove_column

例如, 從'students' 表中,刪除列'name':

```
remove_column :students, :name
```

#### rename_column

例如, 把'students' 表的'chinese_name'列, 重命名爲 'zhong_wen_ming_zi':

```
rename_column :students, :chinese_name, :zhong_wen_ming_zi
```

#### add_index

例如, 把'students'表的name列建立索引:


```
add_index :students, :name
```

#### remove_index

例如, 把'students'表的已經存在的name索引刪掉:

```
remove_index :students, :name
```

### 幾個注意：

- 所有的model ， 都是單數。
- 所有的controller, 都是複數（原則上）
- 所有的table， 都是複數。（例如： egg => eggs, person => people, wife -> wives)

如果弄錯了，rails的代碼在默認配置下就會出錯。

## 不學的內容

不要這樣寫, 容易亂：

```
  def change
    create_table :appointments do |t|
      t.belongs_to :physician
      t.belongs_to :patient
      t.datetime :appointment_date
      t.timestamps
    end
  end
```

可以這樣寫(就把外鍵當成最普通的列就行了)：

```
class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :physician_id
      t.integer :patient_id
      t.datetime :appointment_date
      t.timestamps
    end
  end
end
```

## 不需要重點學習seeds.

seeds:  rake db:seeds  , 能夠加載 數據庫中的種子數據(測試數據)

實際項目當中: 沒有人用.

1. 我們往往: 有幾十個表. 每天,每個表,都有可能,頻繁的變化.
程序員的精力有限, 到家就累的想睡覺. 沒有人關心, db/seeds.rb
這個文件,是否跟真實的數據庫結構同步.

2. 實際項目中,往往模塊非常獨立.  小王做的模塊, 往往跟小李,一點兒
關係都沒有. 所以不會出現: 小李更新代碼後, 要用到小王模塊的數據.


## Rollback

實戰經驗:

在實戰中, 我們99%的情況, 都不需要rollback. 我們如果要修改表結構, 要rake db:migrate.

啥時候才rollback呢? 部署失敗了. 臨時的回滾一小會兒.

我們也可以隨時回滾到任意時刻的 數據庫的版本, 但是不實用.  爲什麼呢?

1. 一回滾, 歷史數據全沒.
2. 我們往往不知道, 部署的代碼,跟原來的數據庫的版本的對應關係.
道理上講, 我們某個版本的代碼,讓它對應着該版本中,最新的數據庫遷移就好了.
但是, 我們實踐中發現, 難以對應好這個"代碼的版本"和 "數據庫的版本" 不好找.
而且,測試數據不好弄.  而且 回滾的時候, 容易丟失東西.
3. 與其在回滾上消耗實踐, 我們實戰的經驗,往往是: 在部署前, 手動備份一下數據庫.
如果沒問題,很好.如果有問題,就:
  3.1 回滾代碼.
  3.2 恢復"剛剛手動備份的數據庫"  效果遠遠好於 "rollback"得到的數據庫.


## 作業

1. 在本地安裝好 mysql 服務器端, mysql客戶端(gui)
2. 創建rails項目.
3. 在rails項目中, 配置好於mysql的連接. 數據庫的名字爲: demo
4. 使用 rake db:create 命令來創建數據庫.
5. 建立一個migration, 新建一個表: books, 有兩個列: author(string), title(string)
另外, 有時間戳列(created_at, updated_at)(提示:使用 t.timestamps 來創建)
6. 建立migration, 修改這個表的列, 把author 的名字,改成 zuo_zhe .
7. 建立migration, 刪掉這個表的列:title,  再新建一個列: name.(string)
8. 建立migration, 刪掉這個books 表.
9. rollback 兩步.
10. 再 rake db:migrate 回來.
