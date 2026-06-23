# Быстрый старт: установка, кодогенерация и первый пример

## Установка

```bash
# сама библиотека
go get github.com/mailru/easyjson

# утилита кодогенерации
go install github.com/mailru/easyjson/easyjson@latest
```
## Пишем структуры
`model/model.go`:
```go
package model

//easyjson:json
type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email,omitempty"`
}
```
## Генерация кода
```bash
easyjson -all model/model.go
```
Появится файл `model/model_easyjson.go` с методами `MarshalEasyJSON/UnmarshalEasyJSON`.
## Использование
```go
package main

import (
    "fmt"
    "myapp/model"
)

func main() {
    u := model.User{ID: 1, Name: "Alice", Email: "alice@example.com"}
    data, _ := u.MarshalJSON()          // или easyjson.Marshal(u)
    fmt.Println(string(data))

    var u2 model.User
    _ = u2.UnmarshalJSON(data)          // или easyjson.Unmarshal(data, &u2)
    fmt.Printf("%+v\n", u2)
}
```
Всё! Вы получили сгенерированный код, который в разы быстрее `encoding/json`, с полностью совместимым API.