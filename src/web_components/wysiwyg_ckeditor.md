# 所見即所得編輯器  WYSIWYG editor

ckeditor 是目前最流行的所見即所得編輯器。它可以爲用戶提供極大地方便。

注意： 不要使用 "ckeditor_rails" 這個gem.

![ckeditor例子](/images/ckeditor.png)

1。 安裝 imagemagick

Linux下：

```bash
$ sudo apt-get install imagemagick
```

2. 編輯： Gemfile

```ruby
gem 'carrierwave'
gem 'mini_magick'
gem 'ckeditor'
```

3. 在使用rails的前提下：

```bash
$ rails generate ckeditor:install --orm=active_record --backend=carrierwave
```

4. 在application.js 或者 application.js.erb文件中：

```
//= require ckeditor/init
```

5.
```
$ rake db:migrate
```

6.

```ruby
<%= form_for ... do |f| %>
  <%= f.cktext_area :introduction %>
<% end %>
```

注意, 做完上面幾步, ckeditor是出來了,但是還沒有 "上傳文件" 這個功能. 所以還需要解決這個問題,參考(
http://stackoverflow.com/questions/20010675/no-image-upload-capability-in-ui-with-ckeditor-gem-paperclip-rails-4 )

7.  add this file to : app/assets/javascripts/ckeditor/config.js

```javascript
/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  // Define changes to default configuration here. For example:
  // config.language = 'zh-CN';
  config.height='600px';
  // config.uiColor = '#AADC6E';

  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";

  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token, csrf_param, meta,
        metas = document.getElementsByTagName('meta'),
        params = new Object();

    for ( var i = 0 ; i < metas.length ; i++ ){
      meta = metas[i];

      switch(meta.name) {
        case "csrf-token":
          csrf_token = meta.content;
          break;
        case "csrf-param":
          csrf_param = meta.content;
          break;
        default:
          continue;
      }
    }

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }

    return params;
  };

  config.addQueryString = function( url, params ){
    var queryString = [];

    if ( !params ) {
      return url;
    } else {
      for ( var i in params )
        queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
    }

    return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
  };

  // Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
  CKEDITOR.on( 'dialogDefinition', function( ev ){
    // Take the dialog name and its definition from the event data.
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;
    var content, upload;

    if (CKEDITOR.tools.indexOf(['link', 'image', 'attachment', 'flash'], dialogName) > -1) {
      content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
      upload = (content == null ? null : content.get('upload'));

      if (upload && upload.filebrowser && upload.filebrowser['params'] === undefined) {
        upload.filebrowser['params'] = config.filebrowserParams();
        upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
      }
    }
  });
};
```

8. 默認的編輯頁面的高度是200px, 需要我們做一些定製，例如增加高度，使用漢語：

```
$ mkdir app/assets/javascripts/ckeditor/ -p
```

在上面的目錄下，新增config.js:
```javascript
CKEDITOR.editorConfig = function( config ) {
  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';
  config.language = 'zh-CN';
  config.height='600px'
};
```

## 注意1: ckeditor的語言包特別大。

在rails中使用它時，務必指定它的語言，並且編譯 assets,
否則每次需要加載幾十個文件。


## 注意2：ckeditor中，只能輸入inline style,

之前寫過  ckeditor 會默認吃掉inline style (http://siwei.me/blog/posts/ckeditor-inline-style-preserve-inline-style-in-ckeditor)

其實, ckeditor, 還會吃掉:  <script> ,  <style>,  以及所有的 '<' 標籤. (把它轉換成:  &lt; )

爲什麼呢?  這是考慮到 安全性.

設想一個場景:  某個 CSDN 的 BLOG 用戶,發佈了一個博客文章, 裏面嵌入了一段js hacker的代碼:

<script >  some_dirty_code ... </script>

那麼就會對所有訪問這個頁面的人造成損失.

所以, CKEDITOR , 以及其他好多編輯器,都是默認輸入的內容是有限制性的.

或者，使用：

```javascript
// in your ckeditor's config.js
config.allowedContent = true;
```

