# Ruby　进阶

在中国,任何区分, 入门级 与 老手级的程序员?

1. 什么是单元测试   unit test. (针对 方法级别的测试) 往往使用框架.
2. 什么是持续集成  每隔一段时间, 运行所有的单元测试. continuous integration CI. jenkins
3. 什么是重构. refactoring 在不改变代码的行为的前提下, 改变代码的结构.

## 单元测试

单元测试很重要．在任何语言中都是．

不要用DEBUG,断点这些东东．　这些都是人肉的测试．

一般单元测试写好了，以后的情况完全就是自动化运行测试

单元测试也是一切自动化测试,　持续集成，重构的基础．

### TestUnit

这个是最经典的测试框架．

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

我们会得到结果：

```bash
$ ruby apple_test.rb
Run options:

# Running tests:
.

Finished tests in 0.000465s, 2151.9213 tests/s, 2151.9213 assertions/s.

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

### TDD: 测试驱动开发

优点:

1. 自然而然就写了单元测试了.  进行持续集成是水到渠成的.
2. 能够催生出优秀的实现代码(软件的设计层面).

(为什么? 如何催生出来的?  我们是先考虑测试(我们此时是使用者), 使用者最知道如何使用,
才是使用者最喜欢的. 那么, 满足"使用者写出的测试"的实现代码, 就是最优设计.

### 国内, 95%的人, 不写单元测试

我们入乡随俗, 不要永远不写, 我们要写30%的测试.

Rails中, 我们只写controller, model的测试, 就够了.

其他的测试,不写了.

### Rspec

(rpsec)[http://rspec.info/]是一个ＢＤＤ框架． 它鼓励我们先写行为，再写测试． 例如:

```ruby
# 下面代码仅是示意． 运行的话需要在rails环境内, 后面rails章节会有描述
describe Apple do
  it 'color shoud be red' do
    Apple.new.color.should == 'red'
  end
end
```

## Rescue , exception

跟java一样，Ruby也会抛出异常，捕获异常．

```ruby
# test_error.rb
def error
  raise 'I got error!'
end

error
```

运行它，会看到出错：
```bash
$ ruby test.rb
test.rb:2:in `error': I got error! (RuntimeError)
  from test.rb:5:in `<main>'
```

可以使用　begin..rescue ..end 来处理异常

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
运行，就可以看到异常的名字，以及出错的轨迹都打印出来了：
```bash
$ ruby test_rescue.rb
I got error!
test_rescue.rb:3:in `error'
test_rescue.rb:10:in `<main>'
```


