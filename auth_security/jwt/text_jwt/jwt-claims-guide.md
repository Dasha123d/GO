# Claims: стандартные и кастомные

## Стандартные поля (Registered Claims)

Библиотека `jwt` поддерживает все поля RFC 7519:

| Поле | Тип       | Описание                    |
|------|-----------|-----------------------------|
| `iss`| string    | Издатель токена             |
| `sub`| string    | Субъект (обычно ID пользователя) |
| `aud`| []string  | Получатели                  |
| `exp`| *NumericDate* | Время истечения         |
| `nbf`| *NumericDate* | Не раньше                 |
| `iat`| *NumericDate* | Выпущен в                |
| `jti`| string    | Уникальный ID токена        |

Их удобно использовать через встроенный тип `jwt.RegisteredClaims`.

```go
type MyClaims struct {
	jwt.RegisteredClaims
	Role string `json:"role"`
	// другие поля
}
```

## Пример с кастомными claims
```go
type UserClaims struct {
	jwt.RegisteredClaims
	Email  string `json:"email"`
	Groups []string `json:"groups"`
}

func createToken(userID, email string, groups []string) (string, error) {
	claims := UserClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			Issuer:    "my-app",
			Subject:   userID,
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
		Email:  email,
		Groups: groups,
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(mySigningKey)
}
```

## Парсинг в кастомную структуру
```go
func parseToken(tokenString string) (*UserClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &UserClaims{}, func(t *jwt.Token) (interface{}, error) {
		return mySigningKey, nil
	})
	if claims, ok := token.Claims.(*UserClaims); ok && token.Valid {
		return claims, nil
	} else {
		return nil, err
	}
}
```
Всегда проверяйте `token.Valid`, даже если `ParseWithClaims` вернула `nil-ошибку` (ошибки валидации могут быть внутри `Claims.Valid()`).


