# Пример: Интеграция с Gin

Файл: `examples/gin-ent-integration.go`

```go
func main() {
    client, _ := ent.Open("postgres", "...")
    r := gin.Default()
    r.Use(func(c *gin.Context) {
        c.Set("client", client)
    })
    r.GET("/users", func(c *gin.Context) {
        cli := c.MustGet("client").(*ent.Client)
        users, _ := cli.User.Query().All(c.Request.Context())
        c.JSON(200, users)
    })
    r.Run(":8080")
}
```