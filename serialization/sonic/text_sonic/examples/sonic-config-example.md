# Пример: Конфигурация с опциями


```go
package main

import (
    "fmt"
    "github.com/bytedance/sonic"
)

type Data struct {
    Name string `json:"name"`
}

func main() {
    // Конфиг с отключённым экранированием HTML и сортировкой ключей
    cfg := sonic.Config{
        EscapeHTML:  false,
        SortMapKeys: true,
        IndentStep:  "  ",
    }.Froze()

    m := map[string]interface{}{
        "html": "<script>alert(1)</script>",
        "key":  "value",
    }

    // MarshalIndent с кастомным конфигом
    out, _ := cfg.MarshalIndent(m, "", "  ")
    fmt.Println(string(out))
}
```
