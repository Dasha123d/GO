# Refresh-токены и ротация

## Зачем нужны refresh-токены

Access-токен живёт коротко (15-30 минут), refresh – долго (дни/недели).  
При компрометации access-токена ущерб ограничен временем, а refresh можно отозвать.

## Базовая схема

1. Клиент логинится, получает пару: `access_token` + `refresh_token`.
2. Для запросов к API использует `access_token`.
3. Когда access истекает, клиент отправляет `refresh_token` на endpoint `/refresh`.
4. Сервер проверяет refresh (подпись, срок, не отозван), генерирует новую пару и старый refresh-токен инвалидирует (ротация).
5. Клиент получает новую пару, старый refresh забывает.

## Реализация refresh-токена

```go
type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int    `json:"expires_in"`
}

func generateTokenPair(userID string) (*TokenPair, error) {
	// access: 15 min
	accessClaims := UserClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID,
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	accessToken, _ := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims).SignedString(accessKey)

	// refresh: 7 days + уникальный jti
	refreshClaims := jwt.RegisteredClaims{
		Subject:   userID,
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		ID:        uuid.NewString(), // для инвалидации
	}
	refreshToken, _ := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims).SignedString(refreshKey)

	return &TokenPair{AccessToken: accessToken, RefreshToken: refreshToken, ExpiresIn: 900}, nil
}
```
## Ротация (Refresh Token Rotation)
При успешном обновлении старый refresh-токен помечается как использованный (храним в Redis/БД по `jti`).
Если кто-то попытается использовать уже отозванный refresh – это признак кражи, можно отозвать все refresh-токены пользователя.

## Хранение
Refresh-токены не должны храниться в localStorage. Используйте httpOnly, secure cookie или безопасное хранилище на мобильных устройствах.