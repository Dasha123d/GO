# Быстрый старт: установка и первые логи

## Установка

```bash
go get go.uber.org/zap
```
## Базовый Logger
Создаём быстрый структурированный логгер:
```go
package main

import (
    "go.uber.org/zap"
)

func main() {
    logger, _ := zap.NewProduction()
    defer logger.Sync() // сброс буферов

    logger.Info("Приложение запущено",
        zap.String("env", "production"),
        zap.Int("version", 2),
    )
}
```
`zap.NewProduction()` возвращает настроенный логгер с JSON-форматом, уровнем Info, сэмплированием.

## SugaredLogger (более удобный синтаксис)
```go
sugar, _ := zap.NewDevelopment()
defer sugar.Sync()

sugar.Infow("Вход пользователя",
    "user", "Alice",
    "ip", "10.0.0.1",
)

sugar.Infof("Запрос обработан за %v", time.Second)
```
`NewDevelopment()` — текстовый формат, уровень Debug, более читаемый для разработки.

## Быстрый старт с дефолтными конфигами
Можно заменить глобальный логгер:
```go
zap.ReplaceGlobals(logger)
zap.L().Info("Теперь zap используется глобально")
```
## Основные методы
* `logger.Info(msg, fields...)`
* `logger.Error(msg, fields...)`
* `logger.Debug(...)`
* `logger.Fatal(...)`, `logger.Panic(...)`

Всегда вызывайте `Sync()` при завершении программы.