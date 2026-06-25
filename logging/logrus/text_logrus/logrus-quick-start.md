# Быстрый старт: установка и первый лог

## Установка

```bash
go get github.com/sirupsen/logrus
```
## Первое сообщение
```go
package main

import (
    "github.com/sirupsen/logrus"
)

func main() {
    logrus.Info("Приложение запущено")
    logrus.WithField("user", "Alice").Info("Пользователь вошёл")
}
```
По умолчанию logrus пишет в `os.Stderr` с форматированием текстом и уровнем `Info`.

## Стандартный logger
Глобальный `logrus` — это синглтон, его можно сразу использовать. Но лучше создать свой экземпляр:
```go
var log = logrus.New()

func main() {
    log.Info("Готов к работе")
}
```
## Уровни логирования
```go
log.SetLevel(logrus.DebugLevel)
log.Debug("Детальная информация")
log.Warn("Возможная проблема")
log.Error("Ошибка подключения")
```
Уровни: Trace, Debug, Info, Warn, Error, Fatal, Panic.

## Fatal и Panic
`Fatal` вызывает `os.Exit(1)`, `Panic` — `panic`.
```go
log.Fatal("Критическая ошибка, завершаемся")
```