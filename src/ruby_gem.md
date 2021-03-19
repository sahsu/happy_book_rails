# Rubygem

rubygem 簡稱gem, 是Ruby的重要組成部分. 一個gem 就是一個ruby的組件。

在ruby中，一個gem對應是一個文件夾，默認是安裝在某個文件夾中，例如

```
/home/siwei/.rbenv/versions/2.6.4/lib/ruby/gems/2.6.0
```

rubygem的思想是：把所有用到的gem都統一放在網絡上，使用gem命令就可以自動下載，免去了手動安裝依賴的麻煩。

rubygems.org如圖：

![rubygems.org](images/rubygems.org.jpeg)

## gem的使用

以下例子都以 `rails`作爲gem的名字。

安裝gem包

```bash
$ gem install rails
```

卸載gem包

```bash
$ gem uninstall rails
```

列出本地已安裝的gem包
```bash
$ gem list --local rails
```

列出遠程的gem包

```bash
$ gem list --remote rails
```

查詢帶有某個關鍵字的gem包

```bash
$ gem list -r keyword
```

獲取gem幫助命令

```bash
$ gem help
```

獲取一些gem的事例命令

```bash
$ gem help example
```

查看gem 在本機的安裝路徑：

```
$ gem env

```

結果如：

```
RubyGems Environment:
  - RUBYGEMS VERSION: 3.0.3
  - RUBY VERSION: 2.6.4 (2019-08-28 patchlevel 104) [x86_64-linux]
  - INSTALLATION DIRECTORY: /home/siwei/.rbenv/versions/2.6.4/lib/ruby/gems/2.6.0
  - USER INSTALLATION DIRECTORY: /home/siwei/.gem/ruby/2.6.0
  - RUBY EXECUTABLE: /home/siwei/.rbenv/versions/2.6.4/bin/ruby
  - GIT EXECUTABLE: /usr/bin/git
  - EXECUTABLE DIRECTORY: /home/siwei/.rbenv/versions/2.6.4/bin
  - SPEC CACHE DIRECTORY: /home/siwei/.gem/specs
  - SYSTEM CONFIGURATION DIRECTORY: /home/siwei/.rbenv/versions/2.6.4/etc
  - RUBYGEMS PLATFORMS:

```

可以看出，安裝路徑爲：

```
  - INSTALLATION DIRECTORY: /home/siwei/.rbenv/versions/2.6.4/lib/ruby/gems/2.6.0
```

我們可以直接進入到該目錄，找到對應的gem, 然後查看對應的gem 的源代碼
