# 單元測試介紹。

歷史： 最早的測試框架，是 Junit. 作者 Kent Beck.  是敏捷開發大師，他是那種，寫了幾十年代碼的人。

最早的Junit幫了大家的大忙。 解救人於水火。導致了Junit 出現之後， Nunit( Net) , CUnit( C/c++) ， jsUnit,
以及現在的ruby的 test unit. 都紛紛出現。

概念： unit test.  測試最小的代碼粒度。

100

10 x 1000 = 10000

## 單元測試產生的緣由

如何保證項目是正常的？

大家的很常見共識：  在鋼絲繩上跳舞。

做了某個修改之後，如何保證你的修改，沒有破壞其他功能正常的函數？

1. 人肉測試 —— 把所有的功能都測試一下嗎 ?
   第一次，可以。 90%
   第二 。  開始煩了。  測試 60%
   第三 ？
   第四？

出現了一個問題，或者一個想法： 讓之前的人肉測試過程，可以自動重播（re-play)

催生出了一個理論：

人肉測試的步驟，最好是可以被 代碼記錄下來的。這樣才能方便重現。

例如： 一個方法：

```ruby
def sum a, b
  return a + b
end
```


如何測試這個方法呢？

```
irb,
> sum 1, 2
# => 3
```

上面是人肉測試過程。   這個步驟裏面，我們可以提取出，用代碼重現的步驟。

```
sum 1,2
（肉眼對比， sum 1,2 給出的結果， 是否是3 )
```

那麼，我們就希望有一種  框架(framework) ,或者一種工具，能夠幫我們把上述的過程給重新運行。

從上面的過程可以看出, 自動化的測試，需要兩個重要過程：

1. 記錄代碼。      =>  我們人肉肯定是要做的。但是，只做一次。
2. 運行代碼。      =>  依賴於一條命令。就可以。

所以，我們可以吧代碼， 按照作用，分成兩種：

1. 實現代碼。 它是來實現需求的。  ( implementation code)
2. 測試代碼。  測試 實現代碼的。  ( test code)

所以，上面的人肉對比過程，就可以：

```
# 這個是  實現代碼
def sum a ,b
  a + b
end


# 下面是測試代碼。
def test_sum
  temp = sum(1,2)
  assert temp == 3
end
```

因爲 已經有這樣的單元測試 框架了（工具）， test_unit. 所以，我們就這樣用：

經典命名方式：

 任何一個class, 都要 命名成：  AbcTest
 該test Case中的測試方法，包含兩種：
   before/after   在某個測試執行之前、之後的方法
   test_xyz       測試方法

```
#  sum_test.rb

def sum a,b
  a + b
end


require 'test/unit'

class MyTest < Test::Unit::TestCase
  def test_sum
    assert sum(1,2) == 3
  end
end

```

運行：


```
Run options:

# Running tests:

hihihi
.

Finished tests in 0.000769s, 1300.3901 tests/s, 0.0000 assertions/s.

1 tests, 0 assertions, 0 failures, 0 errors, 0 skips
ruby hi_test.rb
Run options:

# Running tests:

.

Finished tests in 0.000432s, 2314.8148 tests/s, 2314.8148 assertions/s.

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

這樣就測試了 `sum` 這個方法。

但是這個例子太簡單了。

我們現實當中，需要測試：

1. 對於數據庫的操作
2. 對於HTTP的請求。 （鼠標點連接， 提交表單等等）

所以，我們需要在Rails中，使用單元測試。

默認情況下，rails是使用 test-unit 這個框架作爲單元測試的。

```
▾ test/
  ▸ controllers/
  ▸ fixtures/
  ▸ helpers/
  ▸ integration/
  ▸ mailers/
  ▸ models/
  test_helper.rb
```

其中的 test 目錄，是默認的放置測試文件的目錄。 這裏，
test_helper.rb文件就是測試的配置文件。

test_helper中，定義了在Rails環境下的TestCase.

```ruby
require 'active_support/testing/autorun'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_case'
require 'action_dispatch/testing/integration'
require 'rails/generators/test_case'
```

所以，有了 test目錄下的 test_helper.rb, 我們才能在Rails中，
運行單元測試（操作數據庫，模擬發送HTTP  GET/POST/DELETE請求)

# 該如何做？

假設：
1. 我們有個Rails項目。
2. 該項目有個功能點： /books.  每個book, 有個屬性：title:string
3. 當前所有的功能都正常。

## 先寫一個針對 books controller的測試。

```ruby
# controller:
class BooksController < ApplicationController
  def index
    @books = Book.all
  end
  # ...
