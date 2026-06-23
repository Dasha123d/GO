# Версии Paseto и работа с утверждениями

## Поддерживаемые версии

Библиотека `aidanwoods/paseto` полностью поддерживает:

- `v2.local` / `v2.public` – основана на XChaCha20-Poly1305 / Ed25519  
- `v3.local` / `v3.public` – NIST-алгоритмы (AES-256-CTR + HMAC-SHA384 / ECDSA P-384)  
- `v4.local` / `v4.public` – современные алгоритмы (XChaCha20-BLAKE2b / Ed25519)

Рекомендуемая версия: **v4** для новых проектов.

## Утверждения (Claims)

Paseto не имеет жёсткой структуры как JWT, но библиотека предоставляет удобный тип `Claims` для стандартных полей:

```go
claims := paseto.NewClaims()
claims.SetSubject("user-001")
claims.SetIssuer("my-app")
claims.SetAudience("my-service")
claims.SetIssuedAt(time.Now())
claims.SetNotBefore(time.Now())
claims.SetExpiration(time.Now().Add(1 * time.Hour))
claims.SetTokenID(uuid.NewString())
// Пользовательские данные
claims.Set("role", "admin")
claims.Set("email", "john@example.com")
```
Внутри это `map[string]interface{}`, проверка JSON-совместимых типов на вашей стороне.

## Footer
Можно добавить незашифрованный/неподписанный footer (например, идентификатор ключа):
```go
footer := []byte("key-id-123")
token := paseto.NewToken(claims, footer)
encrypted, _ := token.V4Encrypt(key)
```
При парсинге footer доступен через parsed.Footer().