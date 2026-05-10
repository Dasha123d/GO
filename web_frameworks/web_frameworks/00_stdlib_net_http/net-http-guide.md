# net/http: Базовое руководство

## Источник
- [pkg.go.dev/net/http](https://pkg.go.dev/net/http)
- [Go by Example: HTTP Servers](https://gobyexample.com/http-servers)

## Концепция
`net/http` — ядро веб-разработки в Go. Все фреймворки строятся поверх его интерфейсов:
- `http.Handler` — основной контракт для обработки запросов
- `http.ServeMux` — стандартный мультиплексор маршрутов
- `http.ResponseWriter` + `*http.Request` — сигнатура хендлера

## Минимальный сервер
```go
package main
import "net/http"

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("Hello from stdlib"))
    })
    http.ListenAndServe(":8080", nil)
}
