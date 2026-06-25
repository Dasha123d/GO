# Пример: JSON-логгер с контекстными полями

```go
package main

import (
    "os"
    "github.com/rs/zerolog"
)

func main() {
    logger := zerolog.New(os.Stderr).With().
        Timestamp().
        Str("service", "api").
        Logger()

    logger.Info().
        Str("method", "GET").
        Int("status", 200).
        Msg("запрос завершён")
}
```