# 编程风格

下面是Rails建议的风格：

## 绝对不要用缩写

例如：

- button 写成 btn
- manager 写成 mng , mgr
- implement 写成 impl

仅仅可以在无意义的变量上可以使用简单的字母，例如：

`for i in [1,2,3,4,5]`

## 表的主键一定是id

students 表的主键一定是id, 不是sid. 例如：

```
students
--------
id, name
```

teachers 表的主键一定是id, 不是tid. 例如：

```
teachers
-------
id, name
```

## 表的外键一定是 表名 + 下划线id

如果要实现多对多关系，那么就根据rails的管理，`表名_id`即可，例如：

```
lessons
--------
student_id  ( 该列对应 students表的id)
teacher_id  ( 该列对应 teachers表的id)
```



