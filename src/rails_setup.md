# 安装与运行

## 版本说明

操作系统：Linux/Mac

注意：可以明确的是Windows暂不支持Rails.最大的阻碍是windows的环境由于被限制，无法正确安装sqlite3或者mysql的依赖，导致无法安装相应的gem,
直接导致Rails无法被安装或者运行。

使用windows的同学，建议安装双系统，或者安装虚拟机，然后在虚拟机上安装Ubuntu 16.

- ruby 2.5.0.     这里版本不限，我个人用2.5比较多。
- bundler 1.17.3
- rails 4.2.10
- mysql 5.x

对于Rails来说：

- Rails 2 是个稳定版本，
- Rails 3 增加了bundler, asset pipeline,
- Rails 4 增加了一系列优化
- Rails 5 支持了ActionCabel(用于聊天室等）
- Rails 6 增加了多数据库的支持

考虑到入门的简单和安装的方便，我们直接采用Rails 4.2.10, 因为Rails4 可以平滑过渡到Rails6.

MySQL: 5.x都可以。在Ubuntu 20上默认会安装mysql 8. 都是一样的。

## 安装Rails

1. 在ubuntu上需要先安装一系列的依赖

```
$ sudo apt-get update
$ sudo apt-get install libapr1-dev libxml2-dev  libxslt-dev mysql-server  \
  libmysqlclient-dev  git curl build-essential libssl-dev libreadline-dev  \
  build-essential libssl-dev libreadline-dev vim libcurl3 ruby-dev zlib1g-dev \
  liblzma-dev ruby-all-dev
```

2.安装rbenv, ruby 3.0

过程略

3.安装bundler

使用了ruby-china的镜像站点, 可以大幅提高速度：

```
$ gem install bundler -v 1.17.3 --source https://gems.ruby-china.com

Successfully installed bundler-1.17.3
Parsing documentation for bundler-1.17.3
Parsing sources...
Installing ri documentation for bundler-1.17.3
Done installing documentation for bundler after 3 seconds
1 gem installed
```

4.安装rails

```
$ gem install rails -v 4.2.10 --source https://gems.ruby-china.com
....
Installing ri documentation for rails-4.2.10
Done installing documentation for bundler ...
23 gems installed
```

注意： 如果你安装了其他的rails版本，就把它们删掉。

就可以了。

## 首次运行Rails

首先我们创建一个文件夹，专门用于学习Rails:

```
$ rails new lesson_one_quick_start
```

然后，我们会看到一系列的输出：

```
create
create  README.rdoc
create  Rakefile
create  config.ru
create  .gitignore
create  Gemfile
create  app
create  app/assets/javascripts/application.js
create  app/assets/stylesheets/application.css
create  app/controllers/application_controller.rb
create  app/helpers/application_helper.rb
create  app/views/layouts/application.html.erb
create  app/assets/images/.keep
create  app/mailers/.keep
create  app/models/.keep
create  app/controllers/concerns/.keep
create  app/models/concerns/.keep
create  bin
create  bin/bundle
create  bin/rails
create  bin/rake
create  bin/setup
create  config
create  config/routes.rb
create  config/application.rb
create  config/environment.rb
create  config/secrets.yml
create  config/environments
create  config/environments/development.rb
create  config/environments/production.rb
create  config/environments/test.rb
create  config/initializers
create  config/initializers/assets.rb
create  config/initializers/backtrace_silencers.rb
create  config/initializers/cookies_serializer.rb
create  config/initializers/filter_parameter_logging.rb
create  config/initializers/inflections.rb
create  config/initializers/mime_types.rb
create  config/initializers/session_store.rb
create  config/initializers/to_time_preserves_timezone.rb
create  config/initializers/wrap_parameters.rb
create  config/locales
create  config/locales/en.yml
create  config/boot.rb
create  config/database.yml
create  db
create  db/seeds.rb
create  lib
create  lib/tasks
create  lib/tasks/.keep
create  lib/assets
create  lib/assets/.keep
create  log
create  log/.keep
create  public
create  public/404.html
create  public/422.html
create  public/500.html
create  public/favicon.ico
create  public/robots.txt
create  test/fixtures
create  test/fixtures/.keep
create  test/controllers
create  test/controllers/.keep
create  test/mailers
create  test/mailers/.keep
create  test/models
create  test/models/.keep
create  test/helpers
create  test/helpers/.keep
create  test/integration
create  test/integration/.keep
create  test/test_helper.rb
create  tmp/cache
create  tmp/cache/assets
create  vendor/assets/javascripts
create  vendor/assets/javascripts/.keep
create  vendor/assets/stylesheets
create  vendor/assets/stylesheets/.keep
   run  bundle install
```

上面这些输出会在3～5秒内完成。表示的是创建了若干文件和文件夹。

最后光标往往会停留在 最后一行不动( `run bundle install` ), 这是由于进程被卡住了导致的，我们直接按`ctrl + c`来终止。


进入到刚才创建的目录下:

```
$ cd lesson_one_quick_start
```

## 文件夹结构

查看一下文件: (我在右侧做了文件夹的说明）

```
total 68
drwxr-xr-x 12 siwei siwei 4096 1月  29 07:51 ./         当前路径
drwxr-xr-x  3 siwei siwei 4096 1月  29 07:51 ../        上一级路径
drwxr-xr-x  8 siwei siwei 4096 1月  29 07:51 app/       最重要的目录
drwxr-xr-x  2 siwei siwei 4096 1月  29 07:51 bin/       自动生成的，不要修改
drwxr-xr-x  5 siwei siwei 4096 1月  29 07:51 config/    配置文件目录，很重要
-rw-r--r--  1 siwei siwei  153 1月  29 07:51 config.ru  自动生成的，不要修改
drwxr-xr-x  2 siwei siwei 4096 1月  29 07:51 db/        存放数据库相关的文件
-rw-r--r--  1 siwei siwei 1503 1月  29 07:51 Gemfile    bundler使用
-rw-r--r--  1 siwei siwei  474 1月  29 07:51 .gitignore git使用
drwxr-xr-x  4 siwei siwei 4096 1月  29 07:51 lib/       暂时用不到
drwxr-xr-x  2 siwei siwei 4096 1月  29 07:51 log/       日志文件夹，调试重要
drwxr-xr-x  2 siwei siwei 4096 1月  29 07:51 public/    用于存放图片等文件夹
-rw-r--r--  1 siwei siwei  249 1月  29 07:51 Rakefile   自动生成的，不要修改
-rw-r--r--  1 siwei siwei  478 1月  29 07:51 README.rdoc 项目说明文件, 要修改
drwxr-xr-x  8 siwei siwei 4096 1月  29 07:51 test/      测试文件夹，可以删掉
drwxr-xr-x  3 siwei siwei 4096 1月  29 07:51 tmp/       自动生成的，不要修改
drwxr-xr-x  3 siwei siwei 4096 1月  29 07:51 vendor/    基本没用，可以删掉
```

## 使用Gemfile安装各种依赖的gem

我们修改一下Gemfile 文件，把下面内容粘贴上去：

```
source 'https://gems.ruby-china.com'

gem 'rails', '4.2.10'
gem 'mysql2', '0.3.21'
gem 'therubyracer', '0.12.3', platforms: :ruby
gem 'turbolinks', '5.2.1'

gem 'jquery-rails', '4.4.0'

```

然后运行：

```
$ bundle install
```

输出结果如下：
```
Using rake 13.0.3
Using concurrent-ruby 1.1.8
Using i18n 0.9.5
....省略若干...
Using sprockets-rails 3.2.2
Using rails 4.2.10
Using ref 2.0.0
Using therubyracer 0.12.3
Using turbolinks-source 5.2.0
Using turbolinks 5.2.1
Bundle complete! 5 Gemfile dependencies, 42 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

就说明项目所需要的gems 都安装好了。

## 配置数据库

然后修改 `config/database.yml` 文件，这是数据库的配置，我们把下面内容粘贴上去, 表示使用 `study_rails` 作为数据库,
地址是 localhost, 用户名root, 密码666666(可以根据你的本机MYSQL配置做修改)：

```
default: &default
  adapter: mysql2
  encoding: utf8
  collation: utf8_general_ci
  pool: 5
  host: localhost
  username: root
  password: 666666

development:
  <<: *default
  database: study_rails

test:
  <<: *default
  database: study_rails_test

production:
  database: study_rails
```

并且登录本机Mysql, 创建对应的 `study_rails` 数据库

```
mysql> CREATE DATABASE `study_rails` CHARACTER SET utf8 COLLATE utf8_general_ci;

Query OK, 1 row affected (0.01 sec)
```

然后运行

```
$ bundle exec rails s

=> Booting WEBrick
=> Rails 4.2.10 application starting in development on http://localhost:3000
=> Run `rails server -h` for more startup options
=> Ctrl-C to shutdown server
[2021-01-29 09:02:42] INFO  WEBrick 1.4.2
[2021-01-29 09:02:42] INFO  ruby 2.6.4 (2019-08-28) [x86_64-linux]
[2021-01-29 09:02:42] INFO  WEBrick::HTTPServer#start: pid=32543 port=3000

```

使用浏览器打开： `http://localhost:3000`

就可以发现Rails已经成功运行了

![hello](images/lesson_1_rails_running.png)


## 关闭无用的警告

修改`config/environments/development.rb`, 把下面的内容设置成 `false`,

```
config.assets.check_precompiled_asset = false
```
