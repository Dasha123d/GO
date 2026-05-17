# CORS и безопасность

Cross-Origin Resource Sharing (CORS) управляет доступом к ресурсам с других доменов. Без правильных заголовков браузеры блокируют запросы из JavaScript.

## Основные заголовки

- `Access-Control-Allow-Origin` — разрешённый источник.
- `Access-Control-Allow-Methods` — методы (GET, POST, PUT, DELETE).
- `Access-Control-Allow-Headers` — разрешённые заголовки.
- `Access-Control-Allow-Credentials` — передача куки/учётных данных.
- `Access-Control-Max-Age` — кеширование preflight-запроса.

## Реализация

```go
func CORS(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusNoContent)
            return
        }
        next.ServeHTTP(w, r)
    })
}
```

## Динамический origin
Для поддержки нескольких доменов проверяйте заголовок `Origin` запроса и устанавливайте его в ответе, если он разрешён.

## Безопасность
* Не используйте `*` вместе с `Access-Control-Allow-Credentials: true`.
* Ограничивайте методы и заголовки только необходимыми.
* Обязательно обрабатывайте preflight-запросы.

Пример в `examples/cors-handler.go`.