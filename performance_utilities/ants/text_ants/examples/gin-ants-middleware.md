# Пример: Gin обработчик с пулом ants

Файл: `examples/gin-ants-middleware.go`

```go
package main

import (
    "net/http"
    "time"
    "github.com/gin-gonic/gin"
    "github.com/panjf2000/ants/v2"
)

func main() {
    pool, _ := ants.NewPool(50, ants.WithNonblocking(true))
    defer pool.Release()

    r := gin.Default()
    r.GET("/heavy", func(c *gin.Context) {
        done := make(chan string, 1)
        err := pool.Submit(func() {
            time.Sleep(100 * time.Millisecond) // эмуляция нагрузки
            done <- "результат"
        })
        if err != nil {
            c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{"error": "перегрузка"})
            return
        }
        result := <-done
        c.String(200, result)
    })
    r.Run(":8080")
}
```
Проверка: `curl http://localhost:8080/heavy`