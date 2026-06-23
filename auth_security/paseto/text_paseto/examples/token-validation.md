# Пример: расширенная валидация токенов

Файл: `examples/token-validation.go`

Показывает проверку с issuer, audience, leeway и обработку ошибок.

```go
package main

import (
	"errors"
	"fmt"
	"time"
	"github.com/aidanwoods/paseto"
)

func main() {
	key, _ := paseto.NewV4LocalKey()

	// Создаём токен с iss и aud
	claims := paseto.NewClaims()
	claims.SetIssuer("auth-service")
	claims.SetAudience("api")
	claims.SetExpiration(time.Now().Add(1 * time.Hour))
	claims.SetIssuedAt(time.Now())
	token := paseto.NewToken(claims, nil)
	enc, _ := token.V4Encrypt(key)

	// Валидация с требованиями
	parsed, err := paseto.Parse(enc, key,
		paseto.WithIssuer("auth-service"),
		paseto.WithAudience("api"),
		paseto.WithLeeway(10*time.Second),
	)
	if err != nil {
		switch {
		case errors.Is(err, paseto.ErrExpiredToken):
			fmt.Println("Токен истёк")
		case errors.Is(err, paseto.ErrNotYetValid):
			fmt.Println("Токен ещё не действителен")
		default:
			fmt.Println("Ошибка:", err)
		}
		return
	}
	fmt.Println("Валиден, subject:", parsed.Claims().GetSubject())
}
```