# bundler

随着项目的越来越大，用到的gem越来越多，会有个巨大的问题：不同的gem依赖的版本不一样。

例如:

- activesupport需要 sqlite 3.x版本
- activemail 需要 sqlite 2.x 版本
- sqlite 3 与sqlite2 不兼容，不能同时存在。

那么，这就无法开发了。

bundler就是为了解决此类问题出现的。它的作用是：

1. 把项目中所有用到的gem都写到Gemfile中
2. 自动管理不同gem的版本依赖.
3. 实现更好的隔离环境，允许同一台机器上同时并存某个gem的不同版本, 并且互相不干扰的运行。


## 安装

`$ gem install bundler`

## 使用

1.初始化：

`$ bundler init`

会在当前目录下创建一个文件 Gemfile, 内容例如：

```ruby
# 这里表示镜像的位置
source 'https://rubygems.org'

# 第一个参数是gem名称，后面的是版本号
gem 'httparty', '0.16.2'
gem 'log4r', '1.1.9'
gem 'rufus-scheduler', '3.4.2'


```

2.使用

例如安装`json`，直接修改Gemfile:

```
# 增加这一行：
gem 'json'
```

然后执行安装：

```
$ bundle install
```

就会发现自动有Gem被安装，并且生成了一个新的文件 Gemfile.lock

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

Gemfile.lock的内容如下：

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


## 在当前的Gemfile定义的环境中运行

假设当前目录包含了3个文件：

```
Gemfile
Gemfile.lock
test.rb
```

我们可以运行对应的rb文件：
```
$ bundle exec ruby test.rb
```

## 原则

在rails目录下，执行任何命令的时候，都要加上 `bundle exec` 前缀，例如 `bundle exec rails console`

如果不加bundle exec的话，系统会默认执行rails的最高版本。例如，下面的命令，可以看出本机安装了2个rails版本： 6.0.3和4.2.10

```
$ gem list -l rails

*** LOCAL GEMS ***

rails (6.0.3, 4.2.10)
```

如果不使用bundle exec 的话，默认rails console会执行rails 6.0.3的命令，会造成各种奇怪的错误。
