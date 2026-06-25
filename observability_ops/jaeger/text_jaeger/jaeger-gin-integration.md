# Интеграция Jaeger с Gin

## Middleware для Gin

```go
import (
    "go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

r := gin.Default()
r.Use(otelgin.Middleware("my-service"))
```
Теперь каждый HTTP-запрос создаёт спан с атрибутами (method, path, status_code).

Ручное создание спанов в обработчике
```go
r.GET("/users/:id", func(c *gin.Context) {
    span := trace.SpanFromContext(c.Request.Context())
    span.SetAttributes(attribute.String("user.id", c.Param("id")))

    // вызов базы
    ctx, dbSpan := tracer.Start(c.Request.Context(), "query-db")
    result := queryDB(ctx)
    dbSpan.End()

    c.JSON(200, result)
})
```
## Передача контекста в нижележащие слои
Передавайте `c.Request.Context()` в сервисы и репозитории.

## Фильтрация health-check запросов
```go
r.Use(otelgin.Middleware("my-service", otelgin.WithFilter(func(r *http.Request) bool {
    return r.URL.Path != "/health"
})))
```
## Конфигурация
```bash
go get go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin
```