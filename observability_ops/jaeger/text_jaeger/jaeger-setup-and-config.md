# Настройка Jaeger-экспортера

## Экспортер через OTLP (рекомендуется)

```go
import (
    "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
)

exporter, err := otlptracegrpc.New(ctx,
    otlptracegrpc.WithEndpoint("jaeger-collector:4317"),
    otlptracegrpc.WithInsecure(),
)
```
## Передача через агента (Thrift, устаревший)
Старый клиент `github.com/uber/jaeger-client-go` больше не рекомендуется. Используйте OTLP.

## Конфигурация TracerProvider
```go
tp := trace.NewTracerProvider(
    trace.WithSampler(trace.AlwaysSample()),
    trace.WithBatcher(exporter,
        trace.WithMaxExportBatchSize(512),
        trace.WithBatchTimeout(5*time.Second),
    ),
    trace.WithResource(resource.NewWithAttributes(
        semconv.SchemaURL,
        semconv.ServiceName("api-gateway"),
        semconv.ServiceVersion("1.0.0"),
        semconv.DeploymentEnvironment("production"),
    )),
)
```
## Переменные окружения
Jaeger SDK автоматически читает стандартные переменные:
* `OTEL_EXPORTER_OTLP_ENDPOINT` — адрес коллектора.
* `OTEL_SERVICE_NAME` — имя сервиса.
* `OTEL_RESOURCE_ATTRIBUTES` — дополнительные атрибуты.

## Настройка сэмплирования
* `trace.AlwaysSample()` — для разработки.
* `trace.ParentBased(trace.TraceIDRatioBased(0.1))` — 10% трейсов в продакшене.