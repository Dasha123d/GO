# Интеграция jsoniter с Gin

## Замена рендера Gin

Аналогично Sonic и easyjson, создаём кастомный рендер:

```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
    jsoniter "github.com/json-iterator/go"
)

var jsonAPI = jsoniter.ConfigFastest

type JSONIterRender struct{}

func (r JSONIterRender) Render(w http.ResponseWriter) error { return nil }
func (r JSONIterRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json; charset=utf-8")
}
func (r JSONIterRender) WriteJSON(w http.ResponseWriter, v interface{}) error {
    stream := jsonAPI.BorrowStream(w)
    defer jsonAPI.ReturnStream(stream)
    stream.WriteVal(v)
    if stream.Error != nil {
        return stream.Error
    }
    stream.Flush()
    return nil
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
Использование `BorrowStream` снижает накладные расходы на буферы.

## Быстрый биндинг тела запроса
Можно написать хелпер:
```go
func BindJSON(c *gin.Context, obj interface{}) error {
    data, err := c.GetRawData()
    if err != nil {
        return err
    }
    return jsonAPI.Unmarshal(data, obj)
}
```
Используйте в обработчиках вместо `c.ShouldBindJSON`.

## Ленивый доступ к телу через Any
```go
func handle(c *gin.Context) {
    data, _ := c.GetRawData()
    any := jsoniter.Get(data)
    username := any.Get("username").ToString()
    // ...
}
```