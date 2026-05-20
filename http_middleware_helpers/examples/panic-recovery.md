# Пример: Recovery middleware

Файл: `panic-recovery.go`

## Назначение
Перехватывает панику в любом обработчике, логирует её и стек вызовов, возвращает клиенту `500 Internal Server Error`. Падение сервера предотвращается.

## Запуск
```bash
go run panic-recovery.go
```

Обратитесь к `http://localhost:8080/panic` — получите 500, сервер продолжит работать.