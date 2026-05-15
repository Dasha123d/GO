# Пример: Кэширование с Redis

Файл: `redis-cache.go`

## Назначение
Демонстрация сохранения и чтения JSON-объекта в Redis с установкой времени жизни (TTL). Используется клиент `go-redis/v9`.

## Зависимости
- `github.com/redis/go-redis/v9`

Установите: `go get github.com/redis/go-redis/v9`

## Требования
Запущенный сервер Redis (по умолчанию на `localhost:6379`). Если через Docker:
```bash
docker run -d --name redis -p 6379:6379 redis:7-alpine
```

## Запуск
```bash
go run redis-cache.go
```

## Ожидаемый вывод
```text
Подключено к Redis
Объект сохранён в кэш с TTL 30s
Из кэша: {ID:101 Name:Ноутбук Price:999.99}
Оставшееся время жизни ключа: 29s
```