end
```
那麼，測試文件就是：

```ruby
# test/controllers/books_controller_test.rb
require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = Book.create :title => 'book 1 name'
  end

  def test_should_get_index

    # 我要訪問：  /books
    get :index

    # 下面這句，表示， 頁面正常打開， 返回http 200
    assert_response :success
  end
end

```

運行：
```bash
 $ bundle exec rake test:functionals
Run options: --seed 10284

# Running:

.

Finished in 0.628374s, 1.5914 runs/s, 1.5914 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

說明剛纔的單元測試是沒錯的。

但是可能大家沒有啥感覺。

所以，我就把代碼做點兒更改：

```ruby
# test/controllers/books_controller_test.rb
require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = Book.create :title => 'book 1 name'
  end

  def test_should_get_index
    get :index
    puts "lalalalalalalala, failed"
    raise "failed"
    assert_response :success
  end
end

```

運行它，可以看到，報錯了：

```bash
$ bundle exec rake test:functionals
Run options: --seed 24385

# Running:

lalalalalalalala, failed
E

Finished in 0.149283s, 6.6987 runs/s, 0.0000 assertions/s.

  1) Error:
BooksControllerTest#test_should_get_index:
RuntimeError: failed
    test/controllers/books_controller_test.rb:63:in `test_should_get_index'

1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

可能大家還是沒啥感覺。 所以，我們按照真實的例子來：

正常的  /books 頁面看起來是：
TODO 補充好圖片。 保存在了桌面上。

那麼，假設我們在修改代碼的時候，它出錯了。

```ruby
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    raise "I got error!"  # => 這裏故意讓controller出錯！

    @books = Book.all
  end
```

重新打開  '/books':

TODO 出錯的圖片。

這個時候，我們運行單元測試：

```bash
$ bundle exec rake test:functionals
Run options: --seed 36707

# Running:

E

Finished in 0.133835s, 7.4719 runs/s, 0.0000 assertions/s.

  1) Error:
BooksControllerTest#test_should_get_index:
RuntimeError: I got error!
    app/controllers/books_controller.rb:7:in `index'
    test/controllers/books_controller_test.rb:61:in `test_should_get_index'

1 runs, 0 assertions, 0 failures, 1 errors, 0 skips

```

不要小看這個小的case, 一個真實的項目中，有幾百個需要測試的功能點是
常事兒。  那麼，我們在每次項目部署的時候，都需要保證所有的
功能是正常運行的。 我們不應該每次都人肉做這個事情。

所以，一定要用單元測試（來實現測試的自動化）.

## 再來個對 Model的測試

model的代碼：

```ruby
#app/models/book.rb
class Book < ActiveRecord::Base
end
```
對應的單元測試代碼就是:

```ruby
# -*- encoding : utf-8 -*-
require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def test_save
    Book.create :title => "三體"
    Book.create :title => "球狀閃電"
    Book.create :title => "海伯利安"

    assert Book.count == 3
  end
end
```

如果沒有其他測試數據的話， 上面的代碼就會正常運行：

``j
$ bundle exec rake test:units
Run options: --seed 60624

# Running:

=====
#<ActiveRecord::Relation [
 #<Book id: 980190963, title: "三體", created_at: "2015-10-23 07:33:10", updated_at: "2015-10-23 07:33:10">,
 #<Book id: 980190964, title: "球狀閃電", created_at: "2015-10-23 07:33:10", updated_at: "2015-10-23 07:33:10">,
 #<Book id: 980190965, title: "海伯利安", created_at: "2015-10-23 07:33:10", updated_at: "2015-10-23 07:33:10">]
>
.

Finished in 0.061792s, 16.1833 runs/s, 16.1833 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

但是，我們實際當中，發現報錯，於是我們增加調試信息：

```ruby

  def test_save
    # 往數據庫中，新增3個book
    Book.create :title => "三體"
    Book.create :title => "球狀閃電"
    Book.create :title => "海伯利安"

    # 打印數據庫中的數據
    puts "===== "
    puts Book.all.inspect

    assert Book.count == 3
  end
```

於是發現，最開始，由於使用scaffold, 生成了測試數據(test/fixtures/books.yml)
導致了，數據庫中，不但存在了上面的三個Book, 還有另外兩個：title 等於 "MyString" 的Book.

