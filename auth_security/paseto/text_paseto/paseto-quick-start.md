# Быстрый старт: установка и первый локальный токен

## Установка

```bash
go get github.com/aidanwoods/paseto
```
Для генерации ключей нам также понадобятся PASERK-ключи (формат PASERK).

## Первый токен (v4.local – симметричное шифрование)
```go
package main

import (
	"fmt"
	"time"

	"github.com/aidanwoods/paseto"
)

func main() {
	// Генерируем случайный 256-битный ключ (для v4.local)
	key, err := paseto.NewV4LocalKey()
	if err != nil {
		panic(err)
	}

	// Создаём токен с утверждениями
	claims := paseto.NewClaims()
	claims.SetSubject("1234567890")
	claims.SetIssuedAt(time.Now())
	claims.SetExpiration(time.Now().Add(5 * time.Minute))

	// Шифруем токен
	token := paseto.NewToken(claims, nil) // footer = nil
	encrypted, err := token.V4Encrypt(key)
	if err != nil {
		panic(err)
	}
	fmt.Println("Encrypted token:", encrypted)

	// Расшифровываем обратно
	parsed, err := paseto.Parse(encrypted, key)
	if err != nil {
		panic(err)
	}
	fmt.Println("Subject:", parsed.Claims().GetSubject())
}
```
Ключ `V4LocalKey` – это 256-битный симметричный ключ, который можно экспортировать/импортировать через строку PASERK:
```go
// Экспорт в строку (PASERK secret)
secret := key.Export()
// Импорт
key, err := paseto.NewV4LocalKeyFrom(secret)
```