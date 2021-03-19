# bundler

隨着項目的越來越大，用到的gem越來越多，會有個巨大的問題：不同的gem依賴的版本不一樣。

例如:

- activesupport需要 sqlite 3.x版本
- activemail 需要 sqlite 2.x 版本
- sqlite 3 與sqlite2 不兼容，不能同時存在。

那麼，這就無法開發了。

bundler就是爲了解決此類問題出現的。它的作用是：

1. 把項目中所有用到的gem都寫到Gemfile中
2. 自動管理不同gem的版本依賴.
3. 實現更好的隔離環境，允許同一臺機器上同時並存某個gem的不同版本, 並且互相不干擾的運行。


## 安裝

`$ gem install bundler`

## 使用

1.初始化：

`$ bundler init`

會在當前目錄下創建一個文件 Gemfile, 內容例如：

```ruby
# 這裏表示鏡像的位置
source 'https://rubygems.org'

# 第一個參數是gem名稱，後面的是版本號
gem 'httparty', '0.16.2'
gem 'log4r', '1.1.9'
gem 'rufus-scheduler', '3.4.2'


```

2.使用

例如安裝`json`，直接修改Gemfile:

```
# 增加這一行：
gem 'json'
```

然後執行安裝：

```
$ bundle install
```

就會發現自動有Gem被安裝，並且生成了一個新的文件 Gemfile.lock

```
$ bundle
Fetching gem metadata from https://gems.ruby-china.com/.
Resolving dependencies...
Using bundler 2.0.2
Fetching json 2.5.1
Installing json 2.5.1 with native extensions
Bundle complete! 1 Gemfile dependency, 2 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

Gemfile.lock的內容如下：

```
GEM
  remote: https://gems.ruby-china.com/
  specs:
    json (2.5.1)

PLATFORMS
  ruby

DEPENDENCIES
  json

BUNDLED WITH
   2.0.2

```


## 在當前的Gemfile定義的環境中運行

假設當前目錄包含了3個文件：

```
Gemfile
Gemfile.lock
test.rb
```

我們可以運行對應的rb文件：
```
$ bundle exec ruby test.rb
```

## 原則

在rails目錄下，執行任何命令的時候，都要加上 `bundle exec` 前綴，例如 `bundle exec rails console`

如果不加bundle exec的話，系統會默認執行rails的最高版本。例如，下面的命令，可以看出本機安裝了2個rails版本： 6.0.3和4.2.10

```
$ gem list -l rails

*** LOCAL GEMS ***

rails (6.0.3, 4.2.10)
```

如果不使用bundle exec 的話，默認rails console會執行rails 6.0.3的命令，會造成各種奇怪的錯誤。
