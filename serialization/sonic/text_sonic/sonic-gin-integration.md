# Интеграция Sonic с Gin: заменяем стандартный JSON-рендер

## Подмена рендера Gin

Gin использует `encoding/json` для сериализации ответов. Можно заменить его на Sonic для ускорения.

```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "github.com/bytedance/sonic"
)

type SonicJSONRender struct{}

func (r SonicJSONRender) Render(w http.ResponseWriter) error {
    // Уже используется sonic в WriteJSON, но можно кастомизировать
    return nil
}

func (r SonicJSONRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json; charset=utf-8")
}

func (r SonicJSONRender) WriteJSON(w http.ResponseWriter, obj interface{}) error {
    data, err := sonic.Marshal(obj)
    if err != nil {
        return err
    }
    _, err = w.Write(data)
    return err
}

func main() {
    router := gin.New()
    router.Render = SonicJSONRender{} // глобальная замена

    router.GET("/user", func(c *gin.Context) {
        c.JSON(200, gin.H{"name": "Alice", "age": 25})
    })
    router.Run(":8080")
}
```
Уже начиная с Gin 1.9 можно использовать c.JSON как обычно, но при этом рендер будет быстрее.

## Ускорение парсинга входящих запросов
Чтобы десериализовать JSON-тело запроса быстрее, используйте `c.ShouldBindJSON` со стандартным binding, но с заменой внутреннего JSON-декодера через middleware:
```go
func SonicBindingMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        if c.Request.Body != nil && c.Request.Method == "POST" || c.Request.Method == "PUT" {
            // Sonic поддерживает io.Reader, но gin использует свой binding
            // Можно переопределить binding для конкретного типа
        }
        c.Next()
    }
}
```
В большинстве случаев стандартный binding работает через `json.NewDecoder`, но его замена на Sonic даст небольшой прирост. Есть сторонние пакеты (`gin-sonic`), но можно обойтись кастомным `ShouldBindBodyWith` с `sonic`.
```go
func BindJSON(c *gin.Context, obj interface{}) error {
    data, err := c.GetRawData()
    if err != nil {
        return err
    }
    return sonic.Unmarshal(data, obj)
}
```
Используйте вместо `c.ShouldBindJSON`.

## Рекомендация
Для максимальной производительности используйте глобальный Sonic-рендер и кастомный анмаршалинг тела запроса. Не забывайте `Pretouch` на структурах запросов и ответов.