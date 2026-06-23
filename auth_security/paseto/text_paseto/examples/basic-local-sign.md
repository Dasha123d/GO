# Пример: локальное шифрование v4.local

```go
package main

import (
	"fmt"
	"time"
	"github.com/aidanwoods/paseto"
)

func main() {
	// Генерация ключа (в реальном коде загружайте из секретов)
	key, _ := paseto.NewV4LocalKey()

	claims := paseto.NewClaims()
	claims.SetSubject("alice")
	claims.SetIssuedAt(time.Now())
	claims.SetExpiration(time.Now().Add(1 * time.Hour))

	token := paseto.NewToken(claims, nil)
	encrypted, _ := token.V4Encrypt(key)
	fmt.Println("Token:", encrypted)

	// Расшифровка
	parsed, _ := paseto.Parse(encrypted, key)
	sub, _ := parsed.Claims().GetSubject()
	fmt.Println("Subject:", sub)
}
```
