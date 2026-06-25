# Пример: Простой SELECT с фильтрацией

Файл: `examples/basic-select.go`

```go
package main

import (
    "fmt"
    sq "github.com/Masterminds/squirrel"
)

func main() {
    psql := sq.StatementBuilder.PlaceholderFormat(sq.Dollar)

    sql, args, err := psql.
        Select("id", "name", "email").
        From("users").
        Where(sq.Eq{"active": true}).
        OrderBy("name ASC").
        Limit(10).
        ToSql()

    if err != nil {
        panic(err)
    }
    fmt.Println(sql)
    fmt.Println(args)
}
```