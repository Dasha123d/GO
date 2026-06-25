# Пример: Интеграция с Gin

Файл: `examples/gin-sqlc-integration.md`

```go
func main() {
    conn, _ := pgx.Connect(ctx, dsn)
    db := generated.New(conn)

    r := gin.Default()
    r.GET("/users", func(c *gin.Context) {
        users, _ := db.ListUsers(c.Request.Context())
        c.JSON(200, users)
    })
    r.POST("/users", func(c *gin.Context) {
        var params generated.CreateUserParams
        c.ShouldBindJSON(&params)
        user, _ := db.CreateUser(c.Request.Context(), params)
        c.JSON(201, user)
    })
    r.Run(":8080")
}
```