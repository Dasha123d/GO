# Пример: Rate limiter middleware

Файл: `rate-limiter.go`

## Назначение
Простой rate limiter, реализующий алгоритм «token bucket» на основе IP-адреса клиента. По умолчанию: 5 запросов в 10 секунд. При превышении возвращает `429 Too Many Requests`.

## Запуск
```bash
go run rate-limiter.go
```
Быстрая проверка (6 запросов подряд):
```bash
for i in {1..6}; do curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/; done
```
Пятый вернёт 200, шестой — 429.