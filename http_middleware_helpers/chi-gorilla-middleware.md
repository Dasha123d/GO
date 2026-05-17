# Middleware с chi и gorilla/mux

## gorilla/mux

Маршрутизатор `gorilla/mux` поддерживает middleware через `Use()`.

```go
r := mux.NewRouter()
r.Use(loggingMiddleware)
r.HandleFunc("/", homeHandler)
```
Middleware применяется ко всем маршрутам, зарегистрированным после вызова `Use`. Можно назначить middleware на конкретный подмаршрут с помощью `Subrouter()`.

## go-chi/chi
`chi` поставляется с обширным набором middleware: `chi.middleware.Logger`, `chi.middleware.Recoverer`, `chi.middleware.Timeout`, `chi.middleware.RealIP` и др.
```go
r := chi.NewRouter()
r.Use(middleware.Logger)
r.Use(middleware.Recoverer)
r.Use(middleware.Timeout(30 * time.Second))

r.Get("/", handler)
```
Также можно создавать группы маршрутов со своим middleware:
```go
r.Route("/admin", func(r chi.Router) {
    r.Use(AdminAuth)
    r.Get("/", adminDashboard)
})
```
chi middleware сигнатура совместима со стандартной: `func(http.Handler) http.Handler`.

## Преимущества использования роутера
* Готовые проверенные middleware.
* Удобное разделение на группы.
* Встроенная обработка контекста запроса (например, извлечение параметров).