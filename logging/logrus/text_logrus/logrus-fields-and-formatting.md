# Поля и форматеры: JSON, текст, кастом

## Добавление данных

```go
log.WithFields(logrus.Fields{
    "user": "Alice",
    "ip":   "192.168.1.10",
}).Info("Успешный вход")
```
Стандартные поля логируются как `key=value`.

## JSON-формат
```go
log.SetFormatter(&logrus.JSONFormatter{})
```
Теперь логи будут в JSON, готовые для парсинга системами сбора (ELK, Loki).

## Настройка JSON
```go
log.SetFormatter(&logrus.JSONFormatter{
    PrettyPrint:     false,   // компактный JSON
    TimestampFormat: time.RFC3339,
    FieldMap: logrus.FieldMap{
        logrus.FieldKeyTime:  "timestamp",
        logrus.FieldKeyLevel: "severity",
        logrus.FieldKeyMsg:   "message",
    },
})
```
## Текстовый формат с настройками
```go
log.SetFormatter(&logrus.TextFormatter{
    FullTimestamp:   true,
    TimestampFormat: "2006-01-02 15:04:05",
    ForceColors:     true,
})
```
## Кастомный форматтер
Реализуйте интерфейс `logrus.Formatter`:
```go
type MyFormatter struct{}
func (f *MyFormatter) Format(entry *logrus.Entry) ([]byte, error) {
    msg := fmt.Sprintf("[%s] %s\n", entry.Level, entry.Message)
    return []byte(msg), nil
}
log.SetFormatter(new(MyFormatter))
```
## Поля с ошибками
Используйте `WithError` для автоматического добавления `"error": err.Error()`:
```go
log.WithError(err).Error("Запрос не удался")
```