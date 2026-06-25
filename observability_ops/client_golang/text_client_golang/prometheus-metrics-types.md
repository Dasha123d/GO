# Типы метрик: Counter, Gauge, Histogram, Summary

## Counter (счётчик)

Только увеличивается (или сбрасывается). Подходит для подсчёта запросов, ошибок, байтов.

```go
counter := prometheus.NewCounter(prometheus.CounterOpts{
    Name: "myapp_events_total",
    Help: "Total number of events",
})
counter.Inc()
counter.Add(5)
```
## Gauge (датчик)
Может увеличиваться и уменьшаться. Подходит для температуры, числа активных соединений.
```go
gauge := prometheus.NewGauge(prometheus.GaugeOpts{
    Name: "myapp_active_connections",
    Help: "Current number of active connections",
})
gauge.Set(42)
gauge.Inc()
gauge.Dec()
```
## Histogram (гистограмма)
Наблюдения распределяются по заранее заданным интервалам (buckets). Подходит для длительности запросов, размеров ответов.
```go
histogram := prometheus.NewHistogram(prometheus.HistogramOpts{
    Name:    "http_request_duration_seconds",
    Help:    "HTTP request duration in seconds",
    Buckets: prometheus.DefBuckets, // .005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10
})
histogram.Observe(0.42)
```
## Summary (сводка)
Похожа на гистограмму, но вычисляет квантили на клиентской стороне (дороже по CPU). Обычно предпочтительнее гистограммы.
```go
summary := prometheus.NewSummary(prometheus.SummaryOpts{
    Name:       "http_request_duration_summary_seconds",
    Help:       "HTTP request duration summary in seconds",
    Objectives: map[float64]float64{0.5: 0.05, 0.9: 0.01, 0.99: 0.001},
})
summary.Observe(0.15)
```
Все типы поддерживают векторы с метками (Vec).