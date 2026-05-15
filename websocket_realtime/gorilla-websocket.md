# Библиотека gorilla/websocket

`github.com/gorilla/websocket` — наиболее широко используемая библиотека WebSocket для Go.

## Установка

```bash
go get github.com/gorilla/websocket
```

## Базовое использование
### Апгрейд HTTP-соединения
```go
import "github.com/gorilla/websocket"

var upgrader = websocket.Upgrader{
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
    CheckOrigin: func(r *http.Request) bool {
        return true // в production проверяйте Origin
    },
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
    conn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println("upgrade error:", err)
        return
    }
    defer conn.Close()
    // работа с conn
}
```
### Чтение и запись сообщений
```go
for {
    messageType, message, err := conn.ReadMessage()
    if err != nil {
        log.Println("read error:", err)
        break
    }
    log.Printf("received: %s", message)

    // эхо-ответ
    err = conn.WriteMessage(messageType, message)
    if err != nil {
        log.Println("write error:", err)
        break
    }
}
```
* `ReadMessage()` блокируется до получения сообщения.
* `WriteMessage()` отправляет сообщение; тип может быть `websocket.TextMessage` или `websocket.BinaryMessage`.
Для конкурентной записи используйте блокировку (мьютекс), так как соединение не поддерживает одновременную запись.

### Управление соединением
* Установка лимитов: `conn.SetReadLimit(maxBytes)`, `conn.SetReadDeadline(t)`, `conn.SetWriteDeadline(t)`.
* Пинг/понг: `conn.SetPongHandler(h)`, отправка пингов вручную через `WriteControl`.
* Закрытие: `conn.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, ""))`

### Обработка ошибок и закрытие
```go
if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
    log.Printf("unexpected close: %v", err)
}
```

### Подпротоколы и сжатие
```go
upgrader.Subprotocols = []string{"chat"}
upgrader.EnableCompression = true
```
После апгрейда выбранный подпротокол доступен через `conn.Subprotocol()`

### Пример эхо-сервера
Полный код см. в `examples/echo-server.go`.

