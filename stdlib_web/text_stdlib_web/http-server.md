# HTTP-сервер: ListenAndServe, Handler

Для запуска HTTP-сервера в Go используется функция `http.ListenAndServe`[reference:11].

## Простейший сервер

```go
http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
})
log.Fatal(http.ListenAndServe(":8080", nil))
```
Если в `ListenAndServe` передан `nil` в качестве обработчика, используется `DefaultServeMux` — глобальный маршрутизатор стандартной библиотеки.

## Кастомный сервер
Для более тонкой настройки (таймауты, размер заголовков) создаётся экземпляр `http.Server`
```go
s := &http.Server{
    Addr:           ":8080",
    Handler:        myHandler,
    ReadTimeout:    10 * time.Second,
    WriteTimeout:   10 * time.Second,
    MaxHeaderBytes: 1 << 20,
}
log.Fatal(s.ListenAndServe())
```
## HTTP/2
Пакет net/http имеет прозрачную поддержку HTTP/2. При использовании TLS и `ListenAndServeTLS`, сервер автоматически активирует HTTP/2. Управлять протоколами можно через поле `Server.Protocols`.

Смотрите пример в `examples/simple-server.go`.