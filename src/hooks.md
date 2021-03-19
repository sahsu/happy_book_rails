# 鉤子方法 hook method（回調函數 callback）

我們在編程時，會發現有很多方法。

有幾種方法，是比較特殊的方法。 它們存在的意義，往往跟過程相關。

## 實現模式 implementation pattern

找女人約會， 要記得買花， 這是模式
跟男朋友約會， 要記得打扮，也是妹子的模式。
陌生人頭一次見面，要握手，這是模式。
就算不認識對方，但是也要給對方留餘地， 往往會說： 久仰！ 幸會！

我們在編程的時候， 也要用到模式。 例如：

一個person，  能出生， 就一定會死亡。
```

class Person
  def born
  end

  def dead
  end
end
```

再比如：

```
class Money

  def get
  end

  def spend
  end

end
```

上面的方法， 是有對應的關係的，這個對應關係， 就是一種模式。

所以，好的代碼，看起來應該是：

```
class MyModel

  def before_save
  end

  def save
  end

  def after_save
  end
end

```

我們接下來看這個代碼：

```

public class MysqlDemo {
    public static void main(String[] args) throws Exception {

				// 這裏就是 before_execute();
        Connection conn = null;
        String sql;
        String url = "jdbc:mysql://localhost:3306/javademo?"
                + "user=root&password=root&useUnicode=true&characterEncoding=UTF8";

				Class.forName("com.mysql.jdbc.Driver");// 動態加載mysql驅動

				System.out.println("成功加載MySQL驅動程序");
				// 一個Connection代表一個數據庫連接
				conn = DriverManager.getConnection(url);
				// Statement裏面帶有很多方法，比如executeUpdate可以實現插入，更新和刪除等
				Statement stmt = conn.createStatement();

				// 這裏就是 execute()
				sql = "create table student(NO char(20),name varchar(20),primary key(NO))";
				int result = stmt.executeUpdate(sql);// executeUpdate語句會返回一個受影響的行數，如果返回-1就沒有成功
				if (result != -1) {
						System.out.println("創建數據表成功");
						sql = "insert into student(NO,name) values('2012001','陶偉基')";
						result = stmt.executeUpdate(sql);
						sql = "insert into student(NO,name) values('2012002','周小俊')";
						result = stmt.executeUpdate(sql);
						sql = "select * from student";
						ResultSet rs = stmt.executeQuery(sql);// executeQuery會返回結果的集合，否則返回空值
						System.out.println("學號\t姓名");
						while (rs.next()) {
								System.out
												.println(rs.getString(1) + "\t" + rs.getString(2));// 入如果返回的是int類型可以用getInt()
						}
				}

				// after_execute();
				conn.close();

    }

}

```

所以，上面的代碼就是三部分組成：

before_execute,
execute
after_execute

一旦寫的代碼多了，會發現，如果這個方法，(execute) 看成是一個東西的話，我們一把它從腦海裏，拎出來，就會發現，
會出來三個：  before,  execute, after..
就好像 有鉤子，勾在 execute這個核心方法上一樣。

所以，我們管， before_execute, after_execute, 這樣的方法，叫做： 鉤子方法  (hook method)

我們寫代碼，寫了 before， 就一定要寫after. 哪怕，after中，是空代碼，也要寫出來。


## 回調函數。 callbacks.

我們要發起一個上傳圖片的http請求。 那麼，這個請求，會有3種不同的後果：

1. success.
2. error
3. processing.

所以，我們往往會這樣寫：（使用了最常見的javascript代碼）

```
$.ajax({
  url: '../wp-content/themes/bsj/php/validate.php',
  type: 'post',
  a: 1,
  success: function(){
    alert('success!');
  },
  error: function(){
    alert('error!');
  },
	processing: function(){
    alert('處理當中。。。')  // 這裏用於： 顯示上傳進度。
	}
});
```

## 事件(events) 和 通知。

場景：

```
$('form').submit()

$('button').click(function(){
  alert('hi!')
})

```

## rails中的 hooks method.

controller中：


```
  def edit
    @article = Article.find params[:id]
  end

  def update
    @article = Article.find params[:id]
    redirect_to articles_path
  end

  def destroy
    @article = Article.find params[:id]
    @article.destroy

    redirect_to articles_path
  end
```

上面3行代碼，都是一樣的：

```
    @article = Article.find params[:id]
```

所以， rails 提供了 hook method:  `before_filter`


```

class XXAction
  before_action :get_article, :only => [:edit, :update, :destroy]

  def edit
  end

  def update
    redirect_to articles_path
  end

  def destroy
    @article.destroy

    redirect_to articles_path
  end

  private
  def get_article
    @article = Article.find params[:id]
  end

end
```

### ActiveRecord 中的 hooks.

```
class Count < ActiveRecord::Base

  before_save :say_hi

  # 這個方法是隱形的。 定義於： ActiveRecord::Base 中。
  def save
  end

  def say_hi
    puts "=== hihihi"
  end
end
```
