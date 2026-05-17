# Пример: bidirectional streaming сервер (чат)

Файл: `bidi-streaming-server.go`

## Назначение
Сервер получает поток сообщений чата и отправляет эхо-ответ каждому клиенту. Демонстрирует двунаправленный стриминг.

## Запуск
```bash
go run bidi-streaming-server.go
```
Слушает `:50054`. Клиент: `bidi-streaming-client.go`.