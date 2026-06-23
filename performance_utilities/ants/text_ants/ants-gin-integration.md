# Интеграция ants с Gin: обработка запросов в пуле

## Зачем?

Gin сам использует горутину на каждый запрос. Если у вас тяжёлый handler, вы можете перенести вычисления в пул, чтобы ограничить параллелизм и не перегружать CPU.

## Middleware, ограничивающий количество одновременных обработок

```go
func LimitByPool(pool *ants.Pool) gin.HandlerFunc {
    return func(c *gin.Context) {
        // Отправляем задачу в пул
        err := pool.Submit(func() {
            c.Next() // выполняется внутри пула
        })
        if err != nil {
            // Nonblocking вернул ошибку — перегрузка
            c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{"error": "server overloaded"})
            return
        }
        // Не вызываем c.Next() снаружи, потому что он уже выполнится внутри пула
        // Но Gin требует, чтобы обработчик завершался после Next(), 
        // поэтому надо правильно организовать ожидание.
    }
}
```
Правильный подход: использовать пул не для оборачивания всего цепочки, а только для вычислительно-тяжёлого участка внутри конкретного handler'а:
```go
api.GET("/compute", func(c *gin.Context) {
    var result int
    err := antsPool.Submit(func() {
        result = heavyComputation()
    })
    if err != nil {
        c.AbortWithStatus(503)
        return
    }
    // нужно дождаться завершения — через канал или WaitGroup
})
```
Удобнее в handler'е использовать синхронизацию через канал:
```go
func computeHandler(c *gin.Context) {
    done := make(chan int, 1)
    err := pool.Submit(func() {
        done <- heavyComputation()
    })
    if err != nil {
        c.AbortWithStatusJSON(503, gin.H{"error": "overload"})
        return
    }
    result := <-done
    c.JSON(200, gin.H{"result": result})
}
```
## Запуск задач в пуле для асинхронных операций
Например, отправка email после ответа:
```go
c.JSON(200, gin.H{"status": "ok"})
// не блокируем ответ
pool.Submit(func() {
    sendEmail(user.Email)
})
```
Не забывайте, что если пул переполнен, задача может быть не выполнена. Лучше использовать очередь (например, Redis) для критичных операций.