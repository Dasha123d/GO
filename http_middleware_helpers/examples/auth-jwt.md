# Пример: JWT middleware

Файл: `auth-jwt.go`

## Назначение
Показывает, как проверять JWT-токен из заголовка `Authorization: Bearer ...` и помещать claims в контекст запроса.

## Зависимости
- `github.com/golang-jwt/jwt/v5`

Установка: `go get github.com/golang-jwt/jwt/v5`

## Запуск
```bash
go run auth-jwt.go
```
Сервер напечатает тестовый токен. Используйте его:
```bash
curl -H "Authorization: Bearer <токен>" http://localhost:8080/me
```

Ответ: `Hello, user123`
