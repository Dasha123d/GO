# Пример: INSERT с RETURNING (PostgreSQL)

Файл: `examples/insert-with-returning.go`

```go
package main

import (
    "fmt"
    sq "github.com/Masterminds/squirrel"
)

func main() {
    psql := sq.StatementBuilder.PlaceholderFormat(sq.Dollar)

    sql, args, err := psql.
        Insert("users").
        Columns("name", "email").
        Values("Alice", "alice@example.com").
        Suffix("RETURNING id").
        ToSql()

    if err != nil {
        panic(err)
    }
    fmt.Println(sql)
    fmt.Println(args)
}
```