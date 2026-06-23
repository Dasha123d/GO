# Пример: Базовый маршалинг/анмаршалинг

```go
package main

import (
    "fmt"
    "github.com/bytedance/sonic"
)

type Product struct {
    ID    int     `json:"id"`
    Name  string  `json:"name"`
    Price float64 `json:"price"`
}

func main() {
    p := Product{ID: 1, Name: "Laptop", Price: 999.99}
    // Marshal
    data, _ := sonic.Marshal(p)
    fmt.Println(string(data))

    // Unmarshal
    var p2 Product
    sonic.Unmarshal(data, &p2)
    fmt.Printf("%+v\n", p2)
}
```