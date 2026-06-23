# Интеграция easyjson с Gin

## Замена стандартного рендера

Создадим кастомный рендер, который вызывает `easyjson.Marshal` для объектов, поддерживающих `easyjson.Marshaler`.

```go
type EasyJSONRender struct{}

func (r EasyJSONRender) Render(w http.ResponseWriter) error { return nil }
func (r EasyJSONRender) WriteContentType(w http.ResponseWriter) {
    w.Header().Set("Content-Type", "application/json; charset=utf-8")
}
func (r EasyJSONRender) WriteJSON(w http.ResponseWriter, v interface{}) error {
    if m, ok := v.(easyjson.Marshaler); ok {
        // эффективно, без дополнительного копирования
        buf := &bytes.Buffer{}
        err := m.MarshalEasyJSON(jwriter.Wrap(buf))
        if err != nil {
            return err
        }
        _, err = w.Write(buf.Bytes())
        return err
    }
    // fallback на стандартный JSON
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
    // ...
}
```
## Ускорение биндинга запросов
Можно написать быстрый анмаршалер для входящих данных:
```go
func BindEasyJSON(c *gin.Context, obj easyjson.Unmarshaler) error {
    data, err := c.GetRawData()
    if err != nil {
        return err
    }
    return obj.UnmarshalEasyJSON(jlexer.Lexer{Data: data})
}
```
И использовать вместо `c.ShouldBindJSON`. Но удобнее использовать стандартные методы, которые всё равно вызовут `UnmarshalJSON()` у структуры, если она его реализует.

## Производительность
Тесты показывают, что при замене рендера на easyjson пропускная способность Gin возрастает на 10–30% на типичных ответах с JSON. Главное – не забыть перегенерировать easyjson-файлы перед сборкой.