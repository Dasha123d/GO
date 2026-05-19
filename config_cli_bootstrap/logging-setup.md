# Инициализация логгера

Логирование — важная часть bootstrap. В Go современный подход — использовать структурированный логгер `log/slog` (с Go 1.21+) или сторонние (`zerolog`, `zap`).

## Инициализация slog

```go
func initLogger(level string) *slog.Logger {
    var l slog.Level
    switch level {
    case "debug": l = slog.LevelDebug
    case "info":  l = slog.LevelInfo
    default:      l = slog.LevelInfo
    }
    handler := slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: l})
    return slog.New(handler)
}
```
Можно настроить JSON-формат: `slog.NewJSONHandler`.

## Интеграция с конфигурацией
Уровень логирования задаётся в конфигурации. Пример:
```yaml
log_level: debug
```
## Замена стандартного логгера
При использовании сторонних библиотек (Gin, gRPC) может потребоваться адаптировать их вывод. Обычно они принимают интерфейс, совместимый со стандартным `log.Logger`, или свой кастомный.

## Пример в bootstrap
Смотрите `examples/bootstrap.go` — там логгер инициализируется и передаётся в компоненты.

## Best practices
* Не пишите в лог до инициализации — используйте `fmt.Fprintf`(os.Stderr) для фатальных ошибок.
* Устанавливайте глобальный логгер для пакетов, которым логгер не передаётся явно (но лучше передавать).
* В тестах используйте `slog.New(slog.NewTextHandler(io.Discard, nil))` или буфер.