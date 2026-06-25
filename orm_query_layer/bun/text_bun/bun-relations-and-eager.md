# Отношения: HasMany, BelongsTo, Eager Loading

## Определение моделей

```go
type User struct {
    ID      int64  `bun:",pk,autoincrement"`
    Name    string
    Orders  []Order `bun:"rel:has-many,join:id=user_id"`
}

type Order struct {
    ID     int64 `bun:",pk,autoincrement"`
    UserID int64
    Amount float64
    User   *User `bun:"rel:belongs-to,join:user_id=id"`
}
```
## Eager Loading (предзагрузка)
```go
var users []User
err := db.NewSelect().
    Model(&users).
    Relation("Orders").
    Scan(ctx)
```
Теперь `users[i].Orders` заполнены.

## Preload с условиями
```go
err := db.NewSelect().
    Model(&users).
    Relation("Orders", func(q *bun.SelectQuery) *bun.SelectQuery {
        return q.Where("amount > 100")
    }).
    Scan(ctx)
```
## Lazy Loading (по требованию)
```go
user := new(User)
db.NewSelect().Model(user).Where("id = ?", 1).Scan(ctx)

var orders []Order
db.NewSelect().
    Model(&orders).
    Where("user_id = ?", user.ID).
    Scan(ctx)
user.Orders = orders
```
## Вложенные отношения
```go
type User struct {
    ...
    Profile  *Profile   `bun:"rel:has-one,join:id=user_id"`
}
type Profile struct {
    ...
    Address  *Address   `bun:"rel:has-one,join:id=profile_id"`
}
```
Загрузка: `Relation("Profile.Address")`.

## Многие-ко-многим (M2M)
```go
type User struct {
    ...
    Roles []Role `bun:"m2m:user_roles,join:User=Role"`
}
type Role struct {
    ID   int64  `bun:",pk,autoincrement"`
    Name string
}
```
Автоматически обрабатывается промежуточная таблица `user_roles`.