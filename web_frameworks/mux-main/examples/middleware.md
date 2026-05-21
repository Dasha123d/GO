# Источник: https://github.com/gorilla/mux
# Лицензия: BSD-3-Clause
# Добавлено: 2026-05-20

# Middleware в Gorilla Mux

## Что такое Middleware?
Middleware — это функции, которые выполняются до или после основного обработчика. Используются для:
- Логирования запросов
- Аутентификации и авторизации
- CORS и безопасности
- Сжатия ответов
- Восстановления после паник

## Подключение middleware

### Глобально (ко всем маршрутам)
```go
r := mux.NewRouter()
r.Use(LoggingMiddleware)
r.Use(CORSMiddleware)