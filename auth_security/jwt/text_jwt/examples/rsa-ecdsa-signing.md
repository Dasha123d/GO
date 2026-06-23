# Пример: подпись RSA/ECDSA

Файл: `examples/rsa-ecdsa-signing.go`

Показывает создание токенов с асимметричными ключами (RS256) и их проверку.

Для генерации ключей (необходимо выполнить до запуска):
```bash
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private.pem -out public.pem
```
```go
package main

import (
	"fmt"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func main() {
	privBytes, _ := os.ReadFile("private.pem")
	privKey, _ := jwt.ParseRSAPrivateKeyFromPEM(privBytes)

	pubBytes, _ := os.ReadFile("public.pem")
	pubKey, _ := jwt.ParseRSAPublicKeyFromPEM(pubBytes)

	claims := jwt.RegisteredClaims{
		Subject:   "user42",
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)
	signed, _ := token.SignedString(privKey)
	fmt.Println("RS256 token:", signed)

	// Проверка
	parsed, err := jwt.ParseWithClaims(signed, &jwt.RegisteredClaims{}, func(t *jwt.Token) (interface{}, error) {
		return pubKey, nil
	})
	if err != nil {
		panic(err)
	}
	fmt.Println("Subject:", parsed.Claims.(*jwt.RegisteredClaims).Subject)
}
```
```bash
cd examples
go run rsa-ecdsa-signing.go
```