# Collector'ы и кастомные метрики

## Интерфейс Collector

```go
type Collector interface {
    Describe(chan<- *Desc)
    Collect(chan<- Metric)
}
```
Реализовав его, можно публиковать произвольные метрики.

## Пример кастомного коллектора
```go
type versionCollector struct {
    versionDesc *prometheus.Desc
}

func newVersionCollector() *versionCollector {
    return &versionCollector{
        versionDesc: prometheus.NewDesc(
            "myapp_version_info",
            "Application version information",
            []string{"version"},
            nil,
        ),
    }
}

func (c *versionCollector) Describe(ch chan<- *prometheus.Desc) {
    ch <- c.versionDesc
}

func (c *versionCollector) Collect(ch chan<- prometheus.Metric) {
    ch <- prometheus.MustNewConstMetric(
        c.versionDesc,
        prometheus.GaugeValue,
        1,
        "1.2.3",
    )
}

func init() {
    prometheus.MustRegister(newVersionCollector())
}
```
Теперь `/metrics` будет содержать `myapp_version_info{version="1.2.3"} 1`.

## Unregister
```go
prometheus.Unregister(collector)
```
Полезно при пересоздании метрик в тестах или динамической перезагрузке.

## Реестры
По умолчанию используется глобальный `prometheus.DefaultRegisterer`. Для изоляции создавайте свои:
```go
registry := prometheus.NewRegistry()
registry.MustRegister(myMetric)
http.Handle("/metrics", promhttp.HandlerFor(registry, promhttp.HandlerOpts{}))
```