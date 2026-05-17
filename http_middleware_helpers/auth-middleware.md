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
## JWT-аутентификация
Используем библиотеку `github.com/golang-jwt/jwt/v5`.
1. Извлекаем токен из заголовка `Authorization: Bearer <token>`.
2. Проверяем подпись и срок действия.
3. При успехе помещаем claims в контекст запроса.

```go
type contextKey string
const UserContextKey contextKey = "user"

func JWTAuth(secret []byte) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            tokenString := extractBearer(r)
            if tokenString == "" {
                http.Error(w, "missing token", http.StatusUnauthorized)
                return
            }
            token, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
                return secret, nil
            })
            if err != nil || !token.Valid {
                http.Error(w, "invalid token", http.StatusUnauthorized)
                return
            }
            claims := token.Claims.(jwt.MapClaims)
            ctx := context.WithValue(r.Context(), UserContextKey, claims)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```
Примеры: `examples/auth-basic.go`, `examples/auth-jwt.go`.
