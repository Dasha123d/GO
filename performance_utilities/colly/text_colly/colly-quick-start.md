# Быстрый старт: установка и первый краулер

## Установка

```bash
go get github.com/gocolly/colly/v2
```
Минимальный пример
Соберём все ссылки с главной страницы `example.com`:
```go
package main

import (
    "fmt"
    "github.com/gocolly/colly/v2"
)

func main() {
    c := colly.NewCollector()

    // Находим и обрабатываем все ссылки
    c.OnHTML("a[href]", func(e *colly.HTMLElement) {
        link := e.Attr("href")
        fmt.Println("Найдена ссылка:", link)
    })

    c.Visit("http://example.com")
}
```
Что здесь происходит:
* `colly.NewCollector()` – создаёт коллектор (краулер).
* `OnHTML` – регистрирует колбэк, вызываемый для каждого HTML-элемента, подходящего под CSS-селектор.
* `c.Visit` – запускает обход страницы.

## Обработка ошибок и финиш
```go
c.OnError(func(r *colly.Response, err error) {
    log.Println("Ошибка:", err)
})

c.OnResponse(func(r *colly.Response) {
    fmt.Println("Получен ответ от", r.Request.URL)
})

c.OnScraped(func(r *colly.Response) {
    fmt.Println("Страница обработана:", r.Request.URL)
})
```
## Замечание
По умолчанию Colly уважает `robots.txt` и делает паузы между запросами. Это можно настраивать (см. конфигурацию).