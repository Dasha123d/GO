# Построитель запросов: Query Mods

## Простые запросы

```go
users, err := models.Users(
    qm.Where("age > ?", 18),
    qm.OrderBy("name ASC"),
    qm.Limit(10),
    qm.Offset(0),
).All(ctx, db)
```
## Поиск по первичному ключу
```go
user, err := models.FindUser(ctx, db, id)
```
## Дополнительные Query Mods
* `qm.Select("id", "name")` — выборка конкретных столбцов
* `qm.From("users u")` — задание alias
* `qm.InnerJoin("orders o ON o.user_id = u.id")`
* `qm.WhereIn("name IN ?", "Alice", "Bob")`
* `qm.And("age > 18"), qm.Or("name = ?", "Bob")`
* `qm.GroupBy("age"), qm.Having("count(*) > 2")`
* `qm.With("cte_name", cteQuery)`

## Count и Exist
```go
count, err := models.Users(qm.Where("active = ?", true)).Count(ctx, db)
exists, err := models.Users(qm.Where("id = ?", id)).Exists(ctx, db)
```
## SQL напрямую
```go
var result []struct { Name string; Total int }
err := models.NewQuery(qm.Select("name, count(*) as total"), qm.From("users"), qm.GroupBy("name")).Bind(ctx, db, &result)
```
## Bind vs All
`All` возвращает слайс моделей, `Bind` — в произвольную структуру (например, агрегат).