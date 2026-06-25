# Метки и векторные метрики

## Зачем нужны метки

Метки (labels) позволяют различать подмножества данных внутри одной метрики: по пути, методу, статусу.

## CounterVec, GaugeVec, HistogramVec

```go
requestCounter = prometheus.NewCounterVec(
    prometheus.CounterOpts{
        Name: "http_requests_total",
        Help: "Total HTTP requests",
    },
    []string{"method", "path", "status"},
)
```
## Использование с метками
```go
requestCounter.WithLabelValues("GET", "/api", "200").Inc()
// или через With
requestCounter.With(prometheus.Labels{
    "method": "GET",
    "path":   "/api",
    "status": "200",
}).Inc()
```
* `WithLabelValues` — порядок значений должен соответствовать объявленным меткам.
* `With(Labels{...})` — имена меток указываются явно, порядок не важен.

## Кардинальность меток
Не используйте в метках значения с неограниченным количеством вариантов (ID пользователей, email, URL с параметрами). Это приводит к взрыву временных рядов.

## CurryWith
Позволяет зафиксировать часть меток заранее:
```go
apiCounter := requestCounter.CurryWith(prometheus.Labels{"path": "/api"})
apiCounter.WithLabelValues("GET", "200").Inc()
```
## DeleteLabelValues / Reset
Для удаления устаревших рядов:
```go
requestCounter.DeleteLabelValues("GET", "/old", "200")
requestCounter.Reset()
```