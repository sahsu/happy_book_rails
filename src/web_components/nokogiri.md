# 解析XML/HTML： nokogiri  (html parser)

我們使用nokogiri這個rubygem來解析HTML/XML的內容。

nokogiri可以非常方便的讓我們解析HTML,XML內容，它支持XPATH 和 CSS selector
這樣的方式來找到目標元素(element/node)

## 安裝

參考官方網站，對於Ubuntu,需要安裝好 libxml2, libxslt 這兩個組件：

```bash
$ apt-get install libxml2 libxslt
```

然後就可以：
```bash
$ gem install nokogiri
```

## 解析

可以從文件，字符串，URL等來解析。靠的是這兩個方法 `Nokogiri::HTML`, `Nokogiri::XML`：

- 讀取字符串：
```ruby
html_doc = Nokogiri::HTML("<html><body><h1>Mr. Belvedere Fan Club</h1></body></html>")
xml_doc  = Nokogiri::XML("<root><aliens><alien><name>Alf</name></alien></aliens></root>")
```

- 讀取文件：

```ruby
f = File.open("blossom.xml")
doc = Nokogiri::XML(f)
f.close
```

- 讀取URL
```ruby
require 'open-uri'
doc = Nokogiri::HTML(open("http://www.threescompany.com/"))
```

## 尋找節點

可以使用XPATH 以及 CSS selector 來搜索：
例如，給定一個XML：

```xml
<books>
  <book>
    <title>Stars</title>
  </book>
  <book>
    <title>Moon</title>
  </book>
</books>
```

xpath:
```ruby
@doc.xpath("//title")
```

css:
```ruby
@doc.css("book title")
```

## 修改節點內容

```ruby
title = @doc.css("book title").firsto
title.content = 'new title'
puts @doc.to_html

# =>
...
  <title>new title</title>
...
```

## 修改節點的結構

```ruby
first_title = @doc.at_css('title')
second_book = @doc.css('book').last

# 可以把第一個title放到第二個book中
first_title.parent = second_book

# 也可以隨意擺放。
second_book.add_next_sibling(first_title)

# 也可以修改對應的class
first_title.name = 'h2'
first_title['class']='red_color'
puts @doc.to_html
# => <h2 class='red_color'>...</h2>

# 也可以新建一個node
third_book = Nokogiri::XML::Node.new 'book', @doc
third_book.content = 'I am the third book'
second_book.add_next_sibling third_book
puts @doc.to_html
# =>
...
<books>
  ...
  <book>I am the third book</book>
</books>
```

還有更多的功能，例如爲多個node增加wrapper, 爲整個文檔增加<?xml.. ?> 這樣的字符串等等。
請大家查看API。

## 一個例子, ruby 解析 html頁面.

```ruby
require 'httparty'
require 'nokogiri'

url ='https://github.com/rdoc/rdoc/issues/190'
response = HTTParty.get  url
puts response.body
doc = Nokogiri::HTML response.body
doc.css('.js-issue-title').each do  |node|
  puts node.content
end
```

## 注意

當目標HTML文件內容過大時， 試試XPATH會有更好的性能哦

我的一個方法，原來使用了 `.ancestors().first` ,   運行一次3 分鐘。

後來改成了 `xpath('./ancestor::table[1]')` , 運行一次 5秒。

節省了大約96%的時間！

```
Finished in 5.81 seconds
3 examples, 0 failures
```
