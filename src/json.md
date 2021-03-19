# JSON

官方網站： http://www.json.org/

javascript object notation.  咱們知道它是用javascript 的結構，來表示數據結構就可以了。

你就認爲 js 對象，就是一個 {} Hash 就可以了。

## 普通的對象

小王， 年齡18， 性別男，

```
{
   "name": "小王",
   "age": "18",
   "sex": "male"
}
```

格式： 跟javascript 的格式 “基本一樣“。

1. "key": "value"
2. 每個不同的key-value之間，使用 "," 來連接。
3. 不能加註釋。
4. 只能用雙引號。不能用單引號。
5. 數據類型很少很少。

## 數據類型

### String

{
  "name": "小王"
}

上面的"小王" 就是字符串。

### 數字  (integer, float )

{
  "height": 1.86,
  "weight": 80
}

上面的  1.86 是float,  80 是integer, 總之，通稱： 數字。 （不區分 double 這樣的類型）

### 數組

{
  "name": "China",
  "provinces": ["Beijing", "Shanghai", "Guangzhou"]
}

上面的 provinces 的值就是數組

### Hash


```
{
  "name" : "小王",
  "parents": {
    "mother": {
      "name" : "王媽媽",
      "age": 46
    },
    "father" : {
      "name" : "王爸爸",
      "age": 46
    }
  }
}
```

上面的 parents , 就是一個大hash,  該hash 的key ：  mother, father
mother中也有兩個key.  name/age.


### 最後來個混合

例如，我的一個接口， 要： 查詢所有的books.
那麼，查回來的結果如下：

```
{
  "result": [
    {
      "title": "馬克思理論"
    },
    {
      "title": "恩格斯理論"
    }
  ]
}
```


## JSON用在哪裏？

用在接口端。

誰來使用接口的數據呢？  手機app, 或者 H5的單頁應用。

傳統的web開發(php, jsp, asp)，不用接口。  例如：

```
<p><%= 1 + 1 %></p>
```
會被編譯成：
```
<p>2</p>
```


## 如何解析JSON？





