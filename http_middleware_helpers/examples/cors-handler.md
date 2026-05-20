# Пример: CORS middleware

Файл: `cors-handler.go`

## Назначение
Добавляет необходимые CORS-заголовки ко всем ответам и обрабатывает preflight-запросы (OPTIONS), возвращая `204 No Content`.

## Запуск
```bash
go run cors-handler.go
```
Проверка (с другого origin):
```bash
curl -H "Origin: http://example.com" -X OPTIONS http://localhost:8080/api -v
```
