# Пример: Middleware Zap для Gin

Файл: `examples/gin-zap-middleware.go`

```go
package main

import (
    "time"
    "github.com/gin-gonic/gin"
    "go.uber.org/zap"
)

func ZapLoggerMiddleware(logger *zap.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        logger.Info("запрос",
            zap.String("method", c.Request.Method),
            zap.String("path", c.Request.URL.Path),
            zap.Int("status", c.Writer.Status()),
            zap.Duration("latency", time.Since(start)),
        )
    }
}

func main() {
    logger, _ := zap.NewProduction()
    defer logger.Sync()

    r := gin.New()
    r.Use(ZapLoggerMiddleware(logger))
    r.GET("/", func(c *gin.Context) {
        c.String(200, "OK")
    })
    r.Run(":8080")
}
```
Проверка `curl http://localhost:8080/`