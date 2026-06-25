# Связи и Eager Loading

## Связи генерируются автоматически

Если в БД есть внешние ключи, SQLBoiler сгенерирует методы связей:

```go
// Для таблицы users -> orders (has many)
user.Orders()       // запрос связанных заказов
user.OrdersEager    // заполняется после eager-loading

// Для таблицы orders -> users (belongs to)
order.User()        // запрос родительского пользователя
order.UserEager     // заполняется после eager-loading
```
## Eager Loading
```go
users, err := models.Users(
    qm.Load("Orders"),
).All(ctx, db)

for _, u := range users {
    for _, o := range u.R.Orders {
        fmt.Println(u.Name, o.Amount)
    }
}
```
Вложенная загрузка:
```go
qm.Load("Orders.Product") // Product — связь заказа
```

## Кастомная eager load с условиями
```go
qm.Load(qm.Rels("Orders", qm.Where("amount > ?", 100)))
```

## Загрузка через Bind
```go
var users []struct {
    models.User `boil:",bind"`
    Orders      []models.Order `boil:",bind"`
}
err := models.Users(qm.Load("Orders")).Bind(ctx, db, &users)
```

## Связь Many-to-Many
Если есть промежуточная таблица, SQLBoiler генерирует методы для обоих концов, позволяя загружать `Tags` через `Posts` и наоборот.