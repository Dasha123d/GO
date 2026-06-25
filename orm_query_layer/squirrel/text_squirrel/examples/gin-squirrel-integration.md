# Пример: Интеграция с Gin

Файл: `examples/gin-squirrel-integration.go`

```go
package main

import (
    "database/sql"
    "net/http"

    "github.com/gin-gonic/gin"
    sq "github.com/Masterminds/squirrel"
    _ "github.com/lib/pq"
)

var psql = sq.StatementBuilder.PlaceholderFormat(sq.Dollar)

type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}

func main() {
    db, _ := sql.Open("postgres", "host=localhost ...")
    r := gin.Default()

    r.GET("/users", func(c *gin.Context) {
        sql, args, _ := psql.Select("id", "name", "email").
            From("users").
            OrderBy("name").
            ToSql()

        rows, _ := db.QueryContext(c.Request.Context(), sql, args...)
        defer rows.Close()

        var users []User
        for rows.Next() {
            var u User
            rows.Scan(&u.ID, &u.Name, &u.Email)
            users = append(users, u)
        }
        c.JSON(http.StatusOK, users)
    })

    r.Run(":8080")
}
```
Проверка: `curl http://localhost:8080/users`