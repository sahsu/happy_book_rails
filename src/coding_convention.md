# 編程風格

下面是Rails建議的風格：

## 絕對不要用縮寫

例如：

- button 寫成 btn
- manager 寫成 mng , mgr
- implement 寫成 impl

僅僅可以在無意義的變量上可以使用簡單的字母，例如：

`for i in [1,2,3,4,5]`

## 表的主鍵一定是id

students 表的主鍵一定是id, 不是sid. 例如：

```
students
--------
id, name
```

teachers 表的主鍵一定是id, 不是tid. 例如：

```
teachers
-------
id, name
```

## 表的外鍵一定是 表名 + 下劃線id

如果要實現多對多關係，那麼就根據rails的管理，`表名_id`即可，例如：

```
lessons
--------
student_id  ( 該列對應 students表的id)
teacher_id  ( 該列對應 teachers表的id)
```



