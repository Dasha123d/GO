# Пример: Интеграция GORM с Gin

Файл: `examples/gin-gorm-integration.go`

```go
func main() {
    dsn := "host=localhost user=test password=test dbname=test"
    db, _ := gorm.Open(postgres.Open(dsn), &gorm.Config{})

    r := gin.Default()
    r.Use(func(c *gin.Context) {
        c.Set("db", db)
        c.Next()
    })

    r.GET("/users", func(c *gin.Context) {
        db := c.MustGet("db").(*gorm.DB)
        var users []User
        db.Find(&users)
        c.JSON(200, users)
    })
    r.Run(":8080")
}
```
Проверка: `curl http://localhost:8080/users`