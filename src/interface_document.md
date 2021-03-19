# 接口

注： 接口(interface) 有若干概念：

1. 移動開發時， app 向服務器端請求數據， 服務器端需要有接口。我們講的就是這個。
2. 編程語言的特性。例如：在java中， 需要有interface. 每個interface都要有implementation.
不僅僅在java, object c 裏面，也是一樣。

這裏說的接口，就是：設計模式中的接口。 我們不講它。 也不建議使用java/oc 這樣的語言。
編程語言中的interface, 雖然比繼承( extend, inherit ）功能高級， 但是，不如mix-in好用。

## 概念

是兩個不同系統之間， 傳遞數據的出口 或者 入口。

財務系統，  跟 員工系統，

兩個系統之間， 傳遞數據的出入口， 就是接口。

接口可以在 任意一個系統上。

例如：  財務系統有個接口，  員工系統來讀取。  反之亦然。


可以有讀數據的接口， 也可以有寫數據的接口。

例如：  員工系統， 要顯示財務系統的 相關數據：    接口就是隻讀的。
                   要修改財務系統的 數據， 接口就是 用來寫的。


接口跟語言無關。
例如：  字符串，  我可以用java處理，也可以用php, .net, c來處理。

所以字符串 是接口中內容的基礎。

## 歷史

早期的接口，傳遞的內容， 都是 XML：

```
<xml>
    <message>你好阿 </message>
</xml>
```
後來大家發現，XML 特別複雜。

```
<xml>
    <student>
      <name>小王</name>
      <sex>Male</sex>
      <age>18</age>
      <birthday>1998-10-10</birthday>
    </student>
</xml>
```

字數多。 層級多。

所以，現在，大家都用json.

## JSON: (另見一章： json 入門）

```
{
  student: {
    name: '小王',
    sex: 'Male',
    age: '18',
    birthday: '1998-10-10'
  }
}

```
體積減少 30%， 而且特別清晰。


## Rails中寫接口

## 只讀的：


## 寫數據庫的。

## JSON入門

## 知道接口與 GUI的區別。

接口： 是給設備用的。
GUI (Graphic User Interface)： 是給人用的。

所以，在rails中：  有7個action:
new, edit ... 頁面，因爲RAISL生成的是 GUI.

對於接口： 是沒有必要有 new, edit 這些內容。

## 使用PostMan來進行對接口的測試。
（見工具一章）

========================================================

# 接口文檔

通過後臺提供的接口，訪問服務器端的數據。

## 實現步驟
### 1.統一入口文件
```

    siwei.tech/interface/cases/all_cases

爲了更好的保護、維護我們的代碼，通常將接口文件寫在項目的：./controllers/interface/目錄下。
注：在我們的項目中，android/ios訪問同一個接口，pc端直接讀取後臺數據庫。
```
### 2.接口的實現
```
class Interface::CasesController < ActionController::Base
  def all_cases
    all_cases = Case.all.map  do |the_case|
    { :id => the_case.id,
      :name => the_case.name,
      :desc => the_case.desc,
      :site => the_case.site,
      :layout_name => the_case.layout_name,
      :total_area => the_case.total_area,
      :package_name => the_case.package_name,
      :cover => SERVER + the_case.cover_url,
      :style => the_case.style,
      :layout => SERVER + the_case.layout.to_s,
    }
  end
    render :json => { :success =>true, :result => all_cases}
  end
end
```
### 3.接口路由的配置
```
namespace :interface do
  resources :init, :only => [] do
    collection do
      get :index
      get :home_sliders
    end
  end

  resources :cases, :only => [] do
    collection do
      get :all_cases
      get :all_styles
      get :select_cases_by_style
      get :select_details_by_id
    end
  end
end
```
### 4.最終接口的調用
```
http://域名/interface/cases/all_cases
```
### 5.返回的結果
```
{
  success: true,
    result: [
      {
        id: 19,
        name: "混搭風，見你所見的情懷",
        desc: "世界那麼大，也走過很多東方，領略過地中海長長的海岸線，撫摸過彷彿被水沖刷過的白牆，淺嘗過爬藤散發出的陽光芬芳；記憶中亦或是夢裏，鋪滿着家鄉的味道。 ",
        site: "北京",
        layout_name: "二室一廳一衛一廚",
        total_area: "110",
        package_name: "老房新裝包",
        cover: "http://____2_.jpg",
        style: "混搭",
        layout: "http://__.jpg"
      },
      {
        id: 20,
        name: "時尚是經典的輪迴",
        desc: "17世紀愛麗捨宮在巴黎香榭麗舍大街落成，同時期一種思潮古典主義從巴黎席捲歐洲；18世紀許多新材料和工藝的問世，新古典也應運而生， 無論是古典主義還是新古典，都是向古代希臘羅馬藝術的高度認同。今天古典主義、新古典依舊散發它特有光環，演繹着當下的時尚。時尚其實就是一場經典的輪迴。",
        site: "北京",
        layout_name: "二室一廳二衛一廚",
        total_area: "106",
        package_name: "老房新裝包",
        cover: "http://__PS.jpg",
        style: "簡歐",
        layout: "http://20/05.jpg"
      }
   ]
}
```



作業

1. 寫個 顯示 所有的 books的接口
2. 寫個 創建(create)/更新(update) 某個 book的接口。
3. 新建一個git repo. 放到github 上去。
