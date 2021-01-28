# 安装环境

虽然系统默认自带了Ruby，但是不如我们自定义的灵活．我们使用[rbenv](https://github.com/sstephenson/rbenv) 来安装Ruby,　最大的好处是
可以允许你同时安装多个Ruby版本．

## 安装rbenv
rbenv(ruby environment),是管理多个不同版本的ruby工具，是之前rvm(ruby version manager)的替代品。类似的工具还有管理不同Node版本的nvm(node version manager)。

具体的安装步骤为:

```
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
# 用来编译安装 ruby
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# 用来管理 gemset, 可选, 因为有 bundler 也没什么必要
git clone git://github.com/jamis/rbenv-gemset.git  ~/.rbenv/plugins/rbenv-gemset
# 通过 gem 命令安装完 gem 后无需手动输入 rbenv rehash 命令, 推荐
git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
# 通过 rbenv update 命令来更新 rbenv 以及所有插件, 推荐
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
```

然后把下面的代码放在~/.zshrc里面
```
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

*注意* :如果你使用的是bash，那应该把上面的代码放在~/.bashrc或者~/.bash_profile里面

最后，重启一下你的Terminal就OK了。

## 安装ruby
```
rbenv install --list # 列出所有可以安装的ruby版本
rbenv install 1.9.3-p551 # 安装特定版本的ruby
```
*注意* :使用rbenv安装了ruby之后，要指定你想要使用的本班为当前版本
```
rbenv global 1.9.3-p551 # 指定版本
```
## 列出ruby版本
```
rbenv versions # 系统所有通过rbenv安装的ruby版本
rbenv version # 当前版本
```


## 调试方法: irb

irb = interactive ruby

在命令行下，输入 `$ irb` 即可．　这是一个ruby的即时调试界面．

## 说明

用 `# => `表示输出结果 , 例如：

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

