# Пример: Middleware для Gin с Logrus

Файл: `examples/gin-logrus-middleware.go`

```go
package main

import (
    "time"
    "github.com/gin-gonic/gin"
    "github.com/sirupsen/logrus"
)

func LogrusMiddleware(log *logrus.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        log.WithFields(logrus.Fields{
            "method":  c.Request.Method,
            "path":    c.Request.URL.Path,
            "status":  c.Writer.Status(),
            "latency": time.Since(start),
        }).Info("запрос")
    }
}

func main() {
    log := logrus.New()
    log.SetFormatter(&logrus.JSONFormatter{})

    r := gin.New()
    r.Use(LogrusMiddleware(log))
    r.GET("/", func(c *gin.Context) {
        c.String(200, "OK")
    })
    r.Run(":8080")
}
```
Проверка `curl http://localhost:8080/`