# Конфигурация zap: пресеты, кастомный config, энкодеры

## Пресеты

- `zap.NewProduction()` – JSON, Info, сэмплинг, таймстемпы в epoch.
- `zap.NewDevelopment()` – текст, Debug, цветной, детальные стектрейсы.
- `zap.NewExample()` – упрощённый вывод для тестов.

## Кастомная настройка через `zap.Config`

```go
cfg := zap.Config{
    Level:             zap.NewAtomicLevelAt(zap.InfoLevel),
    Development:       false,
    Encoding:          "json",
    OutputPaths:       []string{"stdout", "/var/log/app.log"},
    ErrorOutputPaths:  []string{"stderr"},
    EncoderConfig: zap.NewProductionEncoderConfig(),
}
logger, _ := cfg.Build()
```
## EncoderConfig
Тонкая настройка вывода полей:
```go
cfg.EncoderConfig = zapcore.EncoderConfig{
    TimeKey:        "ts",
    LevelKey:       "level",
    NameKey:        "logger",
    CallerKey:      "caller",
    MessageKey:     "msg",
    StacktraceKey:  "stacktrace",
    LineEnding:     zapcore.DefaultLineEnding,
    EncodeTime:     zapcore.ISO8601TimeEncoder,
    EncodeLevel:    zapcore.CapitalLevelEncoder,
    EncodeDuration: zapcore.SecondsDurationEncoder,
    EncodeCaller:   zapcore.ShortCallerEncoder,
}
```
## Подключение нескольких output'ов
`OutputPaths` может содержать несколько путей (stdout, файлы). Для ротации используйте `lumberjack`:
```go
import "gopkg.in/natefinch/lumberjack.v2"
writer := zapcore.AddSync(&lumberjack.Logger{
    Filename:   "/var/log/app.log",
    MaxSize:    100, // MB
    MaxBackups: 3,
    MaxAge:     7, // days
})
core := zapcore.NewCore(encoder, writer, level)
logger := zap.New(core)
```
## Динамическое изменение уровня
```go
atomicLevel := zap.NewAtomicLevelAt(zap.InfoLevel)
logger := zap.New(... , atomicLevel)
// потом
atomicLevel.SetLevel(zap.WarnLevel)
```
Удобно для переключения уровня в рантайме без перезапуска.