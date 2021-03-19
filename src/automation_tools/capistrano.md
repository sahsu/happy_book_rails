# Capistrano: 自動化部署的利器

> 注意： 以下的文檔針對的版本是 2.12.0
capistrano 3.x 跟 2.x 的工作原理是差不多的. 掌握了其中一個, 就可以很快掌握第二個.
區別在於 3.x 只在 ruby 2.x 版本下工作. 很多項目都是 1.9.x的,所以我們以capistrano 2爲例.

## 簡介

Capistrano 是個好用的自動化部署工具, 能夠快速自動的將自己的代碼部署到正式服務器上面。
替代人肉的工作.

## 注意: (TODO 另起個章節,專門說安全問題)

絕對不要把 config/deploy.rb 放到代碼倉庫中.
絕對不要把 config/deploy.rb 放到代碼倉庫中.
絕對不要把 config/deploy.rb 放到代碼倉庫中.

同理, 不要把 配置信息 放到 代碼倉庫中. 比如:

數據庫配置信息: database.yml
郵箱配置信息:  mail.yml
應用服務器配置信息: thin.yml, unicorn.yml

如果你在公司中發現這樣的人,直接把他開掉. 對服務器沒有安全意識.

無數的服務器配置信息,都在github上的公共項目中的 部署腳本 文件中泄漏出去的.
端口號, 用戶名, ip地址一泄漏出去的話,基本上對方拿個密碼字典碰幾天, 你的服務器就成了肉雞了.

## 爲什麼不要人肉去做

很多同學在部署時,用的是自己寫的腳本. 這個就不對了. 自己寫的腳本永遠不專業. 不要自大,相信我沒錯的.

哪怕是運維級別的同學,寫出來的腳本,也無法輕易回滾. 因爲這裏的邏輯還是比較多的,光靠腳本不行. 還得
需要比較多的代碼邏輯.

最常見的人肉腳本是:

1. 進入到代碼倉庫
```
$ cd < your code repo>
```
2. 更新代碼:
```
$ git pull
```
3. 重啓
```
$ bundle exec thin restart
```

如果你有20個服務器,就可以這樣使用腳本去做了.

但是上面最大的缺點:
1. 無法回滾
2. 你要祈禱工作順風順水,稍微有一個環節出了錯, 就要手續繼續處理剩下的環節.

## 安裝方式：


- 進入到項目目錄下面,並增加下面內容到 `Gemfile` 中：

```ruby
group :development
  gem 'capistrano', '2.12.0'
  gem 'capistrano-rbenv', '1.0.1'
end
```

- 安裝添加的`gem`

```bash
$ bundle install
```

- 再運行下面的命令：

```bash
$ capify .
capify .
[skip] './Capfile' already exists
[skip] './config/deploy.rb' already exists
[done] capified!
```

會生成兩個關鍵性的文件： `Capfile` , `config/deploy.rb`

- 編輯後者`config/deploy.rb`
	加上自己的capistrano配置信息
- 啓動deploy中的setup任務,創建一些必要文件夾

下面是一個完整的 部署腳本( config/deploy.rb )的例子, 修改其中的 用戶名,端口號, 目標服務器的域名 ,
服務器的啓動方式,
就可以直接運行了.:

```ruby
# -*- encoding : utf-8 -*-
require 'capistrano-rbenv'
load 'deploy/assets'
SSH_USER = '你的用戶名'
SSH_PORT = '你的端口號'
server = "目標服務器的域名或者ip"
FOLDER_IN_REMOTE_SERVER = '遠程服務器上的目標文件夾'

ssh_options[:port] = SSH_PORT
set :rake, "bundle exec rake"
set :application, "app name"
set :repository, "."
set :scm, :none
set :deploy_via, :copy

set :copy_exclude, ['tmp', 'log'] # 部署到遠程的時候,不考慮的兩個文件夾

role :web, server
role :app, server
role :db,  server, :primary => true
role :db,  server

set :deploy_to, FOLDER_IN_REMOTE_SERVER
default_run_options[:pty] = true

# change to your username
set :user, SSH_USER

namespace :deploy do
  task :start do
    run "cd #{release_path} && bundle exec thin start -C config/thin.yml"
  end
  task :stop do
    run "cd #{release_path} && bundle exec thin stop -C config/thin.yml"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    db_migrate
    stop
    sleep 2
    start
  end
  task :db_migrate do
    run "cd #{release_path} && bundle install"
    run "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=production"
  end

  namespace :assets do
    task :precompile do
      #run "bundle install"
      #run "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile "
    end
  end
end


desc "Copy database.yml to release_path"
task :cp_database_yml do
  puts "=== executing my customized command: "
  run "cp -r #{shared_path}/config/* #{release_path}/config/"
  run "ln -s #{shared_path}/files #{release_path}/public/files"
  # 因爲在開發機器上會存在這個文件夾，所以需要先把它刪掉，再 ln
  run "rm #{release_path}/public/uploads -rf"
  run "ln -s #{shared_path}/public/uploads #{release_path}/public/uploads"
  puts "=== done (executing my customized command)"
end

before "deploy:assets:precompile", :cp_database_yml
#after "deploy", "deploy:restart"
```

