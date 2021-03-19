#[rufus-scheduler](https://github.com/jmettraux/rufus-scheduler)

##簡介

能夠定時的執行命令的`rails gem`

##安裝

在rails項目中的`Gemfile`中添加`gem 'rufus-scheduler'`後`bundle install`即可

##使用

###準備腳本

- 在項目目錄下新增scripts文件夾
- 增加`test_rufus_scheduler.rb	`文件
- 寫入如下代碼

```ruby
# -*- encoding : utf-8 -*-
ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rubygems'
require 'rufus/scheduler'
require 'rails'
require 'uri'
scheduler = Rufus::Scheduler.new

scheduler.every '180s' do
  # 每隔180s執行
end

scheduler.in '5s' do
  # 5s時執行
end
  
scheduler.in '10d' do
  # 10天時執行
end

scheduler.at '2030/12/12 23:30:00' do
  # 在某一個詳細的時間段執行
end

scheduler.every '3h' do
  # 每隔3h執行
end

scheduler.cron '5 0 * * *' do
  # 能用crontab(http://crontab.org/)的表達形式
  # 每天凌晨5分鐘後執行
end

scheduler.join
```

###啓動腳本

- `bundle exec ruby scripts/test_rufus_scheduler.rb`

- 如果需要以後臺運行形式啓動可加上`nohup`,如:`nohup bundle exec ruby scripts/test_rufus_scheduler.rb`
> 查看進程可通過`ps ef | grep ruby`查看