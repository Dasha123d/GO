# Аутентификация (Basic, JWT)

Middleware для проверки прав доступа может реализовывать различные схемы.

## Basic Authentication

Извлекаем заголовок `Authorization`, декодируем Base64, сверяем с допустимыми учётными данными.

```go
func BasicAuth(next http.Handler, creds map[string]string) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        user, pass, ok := r.BasicAuth()
        if !ok || creds[user] != pass {
            w.Header().Set("WWW-Authenticate", `Basic realm="restricted"`)
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        next.ServeHTTP(w, r)
    })
}
```

