# Пример: Замена рендера Gin на Sonic

Файл: `examples/gin-sonic-render.go`

```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "github.com/bytedance/sonic"
)

type SonicRender struct{}

func (r SonicRender) Render(w http.ResponseWriter) error { return nil }
func (r SonicRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json")
}
func (r SonicRender) WriteJSON(w http.ResponseWriter, v interface{}) error {
    data, err := sonic.Marshal(v)
    if err != nil {
        return err
    }
    _, err = w.Write(data)
    return err
}

func main() {
    gin.SetMode(gin.ReleaseMode)
    r := gin.New()
    r.Render = SonicRender{}

    r.GET("/data", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "hello from sonic"})
    })
    r.Run(":8080")
}
```
Проверка: `curl http://localhost:8080/data`