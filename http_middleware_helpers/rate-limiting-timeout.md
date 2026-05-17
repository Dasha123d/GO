# Rate limiting и таймауты

## Rate limiting

Ограничение числа запросов от одного клиента за период времени предотвращает злоупотребление. Можно реализовать с помощью алгоритма token bucket или фиксированного окна.

### Token bucket (простой пример)

Используем библиотеку `golang.org/x/time/rate`.

```go
func RateLimiter(limiter *rate.Limiter) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if !limiter.Allow() {
                http.Error(w, "Too Many Requests", http.StatusTooManyRequests)
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```
Либо хранить карту `map[string]*rate.Limiter` для разных IP.

## Таймауты обработки
Устанавливаем контекст с таймаутом, чтобы запрос не висел бесконечно.
```go
func Timeout(timeout time.Duration) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            ctx, cancel := context.WithTimeout(r.Context(), timeout)
            defer cancel()
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```
