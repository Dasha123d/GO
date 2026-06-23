# Middleware в fasthttp

## Цепочка обработчиков

Fasthttp не имеет встроенного middleware как Gin, но легко строится через обёртки:

```go
type Middleware func(fasthttp.RequestHandler) fasthttp.RequestHandler

func LoggerMiddleware(next fasthttp.RequestHandler) fasthttp.RequestHandler {
    return func(ctx *fasthttp.RequestCtx) {
        start := time.Now()
        next(ctx)
        log.Printf("%s %s %v", ctx.Method(), ctx.Path(), time.Since(start))
    }
}
```
## Сборка цепочки
```go
func chain(handler fasthttp.RequestHandler, middlewares ...Middleware) fasthttp.RequestHandler {
    for i := len(middlewares) - 1; i >= 0; i-- {
        handler = middlewares[i](handler)
    }
    return handler
}

finalHandler := chain(myHandler, LoggerMiddleware, AuthMiddleware)
fasthttp.ListenAndServe(":8080", finalHandler)
```
## Пример: CORS
```go
func CORSMiddleware(next fasthttp.RequestHandler) fasthttp.RequestHandler {
    return func(ctx *fasthttp.RequestCtx) {
        ctx.Response.Header.Set("Access-Control-Allow-Origin", "*")
        if ctx.IsOptions() {
            ctx.Response.Header.Set("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE")
            ctx.Response.Header.Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
            ctx.SetStatusCode(fasthttp.StatusNoContent)
            return
        }
        next(ctx)
    }
}
```
## Пример: Recovery (от паник)
```go
func RecoveryMiddleware(next fasthttp.RequestHandler) fasthttp.RequestHandler {
    return func(ctx *fasthttp.RequestCtx) {
        defer func() {
            if r := recover(); r != nil {
                log.Printf("panic: %v", r)
                ctx.SetStatusCode(fasthttp.StatusInternalServerError)
            }
        }()
        next(ctx)
    }
}
```
## Использование с роутером
Популярный роутер fasthttprouter (`github.com/buaazp/fasthttprouter`) также поддерживает middleware через цепочки.