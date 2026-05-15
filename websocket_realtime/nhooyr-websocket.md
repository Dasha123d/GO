# Библиотека nhooyr.io/websocket

Современная библиотека `nhooyr.io/websocket` (автор Anmol Sethi) предлагает минималистичный API, поддержку контекстов и безопасные дефолты.

## Установка

```bash
go get nhooyr.io/websocket
```
## Апгрейд и соединение
```go
import "nhooyr.io/websocket"

func handler(w http.ResponseWriter, r *http.Request) {
    c, err := websocket.Accept(w, r, &websocket.AcceptOptions{
        InsecureSkipVerify: true, // аналог CheckOrigin
    })
    if err != nil {
        log.Println(err)
        return
    }
    defer c.Close(websocket.StatusInternalError, "the sky is falling")

    ctx, cancel := context.WithTimeout(r.Context(), time.Minute)
    defer cancel()

    // чтение/запись
}
```
Метод Accept выполняет апгрейд и возвращает `*websocket.Conn`. Важно: библиотека активно использует контексты для таймаутов.

## Чтение и запись
```go
for {
    typ, msg, err := c.Read(ctx)
    if err != nil {
        break
    }
    // обработка msg ([]byte)
    // ответ
    err = c.Write(ctx, typ, msg)
    if err != nil {
        break
    }
}
```
`Read` принимает контекст, что позволяет прервать блокировку по таймауту или отмене.

## Таймауты и ping/pong
Библиотека автоматически обрабатывает ping-сообщения, поэтому ручное управление не требуется. Для дедлайнов используйте контекст.

## Закрытие
```go
c.Close(websocket.StatusNormalClosure, "bye")
```
Статус-коды определены в пакете `websocket.StatusNormalClosure`, `StatusGoingAway` и т.д.

## Преимущества перед gorilla
* Меньший размер и зависимости.
* Естественная работа с контекстами.
* Чистый, современный дизайн.
* Автоматическая обработка контрольных кадров.
* Однако gorilla/websocket всё ещё предоставляет больше возможностей для тонкой настройки (например, ручное управление ping/pong).