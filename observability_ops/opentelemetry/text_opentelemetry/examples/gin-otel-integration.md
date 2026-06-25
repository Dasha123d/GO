# Пример: Полная интеграция Gin + OTel

Файл: `examples/gin-otel-integration.go`

```go
r := gin.Default()
r.Use(otelgin.Middleware("api-gateway"))
r.GET("/", handler)
```