### 第一次運行時,要先 配置好目標服務器上的文件夾.


```bash
$ cap deploy:setup
```

注意: 這裏讓它創建基本的目標文件夾目錄層次就可以:

```
/opt/app:
    current (這是個軟鏈接 soft link, )-> /opt/app/releases/20150518030114/
    releases/
    shared/
        assets
        config
        files
        log
        pids
        public
        system
```

不要讓它做 : 安裝rbenv, 安裝ruby 版本, 安裝第三方包的事兒.
> 注意： 這裏務必記得， 盯緊控制檯的輸出， 看到它執行完 `mkdir -p ` 之後， 趕緊按`ctrl + c` 暫停。否則它會默認在遠程服務器上安裝各種ruby 第三方包，安裝各種linux 依賴包。一不小心就會把服務器環境搞砸了。

2. 爲 `shared` 目錄下，增加各種配置文件，它們只需要被配置一遍。例如：

```bash
config/thin.yml       # 服務器的配置
config/database.yml   # 數據庫的配置
config/log4r.yml      # 日誌文件的配置
config/settings.yml   # 系統的配置
```

3. 配置好ruby環境， mysql, thin, nginx 等

### 開始部署

```
$ cap deploy.
```

這個命令會執行下面的過程:
  - 準備啓動服務器:
  - 安裝各種新增的rubygem
  - 做必要的數據庫遷移
  - 配置各種文件
  - 修改上傳文件夾的softlink
  - 其他,每次使用裸代碼做部署的時候,都要人肉做的事情.  (修改保存日誌的路徑,  修改 rails server的配置,  )
  - 編譯,壓縮 js/ css
  - 重啓 服務器( `$ nginx -s reload`,  `$ kill -9 xxx ` ,  `$ thin start -C config/thin.yml`)

### 再次部署（更新版本）

只需要運行`$ cap deploy`即可。

## 使用命令行

下面是一個例子，在命令行中顯示 `User name: ` , 等用戶輸入完，按回車之後，
把輸入的值賦給 `user` 變量。

```ruby
set(:user) { Capistrano::CLI.ui.ask("User name: ") }
```

- 使用幫助：

```bash
$ cap --help
```

- 使用logger，特別是在其他語言調用CAP時，非常有用（例如被fabric 調用）:

```bash
$ cap setup --logger STDOUT
```

- 如何使用變量?

要記得: 使用@. . 例如，我們要設置 "deploy_type" 這個變量：

```bash
$ cap say_hi --set-before deploy_type=staging
```

然後在 config/deploy.rb 中這樣使用：

```ruby
DEFAULT_TYPE = "stable"

# deploy_type 僅僅在 begin 這個區域中生效, 在rescue, ensure中都不行。
begin
  deploy_type
  puts "deploy_type was set successfully"
  @deploy_type = deploy_type
  rescue Exception => e
  puts "deploy_type not set, use default: #{DEFAULT_TYPE}"
  deploy_type = DEFAULT_TYPE
  @deploy_type = deploy_type
end

task :say_hi do
  puts "hihihi, var_deploy_type: #{@deploy_type}"
end
```

