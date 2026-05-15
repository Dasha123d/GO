# Управление соединениями и переподключение

WebSocket-соединения нестабильны: сеть рвётся, прокси закрывают неактивные сокеты. Необходимо предусмотреть переподключение и корректное завершение.

## Пинг/понг для keep-alive

Большинство прокси закрывают бездействующие TCP-соединения через 30-60 секунд. Чтобы поддерживать соединение, сервер должен периодически отправлять ping-кадры.

### gorilla/websocket

```go
ticker := time.NewTicker(30 * time.Second)
defer ticker.Stop()
go func() {
    for range ticker.C {
        if err := conn.WriteControl(websocket.PingMessage, nil, time.Now().Add(5*time.Second)); err != nil {
            return
        }
    }
}()
conn.SetPongHandler(func(string) error {
    conn.SetReadDeadline(time.Now().Add(60 * time.Second))
    return nil
})
```
## nhooyr.io/websocket
В этой библиотеке пинги автоматизированы, но можно задать параметры при Accept: `PingInterval`, `PongTimeout`.

## Graceful shutdown сервера
При остановке сервера нужно мягко закрыть все WS-соединения: отправить close-кадр и подождать, пока клиенты ответят. Пример: `examples/graceful-shutdown.go`.
* Используйте `signal.NotifyContext` для перехвата SIGINT/SIGTERM.
* Закрывайте соединения с кодом `StatusGoingAway`.
* Дайте горутинам время завершить обработку через `sync.WaitGroup`.

## Переподключение клиента
Клиент должен обрабатывать разрыв и пытаться переподключиться с экспоненциальной задержкой.

Схема:
```go
for {
    conn, _, err := websocket.DefaultDialer.Dial(ctx, url, nil)
    if err != nil {
        time.Sleep(backoff)
        backoff = min(backoff*2, maxBackoff)
        continue
    }
    backoff = initialBackoff
    // работаем с conn
    // если вышли из цикла чтения – переподключаемся
}
```
Полный пример: `examples/reconnection.go`.

## Ограничения ресурсов
* Установите лимит на размер входящего сообщения: `conn.SetReadLimit(maxSize)`.
* Контролируйте количество соединений на одном сервере.
* Используйте буферизованные каналы, чтобы медленные клиенты не блокировали запись.