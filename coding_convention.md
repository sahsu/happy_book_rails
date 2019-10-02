# 编程风格

绝对不要用缩写!   例如：

button 写成 btn,
manager 写成 mng  , mgr,
implement 写成  impl

# 不要用奇怪的命名.

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

如果要实现多对多关系，那么就根据rails的管理，`表名_id`即可，例如：

```
lessons
--------
student_id
teacher_id
```
