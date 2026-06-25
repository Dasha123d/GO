# Быстрый старт: установка и первый запрос

## Установка

```bash
go get github.com/uptrace/bun
go get github.com/uptrace/bun/dialect/pgdialect
go get github.com/uptrace/bun/driver/pgdriver
```
Для SQLite3 / MySQL есть соответствующие диалекты.

## Подключение к БД
```go
import (
    "database/sql"
    "github.com/uptrace/bun"
    "github.com/uptrace/bun/dialect/pgdialect"
    "github.com/uptrace/bun/driver/pgdriver"
)

func main() {
    sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN("postgres://postgres:password@localhost:5432/test?sslmode=disable")))
    db := bun.NewDB(sqldb, pgdialect.New())
    defer db.Close()
}
```
## Модель
```go
type User struct {
    bun.BaseModel `bun:"table:users,alias:u"`
    ID            int64  `bun:",pk,autoincrement"`
    Name          string `bun:",notnull"`
    Email         string `bun:",unique"`
}
```
## Первый SELECT
```go
ctx := context.Background()
var users []User
err := db.NewSelect().Model(&users).Scan(ctx)
```
## Простой INSERT
```go
user := &User{Name: "Alice", Email: "alice@example.com"}
_, err := db.NewInsert().Model(user).Exec(ctx)
```
Теперь у вас настроенное подключение и выполнены базовые операции.