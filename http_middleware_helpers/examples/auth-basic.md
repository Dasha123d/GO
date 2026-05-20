# Пример: Basic Auth middleware

Файл: `auth-basic.go`

## Назначение
Демонстрирует middleware для HTTP Basic Authentication с постоянной проверкой учётных данных. Использует `subtle.ConstantTimeCompare` для безопасного сравнения паролей.

## Запуск
```bash
go run auth-basic.go
```
Проверка:
```bash
curl -u admin:secret http://localhost:8080/secret
```
Без правильных учётных данных возвращается 401.