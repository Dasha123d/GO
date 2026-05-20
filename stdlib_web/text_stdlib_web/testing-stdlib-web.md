# Тестирование HTTP-сервисов

Пакет `net/http/httptest` позволяет тестировать HTTP-обработчики без запуска реального сервера.

## Тестирование обработчика

```go
func TestHandler(t *testing.T) {
    req := httptest.NewRequest("GET", "/", nil)
    w := httptest.NewRecorder()
    handler(w, req)

    resp := w.Result()
    body, _ := io.ReadAll(resp.Body)
    if resp.StatusCode != http.StatusOK {
        t.Errorf("expected 200, got %d", resp.StatusCode)
    }
}
```
## Тестирование с использованием тестового сервера
```go
func TestClient(t *testing.T) {
    server := httptest.NewServer(http.HandlerFunc(handler))
    defer server.Close()

    resp, err := http.Get(server.URL)
    if err != nil {
        t.Fatal(err)
    }
    defer resp.Body.Close()
    // проверки...
}
```

## Рекомендации
* Используйте `httptest.NewRecorder` для unit-тестов обработчиков.
* Используйте `httptest.NewServer` для интеграционных тестов.
* Проверяйте статус-коды, заголовки и тело ответа.

Примеры тестов включены в документацию к `examples/simple-server.md`.