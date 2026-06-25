# Пример: Счётчик и гистограмма

Файл: `examples/metrics-example.go`

```go
func main() {
    mp, _ := initMeterProvider()
    defer mp.Shutdown(context.Background())
    meter := otel.Meter("example")
    counter, _ := meter.Int64Counter("request.count")
    counter.Add(ctx, 1)
}
```