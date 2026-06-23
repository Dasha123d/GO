# Local vs Public: симметричное и асимметричное использование

## Local (симметричное)

Использует общий секретный ключ для шифрования и расшифровки. Подходит для внутренних сервисов, где вы контролируете обе стороны.

```go
// Генерация ключа
key, _ := paseto.NewV4LocalKey()

// Шифрование
token := paseto.NewToken(claims, nil)
encrypted, _ := token.V4Encrypt(key)

// Расшифровка
parsed, err := paseto.Parse(encrypted, key)
```
Ключ хранится в секрете, не раскрывается клиенту.

## Public (асимметричное)
Подпись приватным ключом, проверка публичным. Подходит, когда токен должен проверяться другой стороной (клиент, другой сервис), не имея секрета.
```go
// Генерация пары ключей
privKey, pubKey, _ := paseto.NewV4PublicKey()

// Подпись
token := paseto.NewToken(claims, nil)
signed, _ := token.V4Sign(privKey)

// Проверка
parsed, err := paseto.Parse(signed, pubKey)
```
Экспорт/импорт ключей в строковом формате PASERK:
```go
privStr := privKey.Export()
pubStr := pubKey.Export()

privKey, _ = paseto.NewV4PublicKeyFrom(privStr)
pubKey, _ = paseto.NewV4PublicKeyFrom(pubStr)
```

## Когда что использовать
* Local – монолит, микросервисы в доверенной среде, где обе стороны имеют доступ к ключу.
* Public – публичные API, аутентификация пользователей на фронтенде, передача токена между недоверенными сторонами.