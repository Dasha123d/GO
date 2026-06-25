# Пример: Базовая трассировка

Файл: `examples/basic-tracing.go`

```go
func main() {
    tp, _ := initTracer()
    defer tp.Shutdown(context.Background())
    tracer := otel.Tracer("example")
    ctx, span := tracer.Start(context.Background(), "my-operation")
    defer span.End()
    // ...
}
```