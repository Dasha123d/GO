# Тюнинг производительности zap

## Избегайте `SugaredLogger` в горячих путях

Там, где тысячи запросов в секунду, используйте строгий Logger.

## Используйте типизированные поля

`zap.String`, `zap.Int` и т.д. — ноль аллокаций. Не используйте `zap.Any()` без крайней необходимости.

## Ленивые вычисления с `zap.Fields`

Для дорогих операций используйте обёртки:

```go
logger.Debug("статистика", zap.Int("count", expensiveCount()))
```
Если уровень Debug отключен, вызов `expensiveCount()` всё равно произойдёт. Защитите ленивой функцией:
```go
if ce := logger.Check(zap.DebugLevel, "статистика"); ce != nil {
    ce.Write(zap.Int("count", expensiveCount()))
}
```
## Сэмплирование (sampling)
В `NewProduction()` уже включено сэмплирование: для одинаковых сообщений в течение секунды логируется только первое и счётчик. Можно настроить:
```go
zap.WrapCore(func(c zapcore.Core) zapcore.Core {
    return zapcore.NewSamplerWithOptions(c, time.Second, 100, 10)
})
```
Параметры: интервал, первые N сообщений, затем каждое M-е.

## ObjectMarshaler для сложных типов
Если объект часто логируется, реализуйте `zapcore.ObjectMarshaler`:
```go
func (u User) MarshalLogObject(enc zapcore.ObjectEncoder) error {
    enc.AddString("name", u.Name)
    enc.AddInt("age", u.Age)
    return nil
}
logger.Info("пользователь", zap.Object("user", u))
```
Такой подход быстрее, чем `zap.Any`.

## Синхронизация
`Sync()` может быть дорогим. Для критичных систем используйте асинхронные writer'ы с буферизацией.

## Бенчмарки
В синтетических тестах zap быстрее logrus в 4–10 раз и обходит стандартный `log/slog` на структурированных логах.