# Пример: Скрапер с сохранением в CSV
```go
package main

import (
    "encoding/csv"
    "os"
    "github.com/gocolly/colly/v2"
)

func main() {
    file, _ := os.Create("products.csv")
    defer file.Close()
    writer := csv.NewWriter(file)
    writer.Write([]string{"Title", "Price"})

    c := colly.NewCollector()
    c.OnHTML("div.product", func(e *colly.HTMLElement) {
        writer.Write([]string{
            e.ChildText("h2"),
            e.ChildText("span.price"),
        })
    })
    c.Visit("http://example.com/shop")
    writer.Flush()
}
```