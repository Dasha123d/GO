# Интеграция OpenTelemetry с Gin

## Middleware

```go
import "go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"

r := gin.Default()
r.Use(otelgin.Middleware("api-gateway"))
```
## Ручное создание спанов в обработчике
```go
r.GET("/users/:id", func(c *gin.Context) {
    span := trace.SpanFromContext(c.Request.Context())
    span.SetAttributes(attribute.String("user.id", c.Param("id")))

    // вызов БД с пробросом контекста
    db.QueryContext(c.Request.Context(), "SELECT ...")
})
```
## Передача контекста клиенту
При вызове внешнего HTTP:
```go
client := &http.Client{Transport: otelhttp.NewTransport(http.DefaultTransport)}
req, _ := http.NewRequestWithContext(ctx, "GET", "http://other-service/api", nil)
resp, err := client.Do(req)
```
## Метрики для HTTP
Можно добавить middleware для сбора метрик:
```go
r.Use(func(c *gin.Context) {
    start := time.Now()
    c.Next()
    requestCount.Add(c.Request.Context(), 1, metric.WithAttributes(...))
    requestDuration.Record(c.Request.Context(), time.Since(start).Milliseconds())
})
```