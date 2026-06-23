# Быстрый старт: установка и первый токен

## Установка

```bash
go get github.com/golang-jwt/jwt/v5
```
## Первый токен (HS256)
Самый простой способ – симметричный ключ и `MapClaims`.
```go
package main

import (
	"fmt"
	"time"
	"github.com/golang-jwt/jwt/v5"
)

func main() {
	key := []byte("my-secret-key")

	// Создаём токен с claims
	claims := jwt.MapClaims{
		"sub":  "1234567890",
		"name": "John Doe",
		"iat":  time.Now().Unix(),
		"exp":  time.Now().Add(5 * time.Minute).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := token.SignedString(key)
	if err != nil {
		panic(err)
	}
	fmt.Println("Токен:", signed)

	// Парсим обратно
	parsed, err := jwt.Parse(signed, func(t *jwt.Token) (interface{}, error) {
		return key, nil
	})
	if err != nil {
		panic(err)
	}
	fmt.Println("Claims:", parsed.Claims)
}
```

