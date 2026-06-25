# Интеграция zap с Gin

## Замена стандартного логгера Gin

Создадим middleware, который логирует запросы с полями:

```go
func ZapLoggerMiddleware(logger *zap.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        logger.Info("HTTP запрос",
            zap.String("method", c.Request.Method),
            zap.String("path", c.Request.URL.Path),
            zap.Int("status", c.Writer.Status()),
            zap.Duration("latency", time.Since(start)),
            zap.String("client_ip", c.ClientIP()),
        )
    }
}
```
Использование:
```go
router := gin.New()
router.Use(ZapLoggerMiddleware(logger))
```
## Инъекция логгера в контекст
```go
func InjectLogger(logger *zap.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Set("logger", logger)
        c.Next()
    }
}
```
В обработчике:
```go
l := c.MustGet("logger").(*zap.Logger)
l.Info("обработка заказа")
```
## Логирование с request ID
Добавьте идентификатор запроса через контекст:
```go
requestID := uuid.New().String()
l := logger.With(zap.String("request_id", requestID))
c.Set("logger", l)
```
## Полная замена Gin-логгера на zap
Gin позволяет установить свой Writer для отладочных сообщений:
```go
gin.SetMode(gin.ReleaseMode)
gin.DefaultWriter = zapWriter
```
Но для структурированных логов лучше использовать полноценный middleware.