# Rails處理圖片上傳: CarrierWave

文件上傳可以說處處都有，我們在論壇中上傳附件，在註冊一個新用戶時上傳頭像，
編輯一個文章時要上傳圖片等等。

使用的基本的文件上傳，就可以達到我們想要的目的。
但是，基本的文件上傳，有一定的弊端：

1. 要把所有的上傳文件的 文件名， 服務器上的路徑， 要記錄下來。
2. 如果客戶端上傳的文件過大， 我們要可以縮放。
3. 要不要把文件名處理一下？（去掉漢字？去掉空格？用隨機字符串命名？）

爲了很方便的解決上面的需求， 我們就使用現成的輪子。  carrierwave
CarrierWave(https://github.com/carrierwaveuploader/carrierwave)
用來把客戶端上傳的圖片保存到服務器本地。它支持包括Rails, Sinatra 在內的多種框架。

注意: 以下僅支持 carrierwave  0.9.0 版本. 0.10.0 與 1.0 版本的用法略有變化, 請注意查看官方文檔

1.0 版本僅支持 ruby 2.0 與 rails 4 .

## 使用
```
in Gemfile:
gem 'carrierwave', '0.9.0'
```

```
$ rails generate uploader Logo
```
會新建一個這樣的model:
```ruby
# this will create file: app/uploaders/logo_uploader.rb
class AvatarUploader < Logo::Uploader::Base
  storage :file
end
````

同時, 務必記得 爲對應的model 增加 列:  logo

```ruby
# -*- encoding : utf-8 -*-
class AddLogoToMarketModules < ActiveRecord::Migration
  def change
    add_column :market_modules, :logo, :string, default: '', comment: '保存截圖路徑'
  end
end
```

in your model:

```ruby
class MarketModule < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
end
```

in your view:

```ruby
<%= f.file_field :logo %>
```

in controller :

```ruby
your_model = MarketModule.first
# do nothing....
your_model.create(params[:item])
# or
your_model.logo = params[:file]
your_model.save
```

# 對於 rails4, 只需要把 avatar 這個屬性加入到 參數白名單列表中:

```ruby
def item_params
    params.require(:item).permit(:market_id, :name, :level, :avatar)
end
```

用法：
```erb
<%= image_tag @item.logo.url, :style => 'height: 200px' %>
```


