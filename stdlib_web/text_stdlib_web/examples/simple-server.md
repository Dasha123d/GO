# Пример: Простейший HTTP-сервер

Файл: `simple-server.go`

## Назначение
Демонстрирует запуск минимального HTTP-сервера с двумя эндпоинтами.

## Запуск
```bash
go run simple-server.go
```
Сервер будет доступен на `http://localhost:8080`.

## Проверка
```bash
curl http://localhost:8080/
# Hello, World!

curl http://localhost:8080/status
# {"status":"ok"}
```
