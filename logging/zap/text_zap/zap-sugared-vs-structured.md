# SugaredLogger и структурированный Logger

## Два стиля

- **Logger** – производительный, типизированные поля (`zap.String`, `zap.Int`), минимум аллокаций.
- **SugaredLogger** – удобный, printf-подобный (`Infow`, `Infof`, `Info` с полями), чуть медленнее (на 4–10%).

## Конвертация

```go
logger := zap.NewExample()
sugar := logger.Sugar()

// и обратно
plain := sugar.Desugar()
```
## Когда использовать SugaredLogger
* В небольших проектах, где производительность некритична.
* При переходе с logrus/slog.
* В местах, где нужно форматирование `Infof`.

## Производительность
Структурированный Logger быстрее за счёт отсутствия рефлексии. Для высоконагруженных сервисов настоятельно рекомендуется использовать Logger.

## Пример одной и той же записи
### Logger:
```go
logger.Info("запрос", zap.String("method", "GET"), zap.Duration("latency", d))
```
### Sugar:
```go
sugar.Infow("запрос", "method", "GET", "latency", d)
sugar.Infof("запрос method=%s latency=%v", "GET", d)
```
Sugar-форматы проходят через рефлексию, что замедляет, но они удобнее.