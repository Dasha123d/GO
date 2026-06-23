# Быстрый старт: установка и первый пул

## Установка

```bash
go get github.com/panjf2000/ants/v2
```
## Простой пул
```go
package main

import (
    "fmt"
    "sync"

    "github.com/panjf2000/ants/v2"
)

func main() {
    var wg sync.WaitGroup

    // Создаём пул из 10 горутин
    pool, _ := ants.NewPool(10)
    defer pool.Release()

    for i := 0; i < 100; i++ {
        wg.Add(1)
        // Отправляем задачу в пул
        pool.Submit(func() {
            fmt.Println("Task", i)
            wg.Done()
        })
    }

    wg.Wait()
}
```
* `ants.NewPool(size)` – создаёт пул фиксированного размера.
* `pool.Submit(f)` – добавляет функцию в очередь, выполняется в любой свободной горутине.
* `pool.Release()` – корректно освобождает ресурсы пула (ждёт завершения текущих задач).

## Дефолтный пул (безразмерный)
Если не хотите управлять размером, используйте глобальный пул с автоматическим масштабированием:
```go
for i := 0; i < 100; i++ {
    wg.Add(1)
    ants.Submit(func() {
        fmt.Println("Task", i)
        wg.Done()
    })
}
wg.Wait()
```
`ants.Submit` использует дефолтный пул, который создаётся лениво и растёт по необходимости. Для production лучше явно задавать лимит.