# Метрики: счётчики, гистограммы, измерения

## Создание Meter

```go
meter := otel.Meter("my-service")
```
## Счётчик (Counter)
```go
requestCount, _ := meter.Int64Counter(
    "http.requests",
    metric.WithDescription("Total number of HTTP requests"),
)

requestCount.Add(ctx, 1, metric.WithAttributes(attribute.String("method", "GET")))
```

## Гистограмма (Histogram)
```go
requestDuration, _ := meter.Float64Histogram(
    "http.duration",
    metric.WithUnit("ms"),
)

start := time.Now()
// ... обработка
requestDuration.Record(ctx, float64(time.Since(start).Milliseconds()))
```
## Наблюдатель (Gauge)
```go
queueSize, _ := meter.Int64ObservableGauge("queue.size")
// регистрируется callback
meter.RegisterCallback(func(_ context.Context, o api.Observer) error {
    o.ObserveInt64(queueSize, int64(len(queue)))
    return nil
}, queueSize)
```
## Экспортер метрик
```go
exporter, _ := otlpmetricgrpc.New(ctx)
reader := sdkmetric.NewPeriodicReader(exporter)
mp := sdkmetric.NewMeterProvider(sdkmetric.WithReader(reader))
otel.SetMeterProvider(mp)
```
Метрики экспортируются периодически.