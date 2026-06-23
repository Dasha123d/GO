# Пример: Использование fasthttprouter

Установка: `go get github.com/buaazp/fasthttprouter`

```go
package main

import (
    "github.com/buaazp/fasthttprouter"
    "github.com/valyala/fasthttp"
)

func main() {
    router := fasthttprouter.New()
    router.GET("/", func(ctx *fasthttp.RequestCtx) {
        ctx.WriteString("root")
    })
    router.GET("/hello/:name", func(ctx *fasthttp.RequestCtx) {
        name := ctx.UserValue("name").(string)
        ctx.WriteString("Hello " + name)
    })
    fasthttp.ListenAndServe(":8080", router.Handler)
}
```