# Пример: Цепочка middleware

Файл: `examples/fasthttp-middleware-example.go`

```go
package main

import (
    "log"
    "time"
    "github.com/valyala/fasthttp"
)

type Middleware func(fasthttp.RequestHandler) fasthttp.RequestHandler

func LoggerMiddleware(next fasthttp.RequestHandler) fasthttp.RequestHandler {
    return func(ctx *fasthttp.RequestCtx) {
        start := time.Now()
        next(ctx)
        log.Printf("%s %s - %v", ctx.Method(), ctx.Path(), time.Since(start))
    }
}

func mainHandler(ctx *fasthttp.RequestCtx) {
    ctx.WriteString("OK")
}

func chain(handler fasthttp.RequestHandler, middlewares ...Middleware) fasthttp.RequestHandler {
    for i := len(middlewares) - 1; i >= 0; i-- {
        handler = middlewares[i](handler)
    }
    return handler
}

func main() {
    h := chain(mainHandler, LoggerMiddleware)
    fasthttp.ListenAndServe(":8080", h)
}
```