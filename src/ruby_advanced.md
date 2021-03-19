# Ruby　進階

在中國,任何區分, 入門級 與 老手級的程序員?

1. 什麼是單元測試   unit test. (針對 方法級別的測試) 往往使用框架.
2. 什麼是持續集成  每隔一段時間, 運行所有的單元測試. continuous integration CI. jenkins
3. 什麼是重構. refactoring 在不改變代碼的行爲的前提下, 改變代碼的結構.

## 單元測試

單元測試很重要．在任何語言中都是．

不要用DEBUG,斷點這些東東．　這些都是人肉的測試．

一般單元測試寫好了，以後的情況完全就是自動化運行測試

單元測試也是一切自動化測試,　持續集成，重構的基礎．

### TestUnit

這個是最經典的測試框架．

```ruby
# apple_test.rb
class Apple
  def color
    'red'
  end
end

require 'test/unit'
class AppleTest< Test::Unit::TestCase
  def test_color
    assert Apple.new.color == 'red'
  end
end
```

我們會得到結果：

```bash
$ ruby apple_test.rb
Run options:

# Running tests:
.

Finished tests in 0.000465s, 2151.9213 tests/s, 2151.9213 assertions/s.

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

### TDD: 測試驅動開發

優點:

1. 自然而然就寫了單元測試了.  進行持續集成是水到渠成的.
2. 能夠催生出優秀的實現代碼(軟件的設計層面).

(爲什麼? 如何催生出來的?  我們是先考慮測試(我們此時是使用者), 使用者最知道如何使用,
纔是使用者最喜歡的. 那麼, 滿足"使用者寫出的測試"的實現代碼, 就是最優設計.

### 國內, 95%的人, 不寫單元測試

我們入鄉隨俗, 不要永遠不寫, 我們要寫30%的測試.

Rails中, 我們只寫controller, model的測試, 就夠了.

其他的測試,不寫了.

## Rescue , exception

跟java一樣，Ruby也會拋出異常，捕獲異常．

```ruby
# test_error.rb
def error
  raise 'I got error!'
end

error
```

運行它，會看到出錯：
```bash
$ ruby test.rb
test.rb:2:in `error': I got error! (RuntimeError)
  from test.rb:5:in `<main>'
```

可以使用　begin..rescue ..end 來處理異常

```ruby
  # test_rescue.rb
  def error
    begin
      raise 'I got error!'
    rescue Exception => e
      puts e
      puts e.backtrace
    end
  end

  error
```
運行，就可以看到異常的名字，以及出錯的軌跡都打印出來了：
```bash
$ ruby test_rescue.rb
I got error!
test_rescue.rb:3:in `error'
test_rescue.rb:10:in `<main>'
```


