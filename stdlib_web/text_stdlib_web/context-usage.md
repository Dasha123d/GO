# Пакет context в веб-приложениях

Пакет `context` неразрывно связан с `net/http`. Каждый HTTP-запрос содержит контекст (`r.Context()`), который несёт дедлайны, сигналы отмены и значения[reference:16].

## Основные функции

- `context.WithCancel` — ручная отмена.
- `context.WithTimeout` — автоматическая отмена через заданное время.
- `context.WithValue` — передача значений.

## Использование с HTTP

```go
func handler(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    // создаём дочерний контекст с таймаутом
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()

    // передаём в вызовы к базе данных или внешним сервисам
    user, err := fetchUser(ctx, userID)
    if err != nil {
        http.Error(w, "request timeout", http.StatusGatewayTimeout)
        return
    }
    // ...
}
```
## Важные правила
* Не храните контексты в структурах, передавайте их явно первым аргументом.
* Не передавайте `nil` — используйте `context.TODO`, если контекст не определён.
* Используйте `context.WithValue` только для данных, живущих в пределах запроса.

Пример работы с контекстом интегрирован в `examples/template-server.go`.