# Пример: Полный CRUD

Файл: `examples/basic-crud.go`

```go
package main

import (
    "context"
    "database/sql"
    "github.com/uptrace/bun"
    "github.com/uptrace/bun/dialect/pgdialect"
    "github.com/uptrace/bun/driver/pgdriver"
)

type User struct {
    bun.BaseModel `bun:"table:users,alias:u"`
    ID            int64  `bun:",pk,autoincrement"`
    Name          string
}

func main() {
    sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN("postgres://...?sslmode=disable")))
    db := bun.NewDB(sqldb, pgdialect.New())
    ctx := context.Background()

    // Insert
    user := &User{Name: "Alice"}
    db.NewInsert().Model(user).Exec(ctx)

    // Select
    var users []User
    db.NewSelect().Model(&users).Scan(ctx)

    // Update
    db.NewUpdate().Model(user).Set("name = ?", "Alice Updated").WherePK().Exec(ctx)

    // Delete
    db.NewDelete().Model(user).WherePK().Exec(ctx)
}
```