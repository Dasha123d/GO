# Асинхронная работа и очереди запросов

## Асинхронный режим

```go
c := colly.NewCollector(colly.Async(true))
c.OnHTML("a[href]", func(e *colly.HTMLElement) {
    c.Visit(e.Request.AbsoluteURL(e.Attr("href")))
})
c.Visit("http://example.com")
c.Wait() // блокируется до завершения всех запросов
```
В асинхронном режиме `Visit` возвращает управление сразу, а запросы выполняются параллельно (число ограничено `Parallelism` в `LimitRule`).

## Очереди запросов (Request Queue)
Colly поддерживает встроенную очередь на основе буфера в памяти. При большом количестве URL лучше использовать постоянную очередь (Redis, RabbitMQ).
```go
import "github.com/gocolly/colly/v2/queue"
q, _ := queue.New(
    2, // количество воркеров
    &queue.InMemoryQueueStorage{MaxSize: 10000},
)
q.AddURL("http://example.com/page/1")
q.AddURL("http://example.com/page/2")
q.Run(c)
```

## Redis-очередь
Установите `github.com/gocolly/redisqueue`:
```go
import "github.com/gocolly/redisqueue"
storage := &redisqueue.Storage{
    Addr: "localhost:6379",
}
q, _ := queue.New(5, storage)
q.AddURL("...")
q.Run(c)
```
Теперь краулер можно перезапускать без потери очереди.

## Приоритет и глубина
URL, добавленные через `Visit`, обрабатываются с текущей глубиной. При использовании очереди глубина не учитывается — управляйте приоритетами самостоятельно.

## Остановка и graceful shutdown
```go
c.OnError(func(r *colly.Response, err error) {
    // логируем
})
c.OnScraped(func(r *colly.Response) {
    // если достигнут лимит, выходим
    if len(visitedURLs) >= 10000 {
        c.Wait() // дожидаемся текущих и останавливаем
        os.Exit(0)
    }
})
```
Colly не имеет встроенного `Shutdown`, но `c.Wait()` гарантирует завершение всех запросов в асинхронном режиме.