# Быстрый старт: установка и первые метрики

## Установка

```bash
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promhttp
```
## Минимальный пример
```go
package main

import (
    "net/http"

    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var httpRequestsTotal = prometheus.NewCounterVec(
    prometheus.CounterOpts{
        Name: "http_requests_total",
        Help: "Total number of HTTP requests",
    },
    []string{"path"},
)

func init() {
    prometheus.MustRegister(httpRequestsTotal)
}

func handler(w http.ResponseWriter, r *http.Request) {
    httpRequestsTotal.WithLabelValues(r.URL.Path).Inc()
    w.Write([]byte("Hello, Prometheus!"))
}

func main() {
    http.Handle("/metrics", promhttp.Handler())
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
```
* `NewCounterVec` создаёт счётчик с метками.
* `prometheus.MustRegister` регистрирует метрику в дефолтном реестре.
* `/metrics` отдаёт все метрики в формате Prometheus.

## Проверка
Запустите приложение и откройте `http://localhost:8080/metrics`. Вы увидите:
```text
http_requests_total{path="/"} 1
```