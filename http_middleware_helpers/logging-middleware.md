# Логирование запросов

Логирующий middleware записывает информацию о запросе и ответе: метод, URL, статус-код, время выполнения.

## Базовая реализация

```go
func LoggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        // обёртка для захвата статуса
        rw := &responseRecorder{ResponseWriter: w, status: http.StatusOK}
        next.ServeHTTP(rw, r)
        log.Printf("%s %s %d %s", r.Method, r.URL.Path, rw.status, time.Since(start))
    })
}
```
`responseRecorder` — структура, сохраняющая код ответа.

## Расширенное логирование
Можно добавить:
* размер ответа,
* IP клиента,
* User-Agent,
* Referer,
* идентификатор запроса (если добавлен ранее).

## Интеграция с chi
Используйте `chi.middleware.Logger` — он уже предоставляет цветной вывод с информацией о запросе.

## Структурированное логирование
В production используют `slog` или `zerolog`. Middleware просто вызывает `slog.Info()` с контекстом запроса.
```go
slog.InfoContext(r.Context(), "request completed",
    "method", r.Method,
    "path", r.URL.Path,
    "status", rw.status,
    "duration", time.Since(start),
)
```
Пример полного кода см. в `examples/basic-logger.go`.