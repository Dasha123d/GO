# Хуки: расширение возможностей логирования

## Что такое хук

Хук — это интерфейс, позволяющий реагировать на события логирования. Можно отправлять логи в Elasticsearch, Slack, syslog.

```go
type Hook interface {
    Levels() []logrus.Level
    Fire(*Entry) error
}
```
## Установка хука
```go
log.AddHook(&MySlackHook{})
```
## Пример: хук в файл для ошибок
```go
type ErrorFileHook struct {
    file *os.File
}

func (h *ErrorFileHook) Levels() []logrus.Level {
    return []logrus.Level{logrus.ErrorLevel, logrus.FatalLevel, logrus.PanicLevel}
}

func (h *ErrorFileHook) Fire(entry *logrus.Entry) error {
    line, _ := entry.String()
    _, err := h.file.WriteString(line)
    return err
}

// использование
f, _ := os.OpenFile("errors.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
log.AddHook(&ErrorFileHook{file: f})
```
## Популярные сторонние хуки
* `logrus-elasticsearch` – индексация в Elasticsearch.
* `logrus-sentry` – отправка ошибок в Sentry.
* `logrus-fluentd` – запись в Fluentd.
* `logrus-logstash-hook` – Logstash.
* `logrus-redis-hook` – публикация в Redis.

## Несколько хуков
Можно повесить несколько хуков на один logger, они выполняются независимо.

## Обработка ошибок в хуках
Если `Fire` возвращает ошибку, она логируется в стандартный вывод, чтобы не нарушить работу приложения.

## Асинхронные хуки
Если хук медленный (сеть), реализуйте асинхронную отправку внутри `Fire`, чтобы не блокировать основной поток.