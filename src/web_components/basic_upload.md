# 基本的上傳文件
1. 保證前端有個form表單，
並且這個表單， 是可以傳遞參數的。例如：

```
<%= form_for @article, url:article_path(@article), method: :patch,
  :html => {multipart: true} do |f| %>
  文章標題: <%= f.text_field :title %>
```

生成的form中，就會出現  enctype="multipart/form-data"
```
<form class="edit_article" id="edit_article_2"
enctype="multipart/form-data" action="/articles/2" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="_method" value="patch"><input type="hidden" name="authenticity_token" value="1Kv9e+Y7JGODBU2FphDHFNC3ALkH4/apaCbam+UBWLoOmUj9Lq0MyffSWXwyZvVHXwFWmEVAKlH7HCsEhFl5cw==">
```

2. 提交上面的表單後， 在rails日誌，就可以看到： 參數變了。
多了可以保存成文件的內容：
```
10:47:07 INFO:   Parameters: {"utf8"=>"✓",
 "authenticity_token"=>"1Kv9e+Y7JGODBU2FphDHFNC3ALkH4/apaCbam+UBWLoOmUj9Lq0MyffSWXwyZvVHXwFWmEVAKlH7HCsEhFl5cw==",
 "article"=>{"title"=>"mysql mysql? ",
 "content"=>"<p>使用mysql的同學，請直接下載附件的exe....</p>\r\n"},
 "attachment"=>#<ActionDispatch::Http::UploadedFile:0x007f7441dd8c60 @tempfile=#<Tempfile:/tmp/RackMultipart20161103-8186-48u1mt.png>,
 @original_filename="定位示例.png",
 @content_type="image/png",
 @headers="Content-Disposition: form-data; name=\"attachment\"; filename=\"\xE5\xAE\x9A\xE4\xBD\x8D\xE7\xA4\xBA\xE4\xBE\x8B.png\"\r\nContent-Type: image/png\r\n">,
 "commit"=>"提交",
 "id"=>"2"}
```

3. 知道rails小知識： Rails.root

```
$ bundle exec rails console
irb(main):008:0> Rails.root
=> #<Pathname:/workspace/graduate>
irb(main):009:0> Rails.root.join('public')
=> #<Pathname:/workspace/graduate/public>
irb(main):010:0> Rails.root.join('public', 'uploads')
=> #<Pathname:/workspace/graduate/public/uploads>
```


(我們要保證  /public/uploads 這個目錄存在）

所以，我們就可以寫上傳代碼了：

```
def update
    # ...
    File.open(Rails.root.join('public', 'uploads', params[:attachment].original_filename), 'wb') do |file|
        file.write(params[:attachment].read)
    end
    # redirect to ...
end

```

於是，我們就可以看到，/pulic/uploads 目錄下出現了新文件：

通過瀏覽器，就可以訪問了：
```
http://localhost:3000/uploads/%E5%AE%9A%E4%BD%8D%E7%A4%BA%E4%BE%8B.png
```

