# Стандартный паттерн middleware (только net/http)

Без сторонних библиотек можно строить цепочки middleware, используя функции-обёртки.

## Создание middleware

```go
func RequestID(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        id := uuid.New().String()
        w.Header().Set("X-Request-ID", id)
        next.ServeHTTP(w, r)
    })
}
```
## Объединение в цепочку
```go
type Middleware func(http.Handler) http.Handler

func Use(h http.Handler, mw ...Middleware) http.Handler {
    for i := len(mw) - 1; i >= 0; i-- {
        h = mw[i](h)
    }
    return h
}

handler := Use(
    http.HandlerFunc(finalHandler),
    RequestID,
    Logger,
    Recovery,
)
http.ListenAndServe(":8080", handler)
```

## Вложенные middleware
Можно оборачивать вручную:
```go
h := RequestID(Logger(Recovery(finalHandler)))
```

## Захват ответа (response wrapper)
Для логирования статуса нужна обёртка `http.ResponseWriter`, переопределяющая `WriteHeader`:
```go
type responseData struct {
    status int
    size   int
}

type loggingResponseWriter struct {
    http.ResponseWriter
    data *responseData
}

func (w *loggingResponseWriter) WriteHeader(statusCode int) {
    w.data.status = statusCode
    w.ResponseWriter.WriteHeader(statusCode)
}

func (w *loggingResponseWriter) Write(b []byte) (int, error) {
    size, err := w.ResponseWriter.Write(b)
    w.data.size += size
    return size, err
}
```
Это позволяет middleware получить статус ответа после выполнения обработчика.

Далее мы рассмотрим интеграцию с популярными роутерами.