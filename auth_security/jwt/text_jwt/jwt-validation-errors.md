# Валидация токенов и обработка ошибок

## Стандартная проверка

При вызове `ParseWithClaims` библиотека автоматически проверяет:
- `exp` – срок действия
- `nbf` – не раньше
- `iat` – не в будущем (опционально)
- `iss` – совпадение издателя (если указано в `WithIssuer`)
- `aud` – получатель (если настроено)

## Пример с проверкой издателя

```go
token, err := jwt.ParseWithClaims(tokenStr, &MyClaims{},
	func(t *jwt.Token) (interface{}, error) { return key, nil },
	jwt.WithIssuer("my-app"),
	jwt.WithLeeway(30*time.Second), // допуск для разницы часов
)
```
## Ошибки
Все ошибки обёрнуты в цепочку. Самые частые:
```go
if errors.Is(err, jwt.ErrTokenExpired) {
	// токен просрочен
}
if errors.Is(err, jwt.ErrTokenNotValidYet) {
	// nbf в будущем
}
if errors.Is(err, jwt.ErrTokenMalformed) {
	// вообще не токен
}
if errors.Is(err, jwt.ErrSignatureInvalid) {
	// подпись не совпадает
}
```
Можно использовать `errors.Is` на ошибке, полученной от `ParseWithClaims`.

## Пользовательская валидация
Если нужно добавить свою логику, переопределите метод `Valid()` в своих claims.
```go
func (c MyClaims) Valid() error {
	// сначала стандартная проверка
	if err := c.RegisteredClaims.Valid(); err != nil {
		return err
	}
	// своя
	if c.Role != "admin" && c.Role != "user" {
		return errors.New("недопустимая роль")
	}
	return nil
}
```
Тогда `ParseWithClaims` будет вызывать эту функцию автоматически.
