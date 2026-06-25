# Логирование в OpenTelemetry

Стандартный SDK пока не включает полноценный Logs API (находится в стадии `alpha`/`beta`). Рекомендуется использовать bridge или корреляцию с трассировкой через `TraceID` и `SpanID`.

## Корреляция логов с трассировкой

Используйте `span.SpanContext()` для получения идентификаторов и добавьте их в логи:

```go
spanCtx := trace.SpanContextFromContext(ctx)
logrus.WithFields(logrus.Fields{
    "trace_id": spanCtx.TraceID().String(),
    "span_id":  spanCtx.SpanID().String(),
}).Info("request processed")
```
## Bridge для logrus / zap
Можно обернуть логгер в OpenTelemetry-совместимый через `otelzap` или `otellogrus`.
```bash
go get go.opentelemetry.io/contrib/bridges/otelzap
```
```go
import "go.opentelemetry.io/contrib/bridges/otelzap"
logger := zap.NewExample()
otelzap.NewCore("my-service", logger)
```
Теперь логи обогащаются контекстом трассировки автоматически.

## Прямая отправка логов в OTLP (в будущем)
Когда `Logs API` станет стабильным, появится возможность отправлять логи напрямую через `otlploggrpc`.