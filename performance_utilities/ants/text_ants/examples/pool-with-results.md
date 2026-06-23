# Пример: Пул с возвратом результатов

```go
package main

import (
    "fmt"
    "github.com/panjf2000/ants/v2"
)

func main() {
    pool, _ := ants.NewPool(10)
    defer pool.Release()

    results := make(chan int, 100)
    for i := 0; i < 100; i++ {
        i := i
        pool.Submit(func() {
            results <- i * i
        })
    }

    // Собираем результаты (можно было дождаться WaitGroup и закрыть канал)
    for i := 0; i < 100; i++ {
        fmt.Println(<-results)
    }
}
```