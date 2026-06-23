# Парсинг HTML с Colly

## Использование CSS-селекторов (goquery под капотом)

```go
c.OnHTML("div.product", func(e *colly.HTMLElement) {
    title := e.ChildText("h2.title")
    price := e.ChildAttr("span.price", "data-value")
    // или извлечь изображение
    img := e.ChildAttr("img", "src")
    fmt.Println(title, price, img)
})
```
## Итерация по элементам
```go
c.OnHTML("ul.items > li", func(e *colly.HTMLElement) {
    e.ForEach("li", func(_ int, el *colly.HTMLElement) {
        fmt.Println(el.Text)
    })
})
```
## XPath (встроенная поддержка)
```go
c.OnXML("//div[@class='product']/h2", func(e *colly.XMLElement) {
    fmt.Println(e.Text)
})
```
Под капотом используется библиотека `htmlquery` для XPath.

## Работа с атрибутами
* `e.Attr("href")` – значение атрибута.
* `e.ChildAttr(".class", "data-id")` – атрибут дочернего элемента.
* `e.Request.AbsoluteURL(link)` – преобразование относительной ссылки в абсолютную.

## Извлечение текста и ссылок
```go
e.Text                // текст элемента
e.Link()              // абсолютный URL (если элемент <a>)
e.Request.URL         // URL текущей страницы
```
## Парсинг JSON в теле страницы
Иногда данные встроены в тег `<script>`. Можно извлечь их через `e.ChildText("script[type='application/json']")` и распарсить `json.Unmarshal`.

## Пример извлечения данных в структуру
```go
type Product struct {
    Name  string
    Price string
}
var products []Product

c.OnHTML("div.product", func(e *colly.HTMLElement) {
    p := Product{
        Name:  e.ChildText("h2"),
        Price: e.ChildAttr("span", "data-price"),
    }
    products = append(products, p)
})
```