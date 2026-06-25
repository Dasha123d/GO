# Пример: Middleware zerolog для Gin
```go
package main

import (
    "net/http"
    "time"
    "github.com/gin-gonic/gin"
    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func ZerologMiddleware(logger zerolog.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        logger.Info().
            Str("method", c.Request.Method).
            Str("path", c.Request.URL.Path).
            Int("status", c.Writer.Status()).
            Dur("latency", time.Since(start)).
            Str("ip", c.ClientIP()).
            Msg("")
    }
}

func main() {
    logger := zerolog.New(os.Stdout).With().Timestamp().Logger()
    r := gin.New()
    r.Use(ZerologMiddleware(logger))
    r.GET("/", func(c *gin.Context) {
        c.String(http.StatusOK, "hello")
    })
    r.Run(":8080")
}
```
Проверка: `curl http://localhost:8080/`