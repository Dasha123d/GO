# Пример: SugaredLogger

Файл: `examples/sugared-logger.go`

```go
package main

import (
    "go.uber.org/zap"
)

func main() {
    sugar, _ := zap.NewDevelopment()
    defer sugar.Sync()

    sugar.Infow("вход пользователя",
        "user", "Alice",
        "role", "admin",
    )
    sugar.Infof("запрос обработан за %v", 150*time.Millisecond)
}
```