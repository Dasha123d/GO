# Пример: Базовое использование jsoniter

```go
package main

import (
    "fmt"
    jsoniter "github.com/json-iterator/go"
)

var json = jsoniter.ConfigCompatibleWithStandardLibrary

type User struct {
    Name  string `json:"name"`
    Email string `json:"email"`
}

func main() {
    u := User{Name: "Bob", Email: "bob@example.com"}
    data, _ := json.Marshal(u)
    fmt.Println(string(data))

    var u2 User
    json.Unmarshal(data, &u2)
    fmt.Printf("%+v\n", u2)
}
```