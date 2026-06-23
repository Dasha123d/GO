# Валидация токенов и обработка ошибок

## Стандартная валидация

При вызове `paseto.Parse()` библиотека проверяет:
- целостность и подлинность (расшифровка/подпись)
- срок действия (`exp`)
- активация не раньше (`nbf`)
- издатель (`iss`), аудитория (`aud`) – только если они заданы в claims

**Пример с обязательной проверкой издателя и аудитории:**

```go
parsed, err := paseto.Parse(tokenString, key,
	paseto.WithIssuer("my-app"),
	paseto.WithAudience("my-service"),
	paseto.WithLeeway(30*time.Second), // допуск времени
)
if err != nil {
	// обработка
}
```
## Виды ошибок
Библиотека возвращает ошибки, которые можно проверять с помощью `errors.Is`:
```go
if errors.Is(err, paseto.ErrExpiredToken) { ... }
if errors.Is(err, paseto.ErrNotYetValid) { ... }
if errors.Is(err, paseto.ErrInvalidSignature) { ... } // для public
if errors.Is(err, paseto.ErrIncorrectKey) { ... } // неправильный ключ/версия
```
Всегда проверяйте ошибку, даже если токен распарсился без паники.

## Проверка пользовательских claims
После успешного парсинга вы должны сами проверить бизнес-правила:
```go
claims := parsed.Claims()
role, ok := claims.Get("role")
if !ok || role != "admin" {
	return fmt.Errorf("недостаточно прав")
}
```
Можно создать структуру и маппить claims в неё с помощью JSON.