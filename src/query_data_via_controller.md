# Model , View, Controller小結合

例子：

(前提：  數據庫中，有個lessons表， 表中，有若干數據）

小王， 打開瀏覽器， 希望看到所有的lessons.

步驟：
1. 小王發起：  get ：    /lessons    OK.   (服務器沒啓動）
2. 啓動服務器。  $ rails server   OK .   (少了action)
3. 實現index action

在服務器端, 我們要;

1.修改路由 `config/routes.rb`:

```
  resources :lessons

```

2.實現controller:


```
# app/controllers/lessons_controller.rb

class LessonsController < ApplicationControler
  def index
    # 用 @變量。 希望把 數據，從 controller， 傳到 view,
    @lessons = Lesson.all
  end
end
```

3.實現Model: Lesson

增加文件: `app/models/lesson.rb`

```
class Lesson < ActiveRecord::Base
end
```

4.實現view視圖： `app/views/lessons/index.html.erb`

```
<% @lessons.each do |lesson| %>
  <%= lesson.inspect %><br/>
<% end %>
```

5.於是運行 `$ rails server`, 在瀏覽器中, "localhost:3000/lessons", 就可以看到:
```
課程有：
#<Lesson id: 1, name: "課程一", student_id: "1", teacher_id: "1">
#<Lesson id: 2, name: "課程二", student_id: "1", teacher_id: "2">
#<Lesson id: 3, name: "課程三", student_id: "1", teacher_id: "3">
#<Lesson id: 4, name: "課程一", student_id: "2", teacher_id: "1">
```


6.細化它, 把它做成一個表格:

```
<table>
  <tr>
    <th>id</th>
    <th>Name</th>
    <th>student</th>
    <th>teacher</th>
  </tr>
<% @lessons.each do |lesson| %>
  <tr>
    <th><%= lesson.id %></th>
    <th><%= lesson.name %></th>
    <th><%= lesson.student_id %></th>
    <th><%= lesson.teacher_id %></th>
  </tr>
<% end %>
</table>
```

至此：  用戶發起請求， 到controller處理， 到 使用model讀取數據庫， 並且顯示。 就結束了。

# 引申：可以在任意controller中， 對任意表進行操作。

在books_controller中， 是不是隻能顯示books 的數據？

當然不是了。 上面的例子， books_controller,中， 顯示lessons .

我們還可以在這一個controller中，顯示3個表的數據

students, teachers, lessons 這三個表。都可以顯示。

# 我們也可以在model中定義任意方法

例如: 我可以在Lesson 中定義方法 foo

```
class Lesson < ActiveRecord::Base
  def self.foo
    "I am the foo method"
  end
end
```

然後在 任意的 view中調用:

```
<%= Lesson.foo %>
```

# 引申： 在view中，顯示級聯的內容

例如：  在 lessons表中，顯示： teacher,student的名字（不僅僅是id)

在view中：

原來：

```
    <th><%= lesson.student_id %></th>
    <th><%= lesson.teacher_id %></th>
```

改成：

```
    <th><%= lesson.student.inspect %></th>
    <th><%= lesson.teacher.name %></th>
```


(得益於 ActiveRecord 的 關聯。 直接就可以顯示了。)

如果用十年前的傳統技術的話， 你需要寫的這麼傻：

```
      <% temp = Student.where("id = ?", lesson.student_id).first %>
      <%= temp.inspect %>
```

所以，這就是ORM的威力。

# 排序

@books = Book.all   # 根據id 排序   ,  Book.order('id asc')
@books = Book.order('id desc')
@books = Book.order('id desc').limit(2)

# 有.all 與 沒有 .all 的區別

Book.all  # 立馬查數據庫。

@books = Book.order('id')  # 在controller中， 定義了查詢，但是不會馬上執行。（只在需要執行的時候執行）
....  我讓程序休息60秒。
<%= @books %>   # 這個時刻，是不得不執行的時候了。纔會執行

這個概念比較學究。不到優化的時候，用不上。 真要優化的話，這個概念也沒太大用。（幫不上太大忙）

但是大家要了解。你才能看得懂別人的代碼。

# 如果喪心病狂的話，希望回到15年前的編程方式。

所有代碼都寫到 erb中：
<%
   sons = Son.where('name like "%小%"')
%>
<% sons.each do |son| %>
  <%= son.name %>,
<% end %>

MVC: 最大的優點： 邏輯與 視圖 是分離的。
幾行代碼無所謂。 幾百行代碼 混一起， 你就傻眼了。

爲什麼 PHP是被所有人鄙視的語言：

# 查詢。

小王， 希望查看某些 名字中包含 xx 的 數據。

那麼， 他訪問的URL：  /books?name=一

就應該出現：  符合規則的數據。

## 獲得 請求中的參數。

params[:name]  # 推薦這個。
params['name']


發起一個 delete 請求：

```
<% @teachers.each do |teacher| %>
  <%= teacher.inspect%> ,
  <%= link_to "刪除", "/books/#{teacher.id}", :method => 'delete'%>
<br/>
<% end %>
```

