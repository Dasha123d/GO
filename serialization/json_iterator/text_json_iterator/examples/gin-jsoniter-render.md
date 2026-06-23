# Пример: Кастомный рендер jsoniter в Gin

```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
    jsoniter "github.com/json-iterator/go"
)

var api = jsoniter.ConfigFastest

type JSONIterRender struct{}

func (r JSONIterRender) Render(w http.ResponseWriter) error { return nil }
func (r JSONIterRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json")
}
func (r JSONIterRender) WriteJSON(w http.ResponseWriter, v interface{}) error {
    stream := api.BorrowStream(w)
    defer api.ReturnStream(stream)
    stream.WriteVal(v)
    if stream.Error != nil {
        return stream.Error
    }
    return stream.Flush()
}

func main() {
    r := gin.Default()
    r.Render = JSONIterRender{}
    r.GET("/data", func(c *gin.Context) {
        c.JSON(200, gin.H{"msg": "hello from jsoniter"})
    })
    r.Run(":8080")
}
```
Проверка `curl http://localhost:8080/data`.