```bash
$ bundle exec rake test:units
Run options: --seed 55101

# Running:

=====
#<ActiveRecord::Relation [
 #<Book id: 298486374, title: "MyString", created_at: "2015-10-23 07:31:05", updated_at: "2015-10-23 07:31:05">,
 #<Book id: 980190962, title: "MyString", created_at: "2015-10-23 07:31:05", updated_at: "2015-10-23 07:31:05">,
 #<Book id: 980190963, title: "三體", created_at: "2015-10-23 07:31:05", updated_at: "2015-10-23 07:31:05">,
 #<Book id: 980190964, title: "球狀閃電", created_at: "2015-10-23 07:31:05", updated_at: "2015-10-23 07:31:05">,
 #<Book id: 980190965, title: "海伯利安", created_at: "2015-10-23 07:31:05", updated_at: "2015-10-23 07:31:05">]>
F

Finished in 0.052311s, 19.1164 runs/s, 19.1164 assertions/s.

  1) Failure:
BookTest#test_save [/workspace/test_rails/test/models/book_test.rb:12]:
Failed assertion, no message given.

1 runs, 1 assertions, 1 failures, 0 errors, 0 skips

```
這是爲啥呢？ 就是因爲， Rails中的單元測試，在每次運行前，都會
自動加載 fixtures.

```yaml
# test/fixtures/books.yml

book_one:
  title: MyString

two:
  title: MyString
```

## setup 與 teardown

setup: 在每個 testcase 運行之前， 運行。

teardown:  在每個testcase 運行完之後，運行。

例子：

```ruby

require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  def setup
    puts "== before run test case"
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_show
    @book = Book.create :title => 'book 1 name'
    get :show,  :id => @book.id
    assert_response :success
  end

  def teardown
    puts "== after run test case"
  end
end
```

結果：可以看到， setup, teardown 分別執行了兩次。

```bash
$ bundle exec rake test:functionals
Run options: --seed 13734

# Running:

== before run test case
== after run test case
.== before run test case
== after run test case
.

Finished in 0.162701s, 12.2925 runs/s, 12.2925 assertions/s.

2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

## 可讀性更好的一種變形：

下面兩種對於test case 的寫法，是相同的
```ruby

def test_sum
  assert 1+2 ==  3
end

# 這種寫法就是受到了 rspec的巨大影響。
test "1 + 2 應該等於3" do
  assett 1+2 == 3
end
```

```ruby
# 下面兩種寫法，相同
def setup
  Book.create :title => 'the name'
end

setup do
  Book.create :title => 'the name'
end
```

同理， teardown 也是。

下面是個完整的例子，大家可以參考來寫。

原則：

1. 基本的增刪改查，必須要寫單元測試。
2. 單元測試中，必須要有用戶的登錄。
3. 上傳文件，或者發送郵件，或者其他比較麻煩的，可以不寫。
4. 針對controller的測試，必須寫。model的測試，可以有選擇的寫（比如說，特別複雜的關聯關係，或者某個方法），
5. 其他的，request, view, routes 不需要寫單元測試。


```ruby
# test/controllers/books_controller_test.rb
# -*- encoding : utf-8 -*-
require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = Book.create :title => 'book 1 name'
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'get show ' do
    get :show,  :id => @book.id
    assert_response :success
  end

  test 'get new' do
    get :new
    assert_response :success
  end

  test 'post create' do
    post :create, :book => {
      :title => '三體'
    }
    assert Book.last.title  == '三體'
  end

  test 'delete destroy' do
    id_to_delete = @book.id
    delete :destroy , :id => id_to_delete
    assert Book.find_by_id(id_to_delete).blank?
  end

  test 'should get edit' do
    get :edit, :id => @book.id
    assert_response :success
  end

  test 'should put update' do
    put :update, :id => @book.id , :book => {
      :title => '球狀閃電'
    }

    assert Book.find(@book.id).title == '球狀閃電'
  end

end
```

注意：

單元測試所用的數據庫，必須跟其他的數據庫（development, production)
分開，因爲每次運行單元測試的時候，都會把測試數據庫中的數據，
刪掉，重寫。 所以，config/database.yml中，你總會看到這句話：

```
 16 # Warning: The database defined as "test" will be erased and
 17 # re-generated from your development database when you run "rake".
 18 # Do not set this db to the same as development or production.
```

但是，實踐中，一個常見的手法是，在部署時，development, production 可以
弄成一個。
