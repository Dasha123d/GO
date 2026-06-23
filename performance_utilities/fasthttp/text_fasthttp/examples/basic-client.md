# Пример: HTTP-клиент

```go
package main

import (
    "fmt"
    "github.com/valyala/fasthttp"
)

func main() {
    req := fasthttp.AcquireRequest()
    resp := fasthttp.AcquireResponse()
    defer fasthttp.ReleaseRequest(req)
    defer fasthttp.ReleaseResponse(resp)

    req.SetRequestURI("http://localhost:8080/json")
    req.Header.SetMethod(fasthttp.MethodGet)

    err := fasthttp.Do(req, resp)
    if err != nil {
        panic(err)
    }
    fmt.Println(string(resp.Body()))
}
```