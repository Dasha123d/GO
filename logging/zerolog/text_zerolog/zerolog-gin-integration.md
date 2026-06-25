# Интеграция zerolog с Gin

## Middleware для логирования запросов

```go
func ZerologMiddleware(logger zerolog.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        c.Next()

        logger.Info().
            Str("method", c.Request.Method).
            Str("path", c.Request.URL.Path).
            Int("status", c.Writer.Status()).
            Dur("latency", time.Since(start)).
            Str("client_ip", c.ClientIP()).
            Msg("HTTP запрос")
    }
}
```
Использование:
```go
router := gin.New()
router.Use(ZerologMiddleware(log.Logger))
```
## Инъекция логгера в контекст запроса
Добавляем обогащённый логгер (с request ID) в каждый обработчик:
```go
func InjectLoggerMiddleware(base zerolog.Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        requestID := c.GetHeader("X-Request-Id")
        if requestID == "" {
            requestID = uuid.NewString()
        }
        l := base.With().Str("request_id", requestID).Logger()
        c.Set("logger", l)
        c.Next()
    }
}
```
В обработчике:
```go
l := c.MustGet("logger").(zerolog.Logger)
l.Info().Msg("выполняется бизнес-логика")
```
## Замена стандартного вывода Gin
Gin пишет свои внутренние сообщения в `gin.DefaultWriter`. Можно перенаправить их в zerolog, но проще полностью отключить стандартный логгер и использовать middleware.

## Обработка ошибок
Логируйте ошибки, которые Gin не обработал:
```go
router.Use(gin.Recovery())
router.Use(func(c *gin.Context) {
    defer func() {
        if r := recover(); r != nil {
            l := c.MustGet("logger").(zerolog.Logger)
            l.Error().Interface("panic", r).Msg("паника в обработчике")
            c.AbortWithStatus(500)
        }
    }()
    c.Next()
})
```