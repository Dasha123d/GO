# Конфигурация zerolog: writer, уровни, форматы

## Создание кастомного логгера

```go
logger := zerolog.New(os.Stdout).With().Timestamp().Logger()
logger.Info().Msg("кастомный логгер")
```
* `Output(w io.Writer)` – куда писать.
* `With()` – создаёт контекст с полями, который можно дополнять.
* `Timestamp()` – добавляет временную метку.
* `Logger()` – возвращает готовый логгер.

## Глобальная настройка
```go
// Уровень для всего приложения
zerolog.SetGlobalLevel(zerolog.InfoLevel)

// Формат времени
zerolog.TimeFieldFormat = time.RFC3339
```
## ConsoleWriter (человекочитаемый вывод)
```go
log.Logger = log.Output(zerolog.ConsoleWriter{
    Out:        os.Stdout,
    TimeFormat: time.RFC3339,
    NoColor:    false,
})
```
Теперь логи будут красивыми в терминале, а не JSON.

## Multi‑уровневый вывод
Можно направить вывод в несколько мест с разными уровнями:
```go
file, _ := os.OpenFile("errors.log", os.O_CREATE|os.O_WRONLY, 0644)
errorWriter := zerolog.New(file).With().Logger()

logger := zerolog.New(zerolog.MultiLevelWriter(
    zerolog.ConsoleWriter{Out: os.Stdout},
    errorWriter,
)).With().Timestamp().Logger()
```
## Динамическое изменение уровня во время работы
Для глобального логгера:
```go
zerolog.SetGlobalLevel(zerolog.DebugLevel)
```
Для экземпляра:
```go
logger = logger.Level(zerolog.WarnLevel)
```
## Сэмплирование (базовое)
```go
sampled := logger.Sample(&zerolog.BasicSampler{N: 10})
```
Пропускает каждое N-е сообщение.