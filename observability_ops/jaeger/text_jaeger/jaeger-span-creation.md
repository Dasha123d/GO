# Создание спанов и работа с ними

## Базовый спан

```go
tracer := otel.Tracer("component-name")
ctx, span := tracer.Start(ctx, "operation-name")
defer span.End()
```
## Добавление атрибутов
```go
span.SetAttributes(
    attribute.String("user.id", "12345"),
    attribute.Int("http.status_code", 200),
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
## Вложенные спаны
```go
func parent(ctx context.Context) {
    ctx, span := tracer.Start(ctx, "parent")
    defer span.End()
    child(ctx)
}

func child(ctx context.Context) {
    ctx, span := tracer.Start(ctx, "child")
    defer span.End()
}
```
Контекст автоматически связывает спаны.

## Span Kind
```go
span := trace.SpanFromContext(ctx)
// или указать при создании:
ctx, span := tracer.Start(ctx, "server-op", trace.WithSpanKind(trace.SpanKindServer))
```
Виды: `Server`, `Client`, `Producer`, `Consumer`, `Internal`.