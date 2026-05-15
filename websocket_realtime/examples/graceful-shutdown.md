# Пример: graceful shutdown WebSocket-сервера

Файл: `graceful-shutdown.go`

## Назначение
Показывает, как корректно остановить HTTP-сервер и все активные WebSocket-соединения при получении сигнала завершения (Ctrl+C или `kill`).

## Запуск
```bash
go run graceful-shutdown.go
```

Сервер слушает порт 8080. После запуска нажмите Ctrl+C — сервер отправит close-кадры и завершится без обрыва соединений.

## Зависимости
* `github.com/gorilla/websocket`