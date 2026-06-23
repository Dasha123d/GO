# Конфигурация коллектора

## Создание с опциями

```go
c := colly.NewCollector(
    colly.AllowedDomains("example.com", "sub.example.com"),
    colly.URLFilters(
        colly.URLRegexp(regexp.MustCompile(`/category/.+`)),
    ),
    colly.MaxDepth(2),
    colly.Async(true),
)
```
## Основные настройки
* `AllowedDomains` / `DisallowedDomains` – белый/чёрный список доменов.
* `URLFilters` – регулярные выражения, которым должен соответствовать URL для перехода.
* `MaxDepth` – максимальная глубина рекурсивного обхода.
* `MaxBodySize` – лимит размера тела ответа (в байтах).
* `IgnoreRobotsTxt` – игнорировать запреты `robots.txt` (не рекомендуется).
* `Async` – включает асинхронный режим (требуется `c.Wait()` после запуска).

## Лимиты и паузы
Встроенный `Limit` через `colly.LimitRule`:
```go
c.Limit(&colly.LimitRule{
    DomainGlob:  "*",
    Parallelism: 2,                      // одновременно запросов к домену
    Delay:       5 * time.Second,        // пауза между запросами
    RandomDelay: 3 * time.Second,        // дополнительная случайная задержка
})
```
## Кастомный транспорт (HTTP client)
```go
c.WithTransport(&http.Transport{
    TLSClientConfig: &tls.Config{InsecureSkipVerify: false},
})
```
Или готовый `*http.Client`:
```go
c.SetClient(&http.Client{
    Timeout: 30 * time.Second,
})
```

## User-Agent и заголовки
```go
c.UserAgent = "MySuperBot/1.0"
c.OnRequest(func(r *colly.Request) {
    r.Headers.Set("Authorization", "Bearer token")
})
```
## Прокси
```go
proxyFunc := func(req *http.Request) (*url.URL, error) {
    return url.Parse("http://proxy:8080")
}
c.SetProxyFunc(proxyFunc)
```
Коллектор теперь полностью готов к продакшен-краулингу.