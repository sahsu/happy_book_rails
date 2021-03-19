#[delayed_job](https://github.com/collectiveidea/delayed_job)
delayed_job用來處理rails中的異步延時任務,支持發送大量實時通訊、改變圖片尺寸、http下載等等。

例如， 我要在controller中，發送10萬封郵件。 這個操作要耗時3個小時。我們不能這樣寫：

```
def send_emails
  (1..1000000).each do |n|
    ## 開始處理髮送郵件。
  end
  redirect_to ...
end
```

這樣寫的話，是不行的。 每次這個action都會timeout。

對於這個情況，我們就要讓程序在後臺運行。

##安裝

在Active Record中使用，直接在`Gemfile`中加入

```bash
gem 'delayed_job_active_record'
```

運行`bundle install`安裝後端和delayed_job gem。
Active Record後端需要一個任務表，創建命令：

```bash
$ rails generate delayed_job:active_record
$ rake db:migrate
```
就會生成一個migration:

```
class CreateDelayedJobs < ActiveRecord::Migration
  def self.up
    create_table :delayed_jobs, force: true do |table|
      table.integer :priority, default: 0, null: false # Allows some jobs to jump to the front of the queue
      table.integer :attempts, default: 0, null: false # Provides for retries, but still fail eventually.
      table.text :handler,                 null: false # YAML-encoded string of the object that will do work
      table.text :last_error                           # reason for last failure (See Note below)
      table.datetime :run_at                           # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      table.datetime :locked_at                        # Set when a client is working on this object
      table.datetime :failed_at                        # Set when all retries have failed (actually, by default, the record is deleted instead)
      table.string :locked_by                          # Who is working on this object (if locked)
      table.string :queue                              # The name of the queue this job is in
      table.timestamps null: true
    end

    add_index :delayed_jobs, [:priority, :run_at], name: "delayed_jobs_priority"
  end

  def self.down
    drop_table :delayed_jobs
  end
end

```

如果是`rails 4.2`，則需要在`config/application.rb`中配置`queue_adapter`
```ruby
# config/application.rb
module YourApp
  class Application < Rails::Application

  　# 這裏，加上下面這一行：
    config.active_job.queue_adapter = :delayed_job
  end
end
```

>如果在`Rails 4.x`中使用了`protected_attributes` gem，必須將`gem protected_attributes`放在delayed_job前面，不然會報以下錯誤:

>ActiveRecord::StatementInvalid: PG::NotNullViolation: ERROR:  null value in column "handler" violates not-null constraint

##開發模式(development)
在development環境下，如果rails的版本大於3.1，每當執行完100個任務或者任務完成時，程序代碼會自動加載，所以在development環境更改代碼後不用重啓任務。

## 基本用法

假設，原來的代碼是：

```
["jim", "lily", "lucy", "alex"].each do |name|
  puts "hi #{name}"
end

```

需要創建一個文件：

```
# app/jobs/query_price_job.rb
class QueryPriceJob < Struct.new(:name)
	def perform
    # 注意： 下面參數中的name, 來自於上面的  Struct參數
		puts "hi #{name}"
	end
end
```

## 創建鉤子方法

```
class QueryPriceJob< Struct.new(:name)
  def enqueue(job)
  end

	def perform
		puts "hi #{name}"
	end

  # 注意：　鉤子方法中，參數要有 job.
  def before(job)
    # 注意：　每個鉤子方法，可以使用該Struct的構建參數
		puts "== in before, parameter: #{name}"
  end

  def after(job)
  end

  def success(job)
  end

  def error(job, exception)
  end

  def failure(job)
  end
end
```

在它的源代碼中，我們可以看到下面幾個順序：

```
def invoke_job
	hook :before
	payload_object.perform
	hook :success
rescue Exception => e
	hook :error, e
	raise e
ensure
	hook :after
end
```

## 關於執行的問題

1.每個job worker的默認工作間隔時間，是　60s, 也就是說，這些worker進程，每隔60s, 纔會檢查一下 delayed_jobs這個表．
2.比較有用的鉤子方法是after, 可以根據delayed_jobs這個表的handler，來查看狀態，例如：

```
def after job
	crypto_code = options[:crypto_code]
	target_code = options[:target_code]

 	# 注意：　在這裏，可以根據下面這句話，找到符合條件的job.
	size = Delayed::Job.where('handler like ?', "%crypto_code: SALT%").size
	# 如果該job是最後一個job, 那麼就開始更新．．．
	if size == 1
		Pair.update_single_crypto_difference_rate crypto_code, target_code
	end
　　
　# 執行完這個after, 上面的size才能變成0
end
```

##任務隊列

在任何對象中調用`.delay.method(params)`，它將在後臺進行處理
```ruby
#不使用延時任務
@user.activate!(@device)

#使用延時任務
@user.delay.activate!(@device)
```

使用了 `delay`之後， 所有的任務，都要：

1. 寫入到特定的“任務表”中。
2. 我們要運行一些“工人（worker）“， 來執行這些任務。

```
class User < ActiveRecord::Base
  def eat
    Rails.logger.info "== begin eating ..."
    sleep 2
    Rails.logger.info "== finished ..."
  end
end
```

```
rails console:
> User.first.delay.eat
```

```
$ bundle exec script/delayed_job -n 2 start
```
表示，同時有兩個worker 在幹活兒。這兩個worker, 會緊盯着“任務表”， 一有任務，馬上開始執行。

```
kaikai:graduate$ bundle exec ruby bin/delayed_job -n 2 start
delayed_job.0: process with pid 31047 started.
delayed_job.1: process with pid 31053 started.
```

