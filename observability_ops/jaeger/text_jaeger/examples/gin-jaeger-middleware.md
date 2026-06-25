# Пример: Middleware для Gin

Файл: `examples/gin-jaeger-middleware.go`

```go
func main() {
    tp, _ := initTracer()
    defer tp.Shutdown(context.Background())

    r := gin.Default()
    r.Use(otelgin.Middleware("api-gateway"))
    r.GET("/data", handler)
    r.Run(":8080")
}
```