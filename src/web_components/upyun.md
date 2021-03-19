# 圖片雲存儲 upyun

通常的web項目都需要圖片上傳功能．但是保存在本地的話(例如carrierwave)，轉移，
管理都非常不方便．

而且還需要設置各種訪問路徑．操作起來也可以忍受，但總感覺不是那麼利落．

所以雲存儲用來保存圖片非常合適．幾個最好的結果：

１．三重備份
２．有獨立的ＵＲＬ，　再也不擔心　相對路徑的問題了！
３．可以使用比較好的ＣＤＮ加速．服務器在香港返回一段html body, 而該body內容中的image　就可以在大陸內訪問．速度極快

同時，upyun可以保存的不僅僅是圖片，還可以是mp3等文件。

## 註冊

註冊很簡單。不說了。
需要注意的是： 你註冊完之後會得到bucket, operator, password

- bucket: 子空間。 你可以有多個bucket
- operator: 操作員id. 對於同一個bucket, 我們可以允許多個人操作
- password: 上面的操作員的id. 沒有密碼它做不了什麼。

有了上面三個信息，就可以上傳圖片了。

## 綁定域名

![例子](/images/upyun_bind_domain.png)

## 最簡單的例子
rails upyun上傳圖片的例子

核心是使用了rubygem:  upyun,  另外，記得要綁定好　二級域名（image.happysoft.cc)

```ruby
  require 'upyun'
  def create
    @upload = Upload.new(upload_params)
    @upload.save

    bucket = 'generic'
    operator = 'operator_id'
    password = 'your password'
    upload_file = params[:file]
    upyun = Upyun::Rest.new(bucket, operator, password)
    remote_file = "/image/#{@upload.id}/#{upload_file.original_filename}"
    response = upyun.put remote_file, upload_file.read
    render :json => {
      :response => response,
      :url => "http://image.happysoft.cc#{remote_file}"
    }
  end
```


## 把已有項目的本地已經存在的文件上傳到upyun

把下面代碼COPY到某個RB文件中並執行。

前提是你有了  bucket， operator,  operator password..

```ruby
# copy_all_files_to_upyun.rb
require 'upyun'
upyun = Upyun::Rest.new('your_bucket', 'operator_name', 'password')
# 本地路徑：  ./folder/1/2/3.jpg, 那麼，上傳到 遠程後，應該是：  /1/2/3.jpg, happyteam.b0.upaiyun.com/1/2/3.jpg
# 執行這個腳本的要求是：
# 1. cd 到 目標文件夾的同級目錄，例如：  /opt/app/yuehouse_web/public
# 2. 目標文件夾（例如： files ). 直接：
root ='/opt/app/yuehouse/shared/public'
folder = '/uploads'
files_and_folders = `find #{root + folder}`

files_and_folders.split("\n").select{ |entity|
  entity.include?(".")
}.each { |file|
  remote_file_path = file.sub(root, '')
  puts "=remote_file_path: #{remote_file_path.inspect}"
  puts "= local file: #{file.inspect}"
  puts upyun.put(remote_file_path, File.new(file))
}
```

## 與carrier wave 同時使用
參考：https://github.com/nowa/carrierwave-upyun

1. 在Gemfile中：
```ruby
gem 'carrierwave'
gem 'carrierwave-upyun'
```

2. 在config/initializers/carrierwave.rb中，增加：
```ruby
CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = "xxxxxx"
  config.upyun_password = 'xxxxxx'
  config.upyun_bucket = "my_bucket"
  config.upyun_bucket_host = "http://my_bucket.files.example.com"
end
```

3. 在對應的uploader中, 使用 `storage :upyun`：

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :upyun
end
```

## 把你的二級域名綁定到upyun上。

默認情況下，你的upyun上的圖片的訪問地址是：

`http://yuehouse.b0.upaiyun.com/hello.jpg`

非常難看對不對。我們可以把我們的二級域名綁定上去。具體請自行查詢文檔。

![二級域名綁定到upyun上](/images/upyun_bind_domain.png)


## 使用圖片的縮略圖

圖片的縮略圖特別重要。 比如，在列表頁中應該顯示縮略圖，在詳細頁中應該顯示大圖。
我們不應該關心這些事情，應該把它交給雲端去做。

在upyun中有兩種空間： 一種是圖片空間，一種是文件空間。只有前者支持縮略圖。

步驟：
1. 登陸upyun
2. 選擇目標圖片空間

3. 選擇 自定義版本

![例子](/images/upyun_menu.png)

4. 創建 縮略圖版本即可。

![例子](/images/upyun_create_thumbneil.png)

一個比較好的實踐，如圖所示，直接把縮略圖的名字以 aaxbb命名，例如圖中的'50x50',
訪問的時候，
```
原圖：   http://yourdomain.com/hello.jpg
縮略圖： http://yourdomain.com/hello.jpg!50x50
```
