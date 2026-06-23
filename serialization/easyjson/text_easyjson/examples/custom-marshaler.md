# Пример: Кастомный easyjson-маршалер для времени

Файл: `examples/custom-marshaler.go`

```go
package main

import (
    "fmt"
    "time"
    "github.com/mailru/easyjson/jlexer"
    "github.com/mailru/easyjson/jwriter"
)

type CustomTime time.Time

func (ct CustomTime) MarshalEasyJSON(w *jwriter.Writer) {
    w.String(time.Time(ct).Format(time.RFC3339))
}
func (ct *CustomTime) UnmarshalEasyJSON(l *jlexer.Lexer) {
    t, _ := time.Parse(time.RFC3339, l.String())
    *ct = CustomTime(t)
}

//easyjson:json
type Event struct {
    Time CustomTime `json:"time"`
    Name string     `json:"name"`
}

func main() {
    ev := Event{
        Time: CustomTime(time.Now()),
        Name: "meeting",
    }
    data, _ := ev.MarshalJSON()
    fmt.Println(string(data))
}
```
