# Пример: Интеграция с Gin

Файл: `examples/gin-sqlboiler-integration.go`

```go
func main() {
    db, _ := sql.Open("postgres", "...")
    boil.SetDB(db)

    r := gin.Default()
    r.GET("/users", func(c *gin.Context) {
        users, _ := models.Users().All(c.Request.Context(), db)
        c.JSON(200, users)
    })
    r.Run(":8080")
}
```