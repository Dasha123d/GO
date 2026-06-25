# Пример: Базовый логгер с консольным выводом

Файл: `examples/basic-logger.go`

```go
package main

import (
    "os"
    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func main() {
    zerolog.TimeFieldFormat = zerolog.TimeFormatUnixMs
    log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

    log.Info().Msg("Приложение стартовало")
    log.Warn().Int("attempt", 3).Msg("повторная попытка")
}
```