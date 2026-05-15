# Тестирование WebSocket-серверов

Тестировать WebSocket-сервер можно несколькими способами.

## 1. Использование `httptest.Server`

Запускаем тестовый HTTP-сервер с нашим WebSocket-обработчиком и подключаемся к нему обычным WS-клиентом.

```go
func TestEcho(t *testing.T) {
    srv := httptest.NewServer(http.HandlerFunc(wsHandler))
    defer srv.Close()

    u := "ws" + strings.TrimPrefix(srv.URL, "http")
    conn, _, err := websocket.DefaultDialer.Dial(u, nil)
    if err != nil {
        t.Fatal(err)
    }
    defer conn.Close()

    // отправка и проверка сообщения
    err = conn.WriteMessage(websocket.TextMessage, []byte("hello"))
    if err != nil {
        t.Fatal(err)
    }
    _, msg, err := conn.ReadMessage()
    if err != nil {
        t.Fatal(err)
    }
    if string(msg) != "hello" {
        t.Errorf("expected hello, got %s", msg)
    }
}
```

## 2. Использование горутин и sync.WaitGroup
Если нужно имитировать несколько клиентов, запускайте горутины с `sync.WaitGroup`.

## 3. Мокирование зависимостей
Если WebSocket-хендлер зависит от внешних сервисов (база, брокер), внедряйте интерфейсы и мокируйте их в тестах.

## 4. Интеграционные тесты с реальными библиотеками
Для сложных сценариев (чат, pub/sub) можно написать тест, запускающий реальный сервер на случайном порту и подключающий нескольких клиентов. Убедитесь, что тесты изолированы и не используют стандартные порты.

## Best practices
* Всегда закрывайте соединения в тестах.
* Устанавливайте контекст с таймаутом, чтобы тест не завис.
* Проверяйте не только успешный сценарий, но и обрыв соединения, некорректные данные.