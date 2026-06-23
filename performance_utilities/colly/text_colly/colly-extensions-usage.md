# Расширения Colly: редиректы, авторизация, куки, случайные задержки

## Расширение RandomDelay

```go
import "github.com/gocolly/colly/v2/extensions"
extensions.RandomUserAgent(c)    // случайный User-Agent
extensions.Referer(c)            // устанавливает Referer равным предыдущему URL
```
После подключения этих расширений краулер ведёт себя более похоже на обычный браузер.

## Обработка редиректов
По умолчанию Colly следует редиректам. Максимальное количество редиректов можно задать:
```go
c.SetRedirectHandler(func(req *http.Request, via []*http.Request) error {
    if len(via) >= 10 {
        return fmt.Errorf("слишком много редиректов")
    }
    return nil
})
```
## Аутентификация
* Basic Auth – через `OnRequest` установите заголовок.
* Cookie – сохраняются и отправляются автоматически. Можно добавить начальные куки:
```go
c.OnRequest(func(r *colly.Request) {
    r.Headers.Set("Cookie", "session=abc123")
})
```
Или программно аутентифицироваться в `OnResponse` + `c.SetCookies()`.

## Управление куками вручную
Коллектор хранит куки в `c.Cookies(u *url.URL)`. Можно сохранить их в файл и загрузить для следующего запуска.

## Прокрутка страниц (пагинация)
Обычно реализуется через `OnHTML` с проверкой наличия кнопки «Далее»:
```go
c.OnHTML("a.next-page", func(e *colly.HTMLElement) {
    nextPage := e.Request.AbsoluteURL(e.Attr("href"))
    c.Visit(nextPage)
})
```
## Экспорт / импорт cookies
```go
import "net/http"
// Сохранить в JSON
cookies := c.Cookies(someURL)
// Загрузить
c.SetCookies(someURL, cookies)
```
Можно написать обёртку для хранения в файл.