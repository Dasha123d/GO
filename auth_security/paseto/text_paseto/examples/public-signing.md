# Пример: публичная подпись v4.public


```go
package main

import (
	"fmt"
	"time"
	"github.com/aidanwoods/paseto"
)

func main() {
	priv, pub, _ := paseto.NewV4PublicKey()

	claims := paseto.NewClaims()
	claims.SetSubject("bob")
	claims.SetExpiration(time.Now().Add(30 * time.Minute))

	token := paseto.NewToken(claims, nil)
	signed, _ := token.V4Sign(priv)
	fmt.Println("Signed token:", signed)

	// Проверка с публичным ключом
	parsed, err := paseto.Parse(signed, pub)
	if err != nil {
		panic(err)
	}
	sub, _ := parsed.Claims().GetSubject()
	fmt.Println("Verified subject:", sub)
}
```