# Пример: Простые метрики

Файл: `examples/basic-metrics.go`

```go
func main() {
    counter := prometheus.NewCounter(prometheus.CounterOpts{
        Name: "app_starts_total", Help: "Total application starts",
    })
    prometheus.MustRegister(counter)
    counter.Inc()
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":8080", nil)
}
```