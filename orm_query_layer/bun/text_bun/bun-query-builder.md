# Построитель запросов: SELECT, INSERT, UPDATE, DELETE

## SELECT

```go
var users []User
err := db.NewSelect().
    Model(&users).
    Where("name LIKE ?", "%A%").
    Order("id ASC").
    Limit(10).
    Scan(ctx)
```
## INSERT
```go
user := &User{Name: "Bob", Email: "bob@example.com"}
_, err := db.NewInsert().
    Model(user).
    Returning("id").
    Exec(ctx)
// user.ID теперь заполнен
```

## UPDATE
```go
_, err := db.NewUpdate().
    Model(&User{ID: 1, Name: "Updated"}).
    Set("email = ?", "new@example.com").
    WherePK().
    Exec(ctx)
```

## DELETE
```go
_, err := db.NewDelete().
    Model((*User)(nil)).
    Where("id = ?", 1).
    Exec(ctx)
```

## Сканирование одного значения
```go
var name string
err := db.NewSelect().
    ColumnExpr("name").
    Model((*User)(nil)).
    Where("id = ?", 1).
    Scan(ctx, &name)
```

## Агрегатные функции
```go
var count int
err := db.NewSelect().
    Model((*User)(nil)).
    ColumnExpr("COUNT(*)").
    Scan(ctx, &count)
```

## Сырой SQL
Если возможностей билдера не хватает, можно выполнить сырой запрос:
```go
_, err := db.ExecContext(ctx, "TRUNCATE TABLE users")
```