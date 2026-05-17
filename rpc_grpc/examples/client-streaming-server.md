# Пример: client-streaming сервер

Файл: `client-streaming-server.go`

## Назначение
Сервер получает поток чисел, суммирует их и возвращает результат после закрытия потока клиентом.

## Запуск
```bash
go run client-streaming-server.go
```
Сервер на `:50053`. Используйте `client-streaming-client.go`.