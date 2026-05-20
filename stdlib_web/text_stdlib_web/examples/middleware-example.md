# Пример: Цепочка middleware

Файл: `middleware-example.go`

## Назначение
Показывает, как создавать и комбинировать middleware для логирования и аутентификации запросов без использования сторонних библиотек.

## Запуск
```bash
go run middleware-example.go
```
Проверка:
```bash
curl http://localhost:8080/
# Unauthorized

curl -H "Authorization: Bearer secret" http://localhost:8080/
# OK
```