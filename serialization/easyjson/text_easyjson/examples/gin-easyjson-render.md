# Пример: Кастомный рендер easyjson в Gin


```go
package main

import (
    "bytes"
    "encoding/json"
    "net/http"

    "github.com/gin-gonic/gin"
    "github.com/mailru/easyjson"
    "github.com/mailru/easyjson/jwriter"
)

type EasyJSONRender struct{}

func (r EasyJSONRender) Render(w http.ResponseWriter) error { return nil }
func (r EasyJSONRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json; charset=utf-8")
}
func (r EasyJSONRender) WriteJSON(w http.ResponseWriter, v interface{}) error {
    if m, ok := v.(easyjson.Marshaler); ok {
        buf := &bytes.Buffer{}
        m.MarshalEasyJSON(jwriter.Wrap(buf))
        _, err := w.Write(buf.Bytes())
        return err
    }
    data, err := json.Marshal(v)
    if err != nil {
        return err
    }
    _, err = w.Write(data)
    return err
}

func main() {
    r := gin.Default()
    r.Render = EasyJSONRender{}
    r.GET("/data", func(c *gin.Context) {
        c.JSON(200, struct {
            Msg string `json:"msg"`
        }{"hello from easyjson"})
    })
    r.Run(":8080")
}
```