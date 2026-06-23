# Пример: Базовый маршалинг/анмаршалинг easyjson

Файл: `examples/basic-marshal.go`

```go
package main

import (
    "fmt"
    "myapp/model"
)

func main() {
    u := model.User{ID: 1, Name: "Alice", Email: "alice@example.com"}
    data, _ := u.MarshalJSON()
    fmt.Println(string(data))

    var u2 model.User
    _ = u2.UnmarshalJSON(data)
    fmt.Printf("%+v\n", u2)
}
```
Не забудьте предварительно сгенерировать `model_easyjson.go` командой `easyjson -all model.go`