# Пример: Базовый пул с ожиданием

```go
package main

import (
    "fmt"
    "sync"
    "github.com/panjf2000/ants/v2"
)

func main() {
    var wg sync.WaitGroup
    pool, _ := ants.NewPool(5)
    defer pool.Release()

    for i := 0; i < 20; i++ {
        wg.Add(1)
        i := i // захват переменной
        pool.Submit(func() {
            fmt.Println("Задача", i)
            wg.Done()
        })
    }
    wg.Wait()
    fmt.Println("Все задачи завершены")
}
```