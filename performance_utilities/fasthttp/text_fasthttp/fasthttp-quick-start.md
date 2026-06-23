# Быстрый старт: установка и первый сервер

## Установка

```bash
go get github.com/valyala/fasthttp
```
## Минимальный HTTP-сервер
```go
package main

import (
    "github.com/valyala/fasthttp"
)

func main() {
    // Обработчик запросов
    handler := func(ctx *fasthttp.RequestCtx) {
        ctx.SetContentType("text/plain; charset=utf-8")
        ctx.WriteString("Hello, fasthttp!")
    }

    // Запуск сервера
    fasthttp.ListenAndServe(":8080", handler)
}
```
Сервер готов, слушает порт 8080 и отвечает на все запросы.

## Обработка путей
```go
handler := func(ctx *fasthttp.RequestCtx) {
    switch string(ctx.Path()) {
    case "/":
        ctx.WriteString("Home page")
    case "/api":
        ctx.SetContentType("application/json")
        ctx.WriteString(`{"status":"ok"}`)
    default:
        ctx.SetStatusCode(fasthttp.StatusNotFound)
    }
}
```
Важно: В отличие от `net/http`, fasthttp не маршрутизирует запросы автоматически — за маршрутизацию отвечаете вы. Можно использовать сторонние маршрутизаторы (например, `fasthttprouter`, `fiber`).

## Под капотом
* Запрос и ответ не выделяются каждый раз заново, а переиспользуются из пула объектов.
* Нет стандартных `http.Handler`, используется свой обработчик `fasthttp.RequestHandler`.
* Контекст `RequestCtx` содержит всё необходимое для чтения запроса и записи ответа.
```go
go func() {
    sig := make(chan os.Signal, 1)
    signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
    <-sig
    shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()
    s.ShutdownWithContext(shutdownCtx)
}()
s.ListenAndServe(":8080")
```
После получения сигнала сервер перестаёт принимать новые соединения и дожидается завершения текущих.

## TLS/HTTPS
```go
s.ListenAndServeTLS(":443", "cert.pem", "key.pem")
```
## WebSocket
Fasthttp сам не реализует WebSocket, но есть адаптеры, например `github.com/fasthttp/websocket` или можно обернуть стандартный `gorilla/websocket`:
```go
import "github.com/fasthttp/websocket"

var upgrader = websocket.FastHTTPUpgrader{}

func wsHandler(ctx *fasthttp.RequestCtx) {
    err := upgrader.Upgrade(ctx, func(conn *websocket.Conn) {
        // работа с conn
    })
}
```
## Сжатие ответов
Fasthttp не сжимает автоматически. Используйте `compressHandler` из пакета `fasthttp/pprofhandler` или вручную:
```go
ctx.Response.Header.Set("Content-Encoding", "gzip")
zw := gzip.NewWriter(ctx.Response.BodyWriter())
zw.Write(data)
zw.Close()
```