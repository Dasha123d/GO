# HTTP-клиент в fasthttp

## Простой GET-запрос

```go
import "github.com/valyala/fasthttp"

func main() {
    req := fasthttp.AcquireRequest()
    resp := fasthttp.AcquireResponse()
    defer fasthttp.ReleaseRequest(req)
    defer fasthttp.ReleaseResponse(resp)

    req.SetRequestURI("https://api.example.com/data")
    req.Header.SetMethod(fasthttp.MethodGet)

    err := fasthttp.Do(req, resp)
    if err != nil {
        panic(err)
    }
    fmt.Println(string(resp.Body()))
}
```
Обязательно освобождайте `Request` и `Response` через `ReleaseRequest/ReleaseResponse` для возврата в пул.

## POST с JSON
```go
req.SetRequestURI("https://api.example.com/items")
req.Header.SetMethod(fasthttp.MethodPost)
req.Header.SetContentType("application/json")
req.SetBodyString(`{"name":"test"}`)

err := fasthttp.Do(req, resp)
```

## Тайм-ауты и персистентные соединения
```go
client := &fasthttp.Client{
    ReadTimeout:         5 * time.Second,
    WriteTimeout:        5 * time.Second,
    MaxConnsPerHost:     512,
    MaxIdleConnDuration: 30 * time.Second,
}

err := client.Do(req, resp)
```
Использование `fasthttp.Client` позволяет переиспользовать соединения (keep-alive).

## Скачивание больших файлов (стриминг)
```go
resp := fasthttp.AcquireResponse()
req := fasthttp.AcquireRequest()
req.SetRequestURI(url)

err := fasthttp.Do(req, resp)
body := resp.BodyStream()
// читаем поток
io.Copy(f, body)
fasthttp.ReleaseResponse(resp)
```

Fasthttp не буферизирует тело целиком, можно читать напрямую из потока.

## Пайплайнинг (Pipeline)
Поддерживается, но используется редко. Можно отправлять несколько запросов без ожидания ответа на каждый.