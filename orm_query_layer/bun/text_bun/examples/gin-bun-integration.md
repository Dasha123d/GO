# Пример: Интеграция bun с Gin

```go
func main() {
    db := bun.NewDB(...)
    r := gin.Default()
    r.Use(func(c *gin.Context) {
        c.Set("db", db)
    })
    r.GET("/users", func(c *gin.Context) {
        db := c.MustGet("db").(*bun.DB)
        var users []User
        db.NewSelect().Model(&users).Scan(c.Request.Context())
        c.JSON(200, users)
    })
    r.Run(":8080")
}
```