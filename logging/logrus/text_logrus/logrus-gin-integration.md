# Интеграция Logrus с Gin

## Замена стандартного логгера Gin

```go
router := gin.New()
router.Use(gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
    log.WithFields(logrus.Fields{
        "method": param.Method,
        "path":   param.Path,
        "status": param.StatusCode,
        "time":   param.TimeStamp.Format(time.RFC3339),
    }).Info("запрос")
    return ""
}))
```
## Middleware с Logrus
Создайте собственный middleware, который логирует запросы и время выполнения:
```go
func LogrusMiddleware(log *logrus.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        log.WithFields(logrus.Fields{
            "method":  c.Request.Method,
            "path":    c.Request.URL.Path,
            "status":  c.Writer.Status(),
            "latency": time.Since(start),
            "client":  c.ClientIP(),
        }).Info("HTTP запрос")
    }
}
```
Использование:
```go
router.Use(LogrusMiddleware(log))
```
## Доступ к логгеру из обработчиков
Сохраните логгер в контексте Gin через middleware:
```go
func InjectLogger(log *logrus.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Set("logger", log)
        c.Next()
    }
}
```
В обработчике:
```go
logger := c.MustGet("logger").(*logrus.Logger)
logger.WithField("user", userID).Info("обработка запроса")
```
Это позволяет передавать обогащённый логгер (с request ID, пользователем) вниз по цепочке.