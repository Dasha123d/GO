# Быстрый старт: установка и первые логи

## Установка

```bash
go get github.com/rs/zerolog
```
## Глобальный логгер
```go
package main

import (
    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func main() {
    zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
    log.Info().Msg("Приложение запущено")
    log.Debug().Str("user", "alice").Msg("Вход в систему")
}
```
По умолчанию zerolog пишет в `os.Stderr` в JSON.

## Простой цепочечный вызов
```go
log.Info().
    Str("env", "production").
    Int("version", 2).
    Msg("конфигурация загружена")
```
Методы добавления полей (`Str`, `Int`, `Bool` и т.д.) создают событие, которое завершается вызовом `Msg` или `Msgf`.

## Уровни
```go
log.Trace().Msg("трассировка")
log.Debug().Msg("отладка")
log.Info().Msg("информация")
log.Warn().Msg("предупреждение")
log.Error().Msg("ошибка")
log.Fatal().Msg("фатальная ошибка") // завершает программу
log.Panic().Msg("паника")          // вызывает panic
```
Уровень по умолчанию — `Trace`. В production рекомендуется `Info` или `Warn`.

## Изменение глобального уровня
```go
zerolog.SetGlobalLevel(zerolog.InfoLevel)
// или для конкретного логгера
logger := zerolog.New(os.Stdout).Level(zerolog.WarnLevel)
```
## Отключение цвета
При записи в терминал можно добавить цветной вывод через `ConsoleWriter`:
```go
log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
```