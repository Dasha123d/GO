# Пример: Базовый структурированный Logger

Файл: `examples/basic-logger.go`

```go
package main

import (
    "go.uber.org/zap"
)

func main() {
    logger, _ := zap.NewProduction()
    defer logger.Sync()

    logger.Info("сервис запущен",
        zap.String("host", "localhost"),
        zap.Int("port", 8080),
    )
    logger.Error("ошибка подключения к БД",
        zap.Error(errors.New("connection refused")),
    )
}
```