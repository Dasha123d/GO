# Быстрый старт: установка и базовое использование

## Установка

```bash
go get github.com/bytedance/sonic
```
Sonic – это drop-in замена `encoding/json` с поддержкой SIMD-ускорения (amd64, Linux/MacOS). На других платформах автоматически откатывается на совместимый код (sonic-standalone).

## Первый маршалинг/анмаршалинг
```go
package main

import (
    "fmt"
    "github.com/bytedance/sonic"
)

type User struct {
    Name  string `json:"name"`
    Email string `json:"email"`
    Age   int    `json:"age,omitempty"`
}

func main() {
    user := User{Name: "Alice", Email: "alice@example.com", Age: 25}

    // Маршалинг
    data, err := sonic.Marshal(user)
    if err != nil {
        panic(err)
    }
    fmt.Println(string(data)) // {"name":"Alice","email":"alice@example.com","age":25}

    // Анмаршалинг
    var decoded User
    err = sonic.Unmarshal(data, &decoded)
    if err != nil {
        panic(err)
    }
    fmt.Printf("%+v\n", decoded) // {Name:Alice Email:alice@example.com Age:25}
}
```
Важно: API полностью совместим со стандартной библиотекой `encoding/json`. Достаточно заменить `json.Marshal` на `sonic.Marshal`.