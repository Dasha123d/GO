# Пример: Отношения HasMany

```go
type User struct {
    ID     int64   `bun:",pk,autoincrement"`
    Orders []Order `bun:"rel:has-many,join:id=user_id"`
}
type Order struct {
    ID     int64 `bun:",pk,autoincrement"`
    UserID int64
    Amount float64
}

func main() {
    // ...
    var users []User
    db.NewSelect().Model(&users).Relation("Orders").Scan(ctx)
}
```