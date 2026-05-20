# Middleware в стандартной библиотеке

Middleware в Go — это функция, принимающая `http.Handler` и возвращающая новый `http.Handler`.

## Паттерн middleware

```go
func loggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}
```
## Цепочка middleware
```go
func chainMiddleware(handler http.Handler, middlewares ...func(http.Handler) http.Handler) http.Handler {
    for i := len(middlewares) - 1; i >= 0; i-- {
        handler = middlewares[i](handler)
    }
    return handler
}

finalHandler := chainMiddleware(myHandler, loggingMiddleware, authMiddleware)
```
## Популярные middleware
* Логирование: запись метода, URL, статуса и времени обработки.
* Аутентификация: проверка токенов или Basic Auth.
* Восстановление после паники: перехват panic в обработчиках.
* CORS: установка заголовков `Access-Control-Allow-*`.

Смотрите пример в `examples/middleware-example.go`.