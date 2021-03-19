# 使用配置文件

rails 自帶配置文件。比如，我們可以把配置寫到：

- config/application.rb
- config/environments/developement.rb
- config/environments/production.rb
- config/environments/test.rb

也可以把配置寫到：

- config/initializers/xyz.rb

但是，上面幾個文件都不如 yml 文件好:

- yml 文件的配置屬性更強大一些。也更加易讀。前面的文件都是系統核心文件。
- rails中有很多階段，例如：
  - 剛啓動
  - 開始加載 config/application.rb
  - 加載完畢 config/application.rb
  - 開始加載 config/environments
  - 加載完畢 config/environments 中各種文件等
  希望在任意一個階段使用某個常量，都是需要確保這個常量是被定義好的。

  我們使用 railsconfig 可以輕易的在 rails最開始加載的時候，就配置好某個常量。

所以，我們要使用 railsconfig.

## 安裝

在 Gemfile中：

```ruby
gem 'config'
```

然後 `$bundle install` 即可。

## 使用

- 生成配置文件：
```
$ bundle exec rails g config:install
```

就會生成下面若干文件：
```
# 必須的文件。
# config/initializers/config.rb

RailsConfig.setup do |config|
  # 這裏指定了配置對象的名稱
  config.const_name = "Settings"
end
```

以及下面的配置文件（如果你喜歡簡單的話，可以只保留 `config/settings.yml`）
```
# 全局的配置文件。
config/settings.yml
# 開發模式下的文件。
config/settings/development.yml
# 生產模式下的配置文件。
config/settings/production.yml
# 測試模式下的配置文件。
config/settings/test.yml
```

其中，後面三者的內容都會直接覆蓋 config/settings.yml 的內容。

編輯對應的配置文件。

```yml
username: 'uubpay'
password: 'goodday!'
```

使用方法如下：

```rb
login_upyun(
  username: Settings.username,
  password: Settings.password
)
```