輸出：
```bash
deploy_type was set successfully
============= DEPLOY_PATH: /rails_apps/babble_portal/cutting_edge
* executing `say_hi'
hihihi, var_deploy_type: 444
```

最後，使用copy方式：

```
# 腳本中
set :scm, :none
set :repository, "."
set :deploy_via, :copy
```

## capistrano的輸出詳解

TODO  各種屏幕截圖。 建立文件夾， 打包，壓縮，上傳，解壓縮， rake db.. assets等等

## 爲什麼要用capistrano

流行的工具都是有道理的（ best practices are best in most cases)

- 版本控制：SVN => GIT( scm : from SVN to GIT)

- 部署方式：人肉部署 => Capistrano

原來項目中用到的是SVN， 就一個分支，也不打`tag`。感覺用起來沒啥。  ( there's not so much trouble when the project is going under SVN and manual deployment)

現在服務器的配置被運維同學限制了，無法連到SCM服務器 (同時無法連接到外網，無法連接到很多內部網絡，比如LDAP，RADIUS等等）。腫麼辦???? (but one day, the server was limited its access to the internet, git repo and local LDAP , Radius service... what shall we do? )

如果用SVN的話，就得用SCP的方式，打包過去，然後修修改改，每次都要人肉來做，還出錯。(if using SVN, we have to copy the entire code folder to the target server, easy to make mistake and really painful for me )

現在換成了GIT，不用capistrano的話，直接在本地把 `git-patch` 上傳過去，然後 `git am` 就好。(now since we have migrated the SVN to GIT repo, it's very easy to achieve the same goal using 'git-patch' and 'git am' )

用了capistrano的話，用 `deploy_via :scp` 的 方式，我每次部署一行命令，自動搞定了。 ( and in capistrano, we just need to use 'deploy_via scp' to do the deployment job )

所以，老式的辦法，在某些新問題出現的時刻，不是那麼得心應手。業界流行的“最佳實踐”，在大部分情況下，還是“最佳實踐”的。 ^_^    ( the conclusion is:  best practices are always best in most cases. )

> —— 學習是王道！  ( keep STUDYING everyday! )

## capistrano的原理

裸代碼: 沒有數據庫的配置文件, 沒有服務器相關的配置文件,  也沒有壓縮各種css/js , 一般都是從git上直接clone下來的代碼。

### 傳統的部署步驟:

- ssh 登陸到服務器
- git pull
- restart command（重新啓動）


壞處是:

- 無法回滾,
- 每次都人肉, 特別麻煩.

> 雖然上面3個步驟看似很少, 但是需要一直盯着(比如, ssh 需要10秒, git pull 需要20秒, restart 也需要人肉輸入, 這些都是時間上的損耗, 而且人肉做重複性的事情, 無趣, 容易出錯。

### 合理的部署是:

編寫好一個配置文件之後, 運行代碼:  `$ cap deploy`  (一個命令) , 之後的所有事情,都不用人蔘與了。

### 結構:

有三個角色:部署人員的機器,目標服務器,代碼服務器(GIT)

TODO: 沒xuan的圖片

 ( 見譞的本本上的圖 )

### 每次部署, 都要做的事情:

- SSH 到目標服務器
- 把最新的代碼,上傳到目標服務器上。這時候的代碼是裸代碼，不能立刻部署, 因爲很多配置文件都沒有。

  我們不能把配置文件也放到github裏面跟蹤, 比如: `config/database.yml` , 每個人或服務器的數據庫的 mysql 密碼都不一樣。

- 以及其他的內容(上傳文件夾)

### 項目的回滾

回滾的方式有幾種:

- code roll back

  `git checkout ...`    這樣不好,很多時候我們無法保證代碼是沒有被修改的。 被修改之後, checkout操作會涉及到代碼合併的情況, 在某些 緊急 BUG 出現時, 會特別明顯.

- 使用capistrano,將上一次的release回滾,每一個release都用一個文件夾(裏面包含了完整的項目代碼, 包括裸代碼, 和 各種配置文件)。

###目錄結構

   - *20150310010954*, *20150319015536*  這種時間戳命名的文件夾，代碼某一個時間段部署的版本。

   - 有一個特殊的softlink(軟鏈接),*current*。

     web服務器的nginx配置,thin配置可以指向這個softlink,這樣就不需要每次都改nginx，thin 的配置文件了, 只需要把*current*這個softlink,重新指向不同的 release 文件夾就可以了。

   - shared文件夾中所保存的內容, 以及部分目錄結構, 是由 `config/deploy.rb` 這個配置文件決定的


capistrano部署web應用的文件結構是:

```
/opt/rails_app:
    current -> /opt/app/happystock_web/releases/20150518030114/
    releases/
        20150310010954
        20150319015536
        20150518030114
    shared/
        assets
        config
        files
        log
        pids
        public
        system
```


## 常見問題

###無法部署capistrano? Net::SSH::AuthenticationFailed: Authentication failed

對於capistrano 2.12.0,顯式指定`Gemfile`中`net-ssh` 的版本，例如：

```ruby
gem 'net-ssh', '2.7.0'
```
下面是一個完整的deploy.rb文件：

https://github.com/beijing-rubyist/bjrubyist/blob/master/config/deploy.rb
