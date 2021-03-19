# 安裝環境

雖然系統默認自帶了Ruby，但是不如我們自定義的靈活．我們使用[rbenv](https://github.com/sstephenson/rbenv) 來安裝Ruby,　最大的好處是
可以允許你同時安裝多個Ruby版本．

## 安裝rbenv
rbenv(ruby environment),是管理多個不同版本的ruby工具，是之前rvm(ruby version manager)的替代品。類似的工具還有管理不同Node版本的nvm(node version manager)。

具體的安裝步驟爲:

```
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
# 用來編譯安裝 ruby
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# 用來管理 gemset, 可選, 因爲有 bundler 也沒什麼必要
git clone git://github.com/jamis/rbenv-gemset.git  ~/.rbenv/plugins/rbenv-gemset
# 通過 gem 命令安裝完 gem 後無需手動輸入 rbenv rehash 命令, 推薦
git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
# 通過 rbenv update 命令來更新 rbenv 以及所有插件, 推薦
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
```

然後把下面的代碼放在~/.zshrc裏面
```
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

*注意* :如果你使用的是bash，那應該把上面的代碼放在~/.bashrc或者~/.bash_profile裏面

最後，重啓一下你的Terminal就OK了。

## 安裝ruby
```
rbenv install --list # 列出所有可以安裝的ruby版本
rbenv install 1.9.3-p551 # 安裝特定版本的ruby
```
*注意* :使用rbenv安裝了ruby之後，要指定你想要使用的本班爲當前版本
```
rbenv global 1.9.3-p551 # 指定版本
```
## 列出ruby版本
```
rbenv versions # 系統所有通過rbenv安裝的ruby版本
rbenv version # 當前版本
```


## 調試方法: irb

irb = interactive ruby

在命令行下，輸入 `$ irb` 即可．　這是一個ruby的即時調試界面．

## 說明

用 `# => `表示輸出結果 , 例如：

```ruby
puts "goodbye java"
# => "goodbye java"
```

用$, 或者# 表示bash命令行程序，例如：

```bash
$ ruby test_my_module.rb
```
或者：
```ruby
# ps -ef | grep nginx
```

