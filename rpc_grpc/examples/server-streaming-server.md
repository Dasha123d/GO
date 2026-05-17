# Пример: server-streaming сервер

Файл: `server-streaming-server.go`

## Назначение
Сервер принимает запрос с количеством элементов и отправляет поток ответов с индексами. Демонстрирует server-side streaming.

## Запуск
```bash
go run server-streaming-server.go
```
Сервер слушает `:50052`. Для тестирования используйте клиент `server-streaming-client.go`.