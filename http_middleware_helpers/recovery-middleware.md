# Восстановление после паники

Если обработчик паникует, сервер не должен падать — нужно вернуть ошибку 500 и записать лог.

## Простая реализация

```go
func Recovery(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        defer func() {
            if err := recover(); err != nil {
                log.Printf("panic recovered: %v\n%s", err, debug.Stack())
                http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
            }
        }()
        next.ServeHTTP(w, r)
    })
}
```
Функция `debug.Stack()` выводит трассировку стека.

## Использование с chi
chi предоставляет `middleware.Recoverer`, который делает то же самое, но с более детальным форматированием ошибки.

## Дополнительные возможности
* Отправка уведомлений администратору.
* Возврат структурированного JSON с ошибкой.
* Логирование с уровнем `ERROR`.

## Предостережения
Recovery должен быть самым внешним middleware в цепочке, чтобы перехватить панику в любом другом middleware или обработчике.

Пример в `examples/panic-recovery.go`.