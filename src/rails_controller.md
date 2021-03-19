# Rails Controller 簡介

1. Controller 是什麼？
2. Routes 是什麼？
3. Controller 與 Routes 基本 RESTful 請求的使用方式
4. RESTful 之外的請求如何添加。

## Controller 是什麼？

Controller 全稱是 Action Controller，是 MVC 中的"C"。

路由將請求轉發給 Controller 中對應的 Action，而後由 Controller 中的各個 Action 對相應請求進行處理並作出反饋。

這些 Action 處理請求中的參數，或將其儲存至 Model 中，或根據不同的請求和參數組織 Model 中的數據，提供給 View 顯示給用戶。

## Routes 是什麼？

上面說到，路由將會把請求轉發給 Controller 中對應的 Action。

另一方面，我們在 View 中使用路由 Helper 輔助方法來生成路徑和 URL，這樣就能保證我們的 URL 一定有對應的 Action，避免 NoMethodError 找不到對應方法的錯誤。

## RESTful Routes 與 Controller Action 的對應關係

初學 Rails，大家都會告訴你：Rails 是一個強調“習慣優先配置”的框架。這裏會談到的 RESTful 設計風格就是這一點的重要體現。

如果你參考過一些現有的 Rails 項目，你就會在 routes.rb 文件中看到很多類似下面的代碼：

```rails
Rails.application.routes.draw do
  resources :products
end
```

然後 Rails 會按照 RESTful 對資源的定義，自動生成對一個資源(products)最基礎的 CRUD（即增刪改查）操作對應的路由。

在終端中運行命令：

```bash
$ bundle exec rake routes
```

這個命令會打印出當前項目所有路由。


|      Prefix|Verb  |URI Pattern       |Helper                      |Controller#Action|
|------------|------|------------------|----------------------------|-----------------|
|    products|GET   |/products         |products_path               |products#index   |
|            |POST  |/products         |products_path               |products#create  |
| new_product|GET   |/products/new     |new_product_path            |products#new     |
|edit_product|GET   |/products/:id/edit|edit_products_path(@product)|products#edit    |
|     product|GET   |/products/:id     |product_path(@product)      |products#show    |
|            |PATCH |/products/:id     |product_path(@product)      |products#update  |
|            |PUT   |/products/:id     |product_path(@product)      |products#update  |
|            |DELETE|/products/:id     |product_path(@product)      |products#destroy |

其中，所有 GET 請求對應的 Action 都有相應視圖。


