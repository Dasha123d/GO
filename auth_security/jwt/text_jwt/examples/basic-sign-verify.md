# Пример: создание и проверка HS256

Файл: `examples/basic-sign-verify.go`

Этот пример показывает простейшую схему с симметричным ключом.

```go
package main

import (
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func main() {
	secret := []byte("my-256-bit-secret")

	// 1. Создание токена
	claims := jwt.MapClaims{
		"sub": "user123",
		"exp": time.Now().Add(5 * time.Minute).Unix(),
		"iat": time.Now().Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(secret)
	if err != nil {
		panic(err)
	}
	fmt.Println("Создан токен:", tokenString)

	// 2. Проверка
	parsed, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
		// Проверка алгоритма
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("неверный метод: %v", t.Header["alg"])
		}
		return secret, nil
	})
	if err != nil {
		panic(err)
	}

	if claims, ok := parsed.Claims.(jwt.MapClaims); ok && parsed.Valid {
		fmt.Println("Токен валиден, sub:", claims["sub"])
	}
}
```
### Запуск:
```bash
go run examples/basic-sign-verify.go
```