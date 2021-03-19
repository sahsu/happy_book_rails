# 日誌:   log4r

日誌是我們調試的最重要的手段，沒有之一。

我們可以通過debug, 斷點來人肉找到問題，但是如果沒有把信息保存到文件中，就無法
事後找到線索。

最好的日誌應該是 每日分卷, 有時間戳，可以控制輸入級別。

我第一次看到最好的日誌是在2006年，在java blog roller(https://roller.apache.org/)
上。簡直驚豔。

在ruby中，雖然有自帶的logger, 但是跟log4r還是有很大距離的。也很麻煩。

**TODO：請在此處說明ruby自帶的logger和log4r之間的優缺點比較，或直接列舉出log4r的優勢。**

所以，就出現了log4r ( log for ruby ).

# 使用步驟

1.新建一個log4r的配置文件：  config/log4r.yml

```yaml
log4r_config:
  # define all loggers ...
  loggers:
    - name      : production
      level     : WARN
      trace     : 'false'
      outputters :
      - datefile
    - name      : development
      level     : DEBUG
      trace     : 'true'
      outputters :
      - datefile

  # define all outputters (incl. formatters)
  outputters:
  - type: DateFileOutputter
    name: datefile
    dirname: "log"
    filename: "my_app.log" # notice the file extension is needed!
    formatter:
      date_pattern: '%H:%M:%S'
      pattern     : '%d %l: %m '
      type        : PatternFormatter
```

2.修改`config/application.rb`

```ruby
require 'rails/all'
# add these line for log4r
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
include Log4r

Bundler.require(:default, Rails.env) if defined?(Bundler)
module Zurich
  class Application < Rails::Application
    #...
    # assign log4r's logger as rails' logger.
    log4r_config= YAML.load_file(File.join(File.dirname(__FILE__),"log4r.yml"))
    YamlConfigurator.decode_yaml( log4r_config['log4r_config'] )
    config.logger = Log4r::Logger[Rails.env]
  end
end
```

3.修改Gemfile, 增加log4r的配置. 注意版本不能低於 `1.1.9`.否則不支持每日分卷

```ruby
gem 'log4r', '1.1.9'
```

4.如果你用的是Rails4, 那麼需要增加下面這個文件

```ruby
# config/initializers/log4r_patch_for_rails4.rb
class Log4r::Logger
  def formatter()
  end
end
```

現在就可以了。 進入到你的 Rails.root, 重啓rails, 就會發現`log`目錄開始分捲了。

```
May  9 17:05 rails_2011-05-09.log
May 10 13:42 rails_2011-05-10.log
```

日誌的內容看起來如下：

```bash
$ tail log/rails_2011-05-10.log
Started GET "/????_settings/19/edit" for 127.0.0.1 at ...
13:42:11 INFO:   Processing by ????SettingsController ...
13:42:11 INFO:   Parameters: {"id"=>"19"}
13:42:12 DEBUG:   ????Setting Load (0.0ms)  SELECT "d ...
13:42:12 INFO: Completed 200 OK in 750ms
```

**TODO：請試着用一條日誌舉例，詳細說明log4r的日誌特色。讓新同學明白該怎樣學會看日誌，更好的話可以談談自己看錯誤日誌的經驗，怎樣快速有效的在衆多日誌中獲取有用的信息。**

**TODO：本章節需要改進的地方在於，章節內容只純粹告訴了我怎樣安裝log4r，並沒有告訴我爲什麼要使用log4r，它的優勢在哪兒；安裝完log4r後我該怎樣使用好這個工具，把它的優勢展現出來。否則，裝了log4r卻不會如何有效的去查看錯誤日誌等於白裝。**
