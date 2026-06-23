# Пример: Базовый краулер

```go
package main

import (
    "fmt"
    "github.com/gocolly/colly/v2"
)

func main() {
    c := colly.NewCollector(
        colly.AllowedDomains("books.toscrape.com"),
    )

    c.OnHTML("article.product_pod", func(e *colly.HTMLElement) {
        title := e.ChildText("h3 a")
        price := e.ChildText("p.price_color")
        fmt.Printf("Книга: %s, Цена: %s\n", title, price)
    })

    c.OnHTML("li.next a", func(e *colly.HTMLElement) {
        nextPage := e.Request.AbsoluteURL(e.Attr("href"))
        c.Visit(nextPage)
    })

    c.Visit("http://books.toscrape.com/")
}
```