3. 看日誌。就會發現， 這些worker 在不間斷的工作。

```
# 表示 worker 開始認領了這個任務，開始執行了。
# 第一步。 認領該任務。並且，把該任務的狀態，變成: locked.
17:44:52 DEBUG:   Delayed::Backend::ActiveRecord::Job Load (0.5ms)  SELECT  `delayed_jobs`.* FROM `delayed_jobs` WHERE `delayed_jobs`.`locked_by` = 'delayed_job.1 host:kaikai pid:31053' AND `delayed_jobs`.`locked_at` = '2016-11-03 09:44:52' AND `delayed_jobs`.`failed_at` IS NULL  ORDER BY `delayed_jobs`.`id` ASC LIMIT 1
# 第二步。 開始執行了。
17:44:52 INFO: == begin eating ...
17:44:52 DEBUG:   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
# 這個是delayed job的日誌
17:44:52 INFO: 2016-11-03T17:44:52+0800: [Worker(delayed_job.1 host:kaikai pid:31053)] Job User#eat (id=2) RUNNING
17:44:54 INFO: == finished ...
# 第三步。 執行完畢，從delay_jobs （任務表）中，刪掉幹才幹完的任務。
17:44:54 INFO: 2016-11-03T17:44:54+0800: [Worker(delayed_job.0 host:kaikai pid:31047)] Job User#eat (id=1) COMPLETED after 2.2580
# 因爲它幹完一個任務就刪掉一個， 所以，當delay_jobs 表中，沒有任何記錄的時候，就是活兒幹完
的時候。
```

如果一個方法需要一直在後臺運行，可以在方法聲明之後，調用`handle_asynchronously`

```ruby
class Device
  def deliver
    #長時間運行方法
  end
  handle_asynchronously :deliver
end

device = Device.new
device.deliver
```
###參數
`handle_asynchronously`和`delay`有下列參數：
* :priority (number):數值越小越先執行，默認爲0，但可以重新配置
* :run_at (time):在這個時間後執行任務
* :queue(string):任務隊列名，是priority的另一種選擇

```ruby
class LongTasks
  def send_mailer
    # Some other code
  end
  handle_asynchronously :send_mailer, :priority => 20

  def in_the_future
    # Some other code
  end
  #五分鐘後將執行(5.minutes.from_now)
  handle_asynchronously :in_the_future, :run_at => Proc.new { 5.minutes.from_now }

  def self.when_to_run
    2.hours.from_now
  end

  class << self
    def call_a_class_method
      # Some other code
    end
    handle_asynchronously :call_a_class_method, :run_at => Proc.new { when_to_run }
  end

  attr_reader :how_important

  def call_an_instance_method
    # Some other code
  end
  handle_asynchronously :call_an_instance_method, :priority => Proc.new {|i| i.how_important }
end
```
如果在調試的時候要調用一個`handle_asynchronously`的方法，但是不想延遲執行，這時候可以在方法名後面加上`_without_delay`，例如原方法名叫做`foo`，立即執行爲`foo_without_delay`

##運行任務
`script/delayed_job`能夠用來管理後來進程，開始任務。
添加`gem "daemons"到`Gemfile`，並且執行`rails generate delayed_job`
```bash
RAILS_ENV=production script/delayed_job start
RAILS_ENV=production script/delayed_job stop

# 在不同的進程上執行兩個worker
RAILS_ENV=production script/delayed_job -n 2 start
RAILS_ENV=production script/delayed_job stop

# 使用--queue或者--queues選項來指定不同的隊列
RAILS_ENV=production script/delayed_job --queue=tracking start
RAILS_ENV=production script/delayed_job --queues=mailers,tasks start

#使用--pool選項來指定worker pool，可以多次使用這個選項來給不同隊列啓動不同數量的worker

#下面啓動一個worker執行`tracking`隊列，兩個worker執行`mailers`和`task`隊列，另外兩個worker給其他的任務
RAILS_ENV=production script/delayed_job --pool=tracking --pool=mailers,tasks:2 --pool=*:2 start

# 執行所有任務，然後退出
RAILS_ENV=production script/delayed_job start --exit-on-complete
#或者直接在前端執行
RAILS_ENV=production script/delayed_job run --exit-on-complete
```
>Rials 4 需要替換`script/delayed_job`爲`bin/delayed_job`
worker可以運行在任何電腦上，只要它們能夠訪問數據庫並且時鐘保持同步。每個worker至少每5秒鐘檢查一次數據庫。

可以使用`rake jobs:work`來開啓任務，使用`CTRL-C`終止rake任務。
如果需要執行所有任務並退出，可以使用`rake jobs:workoff`
處理隊列通過設置環境變量`QUEUE`或者`QUEUES`
```bash
$ QUEUE=tracking rake jobs:work
$ QUEUES=mailers,tasks rake jobs:work
```

##重啓delayed_job

單個job的重啓

```bash
$ RAILS_ENV=production script/delayed_job restart
```

多個job ：

```bash
$ RAILS_ENV=production script/delayed_job -n2 restart
```

建議：　使用下面的ruby腳本來重啓：　

```
# stop_delayed_job.rb
pids = `ps -ef | grep delayed_job | awk '{print $2}'`
pids.each_line do |pid|
  `kill -9 #{pid}`
end
```

>Rials 4 需要替換`script/delayed_job`爲`bin/delayed_job`

###清除任務
使用`rake jobs:clear`刪除隊列中的所有任務
