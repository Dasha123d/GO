# Пример: Базовый сервер с путями

```go
package main

import (
    "fmt"
    "github.com/valyala/fasthttp"
)

func requestHandler(ctx *fasthttp.RequestCtx) {
    switch string(ctx.Path()) {
    case "/":
        ctx.SetContentType("text/plain")
        ctx.WriteString("Welcome")
    case "/json":
        ctx.SetContentType("application/json")
        fmt.Fprint(ctx, `{"status":"ok"}`)
    default:
        ctx.SetStatusCode(fasthttp.StatusNotFound)
    }
}

func main() {
    fasthttp.ListenAndServe(":8080", requestHandler)
}
```