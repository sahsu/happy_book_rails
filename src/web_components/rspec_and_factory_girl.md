###使用 RSpec 進行單元測試

1. 添加下面代碼到Gemfile:

```
# Gemfile:
gem 'rspec-rails', '~> 3.0.0'
```

然後運行：
```
$ bundle exec rails generate rspec:install
```
記得要把生成的.rspec 文件做個修改，刪掉
# .rspec file:

```
--color
# 不要有 : --warning, --require spec_helper
```

2. 下面是測試lib文件的一個例子： make sure your have this:

```
# config/application.rb
config.autoload_paths += %W(#{config.root}/lib)
```

```
require 'rails_helper' # 這句話極度重要.
require 'html_parser'  # it's not require 'lib/html_parser'
describe HtmlParser do

  it 'should parse html_content' do
    puts 'hihihi'
  end

end
```
