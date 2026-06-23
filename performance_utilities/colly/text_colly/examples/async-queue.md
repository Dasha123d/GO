# Пример: Асинхронный краулер с Redis-очередью

Файл: `examples/async-queue.go`

```go
package main

import (
    "log"
    "github.com/gocolly/colly/v2"
    "github.com/gocolly/colly/v2/queue"
    "github.com/gocolly/redisqueue"
)

func main() {
    c := colly.NewCollector(colly.Async(true))
    c.OnHTML("a[href]", func(e *colly.HTMLElement) {
        c.Visit(e.Request.AbsoluteURL(e.Attr("href")))
    })

    storage := &redisqueue.Storage{Addr: "localhost:6379"}
    q, err := queue.New(4, storage)
    if err != nil {
        log.Fatal(err)
    }
    q.AddURL("https://example.com")
    q.Run(c)
    c.Wait()
}
```
Запуск: Redis должен быть запущен.