# Трассировка: спаны, атрибуты, контекст

## Создание спанов

```go
tracer := otel.Tracer("component-name")
ctx, span := tracer.Start(ctx, "operation-name")
defer span.End()
```
* `otel.Tracer` кешируется, создаётся на старте.
* Контекст передаётся в дочерние вызовы.

## Атрибуты
```go
span.SetAttributes(
    attribute.String("user.id", "123"),
    attribute.Int("http.status_code", 200),
    attribute.Bool("cache.hit", false),
)
```

## События
```go
span.AddEvent("cache.miss", trace.WithAttributes(
    attribute.String("key", "user:123"),
))
```

## Ошибки
```go
if err != nil {
    span.RecordError(err)
    span.SetStatus(codes.Error, err.Error())
}
```
## Span Kind
```go
ctx, span := tracer.Start(ctx, "server-op",
    trace.WithSpanKind(trace.SpanKindServer),
)
```
Виды: `Server`, `Client`, `Producer`, `Consumer`, `Internal`.

## Контекст и передача между сервисами
Контекст распространяется через заголовки (`traceparent`, `tracestate`). OpenTelemetry SDK автоматически инжектит их в HTTP/gRPC запросы через пропагаторы.
```go
import "go.opentelemetry.io/otel/propagation"
otel.SetTextMapPropagator(propagation.TraceContext{})
```
## Сэмплирование
```go
sdktrace.NewTracerProvider(
    sdktrace.WithSampler(sdktrace.ParentBased(sdktrace.TraceIDRatioBased(0.1))),
)
```
* `AlwaysSample` – для разработки.
* `TraceIDRatioBased(0.1)` – 10% в продакшене.