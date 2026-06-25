# Интеграция Prometheus с Gin

## Middleware для HTTP-метрик

```go
import (
    "github.com/gin-gonic/gin"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    httpRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{Name: "http_requests_total", Help: "Total HTTP requests"},
        []string{"method", "path", "status"},
    )
    httpRequestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "HTTP request duration",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "path", "status"},
    )
)

func init() {
    prometheus.MustRegister(httpRequestsTotal, httpRequestDuration)
}

func PrometheusMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        method := c.Request.Method
        path := c.FullPath() // или c.Request.URL.Path, если роуты динамические
        status := strconv.Itoa(c.Writer.Status())

        httpRequestsTotal.WithLabelValues(method, path, status).Inc()
        httpRequestDuration.WithLabelValues(method, path, status).Observe(time.Since(start).Seconds())
    }
}

func main() {
    r := gin.Default()
    r.Use(PrometheusMiddleware())

    r.GET("/metrics", gin.WrapH(promhttp.Handler()))
    r.GET("/", func(c *gin.Context) {
        c.String(200, "OK")
    })
    r.Run(":8080")
}
```
## Замечание о пути
Используйте `c.FullPath()`, чтобы не создавать метки для каждого уникального URL с параметрами (`/users/123` → `/users/:id`).

## Экспорт метрик Gin
Существует готовая библиотека `github.com/zsais/go-gin-prometheus`, но проще реализовать свою, как показано.