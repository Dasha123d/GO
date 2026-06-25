# Пример: Базовое использование Logrus

Файл: `examples/basic-logger.go`

```go
package main

import (
    "os"
    "github.com/sirupsen/logrus"
)

func main() {
    log := logrus.New()
    log.SetOutput(os.Stdout)
    log.SetLevel(logrus.DebugLevel)
    log.SetFormatter(&logrus.TextFormatter{
        FullTimestamp: true,
    })

    log.WithField("app", "example").Info("Приложение стартует")
    log.WithError(os.ErrNotExist).Error("Файл не найден")
}
```