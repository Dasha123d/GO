# Пример: JSON-формат с настройками

Файл: `examples/json-formatter.go`

```go
package main

import (
    "os"
    "github.com/sirupsen/logrus"
)

func main() {
    log := logrus.New()
    log.SetOutput(os.Stdout)
    log.SetFormatter(&logrus.JSONFormatter{
        FieldMap: logrus.FieldMap{
            logrus.FieldKeyTime:  "timestamp",
            logrus.FieldKeyLevel: "level",
            logrus.FieldKeyMsg:   "message",
        },
    })

    log.WithFields(logrus.Fields{
        "user": "Alice",
        "ip":   "10.0.0.1",
    }).Info("Авторизация успешна")
}
```