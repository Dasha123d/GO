# Контекстные поля и обогащение логов

## Добавление полей в контекст

```go
logger := zerolog.New(os.Stdout).With().
    Str("service", "auth").
    Str("environment", "stage").
    Logger()

logger.Info().Msg("сервис запущен")
// выведет: {"level":"info","service":"auth","environment":"stage","message":"сервис запущен"}
```
Все последующие сообщения будут включать эти поля.

## Временное добавление полей
```go
logger.Info().
    Str("request_id", "abc123").
    Int("user_id", 42).
    Msg("запрос обработан")
```
Поля не сохраняются для следующего сообщения.

## Обогащение контекста в middleware
Создайте новый логгер на основе родительского и положите в контекст запроса:
```go
func handler(l zerolog.Logger) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        l := l.With().Str("request_id", r.Header.Get("X-Request-Id")).Logger()
        l.Info().Msg("обработка запроса")
    }
}
```
## Переопределение глобальных полей
Если нужно добавить поля во все сообщения (например, hostname), используйте глобальный логгер с контекстом:
```go
hostname, _ := os.Hostname()
log.Logger = log.With().Str("host", hostname).Logger()
```
## Строгая типизация полей
Всегда используйте типизированные методы (`Str`, `Int`, `Bool`, `Time`, `Dur`, `Err` и т.д.), чтобы избежать аллокаций и ошибок. Не передавайте interface{} без крайней необходимости.

## Вложенные объекты
```go
log.Info().
    Dict("user", zerolog.Dict().
        Str("name", "Alice").
        Int("age", 30)).
    Msg("пользователь создан")
```