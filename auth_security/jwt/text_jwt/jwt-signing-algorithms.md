# Алгоритмы подписи и выбор ключей

## Обзор поддерживаемых алгоритмов

- **HMAC** (HS256, HS384, HS512) – симметричный ключ, быстрый. Один ключ и на подпись, и на проверку.
- **RSA** (RS256, RS384, RS512) – асимметричный. Приватный ключ подписывает, публичный проверяет.
- **ECDSA** (ES256, ES384, ES512) – асимметричный, компактнее RSA при равной стойкости.
- **Ed25519** (EdDSA) – современный, рекомендуется.

## HS256: симметричный ключ

```go
key := []byte("supersecret")
token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
signed, _ := token.SignedString(key)
```
## RS256: загрузка из файлов
```go
import "crypto/rsa"
import "os"

var (
	privateKey *rsa.PrivateKey
	publicKey  *rsa.PublicKey
)

func init() {
	privBytes, _ := os.ReadFile("private.pem")
	privateKey, _ = jwt.ParseRSAPrivateKeyFromPEM(privBytes)

	pubBytes, _ := os.ReadFile("public.pem")
	publicKey, _ = jwt.ParseRSAPublicKeyFromPEM(pubBytes)
}

// Подпись
token := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)
signed, _ := token.SignedString(privateKey)

// Проверка
parsed, _ := jwt.Parse(signed, func(t *jwt.Token) (interface{}, error) {
	return publicKey, nil
})
```

## Рекомендации
* Для сервисов с одним потребителем (внутренний API) – HS256 достаточно.
* Для публичных API, где токен проверяют несколько сторон – RS256 или ES256.
* Используйте `Ed25519` для новых проектов, если все клиенты его поддерживают.