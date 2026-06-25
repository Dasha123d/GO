# Сэмплирование и хуки

## Сэмплирование

Zerolog поддерживает несколько стратегий сэмплирования для снижения нагрузки в высоконагруженных системах.

### BasicSampler

Пишет каждое N-е сообщение одного уровня:

```go
sampled := logger.Sample(&zerolog.BasicSampler{N: 10})
// будет выводить каждое 10-е сообщение
```
## BurstSampler
Позволяет пропустить первые N сообщений за период, а затем записывать каждое M-е:
```go
sampler := &zerolog.BurstSampler{
    Burst:  100,            // первые 100 сообщений за секунду выводятся все
    Period: 1 * time.Second,
    NextSampler: &zerolog.BasicSampler{N: 5}, // затем каждое 5-е
}
logger := logger.Sample(sampler)
```
## Самодельный Sampler
Реализуйте интерфейс `zerolog.Sampler`:
```go
type CustomSampler struct{}

func (s CustomSampler) Sample(lvl zerolog.Level) bool {
    return lvl <= zerolog.WarnLevel // пропускаем только warn и ниже
}
```

## Хуки
Хуки позволяют реагировать на события логирования, например, отправлять ошибки в Sentry или записывать в отдельный файл.
```go
type SentryHook struct{}

func (h SentryHook) Run(e *zerolog.Event, level zerolog.Level, msg string) {
    if level >= zerolog.ErrorLevel {
        // отправляем в Sentry
        sentry.CaptureMessage(msg)
    }
}

logger := zerolog.New(os.Stderr).Hook(SentryHook{})
```
Хук получает `*zerolog.Event` до записи, может изменить его или выполнить побочное действие.

## Готовые хуки
* zerolog-sentry – интеграция с Sentry.
* zerolog-syslog – запись в syslog.

Установка аналогична добавлению любого другого хука.