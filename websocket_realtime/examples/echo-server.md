# Пример: эхо-сервер WebSocket

Файл: `echo-server.go`

## Назначение
Демонстрирует минимальный WebSocket-сервер с использованием библиотеки `gorilla/websocket`. Сервер принимает сообщение и отправляет его обратно клиенту.

## Зависимости
- `github.com/gorilla/websocket`

Установка: `go get github.com/gorilla/websocket`

## Запуск
```bash
go run echo-server.go
```
Сервер слушает порт :8080 по пути /echo.

## Проверка
Используйте `wscat` (установка: `npm install -g wscat`):
```bash
wscat -c ws://localhost:8080/echo
```
После подключения вводите любые сообщения — они должны приходить обратно.

Или напишите простого клиента на Go с помощью `gorilla/websocket` и `websocket.DefaultDialer`.