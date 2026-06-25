# Пример: Простой трейсинг

Файл: `examples/basic-tracing.go`

```go
func main() {
    tp, _ := initTracer()
    defer tp.Shutdown(context.Background())

    tracer := otel.Tracer("example")
    ctx, span := tracer.Start(context.Background(), "calculate")
    defer span.End()

    // вложенный спан
    ctx, childSpan := tracer.Start(ctx, "multiply")
    result := multiply(2, 3)
    childSpan.End()

    span.SetAttributes(attribute.Int("result", result))
}

func multiply(a, b int) int { return a * b }
```