# Пример: кастомные Claims и валидация

Файл: `examples/custom-claims.go`

Используем собственную структуру, встраивая `RegisteredClaims`, и добавляем кастомную проверку роли.

```go
package main

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type MyCustomClaims struct {
	jwt.RegisteredClaims
	Role string `json:"role"`
}

// Своя валидация
func (c MyCustomClaims) Valid() error {
	if err := c.RegisteredClaims.Valid(); err != nil {
		return err
	}
	if c.Role != "admin" && c.Role != "user" {
		return errors.New("недопустимая роль")
	}
	return nil
}

func main() {
	key := []byte("secret")

	// Создание
	claims := MyCustomClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   "001",
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    "my-app",
		},
		Role: "admin",
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, _ := token.SignedString(key)
	fmt.Println(signed)

	// Парсинг с кастомной структурой
	parsed, err := jwt.ParseWithClaims(signed, &MyCustomClaims{}, func(t *jwt.Token) (interface{}, error) {
		return key, nil
	})
	if err != nil {
		fmt.Println("Ошибка:", err)
		return
	}
	if c, ok := parsed.Claims.(*MyCustomClaims); ok && parsed.Valid {
		fmt.Println("Роль:", c.Role)
	}
}
```
### Запуск:
```bash
go run examples/custom-claims.go
```