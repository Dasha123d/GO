# Введение в HTTP middleware в Go

Middleware — это функция, которая оборачивает `http.Handler` и добавляет сквозную функциональность: логирование, аутентификацию, сжатие, CORS и т.д. Благодаря композиции middleware можно собирать сложные конвейеры обработки запросов.

## Паттерн middleware в Go

Стандартная сигнатура:

```go
func(next http.Handler) http.Handler
```
Middleware принимает следующий обработчик и возвращает новый, который может выполнять код до и после вызова `next.ServeHTTP`.

## Пример простейшего middleware
```go
func Logger(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Println(r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}
```

## Цепочка middleware
Используем вспомогательную функцию:
```go
func Chain(h http.Handler, middleware ...func(http.Handler) http.Handler) http.Handler {
    for i := len(middleware) - 1; i >= 0; i-- {
        h = middleware[i](h)
    }
    return h
}
```
Применение:
```go
finalHandler := Chain(myHandler, Logger, Auth, Recovery)
```
## Middleware в популярных роутерах
* `net/http` — нужно писать вручную или использовать адаптеры.
* `gorilla/mux` — `router.Use(middleware)`.
* `go-chi/chi` — богатый встроенный набор middleware, цепочки через `r.Use()`.