# Маршрутизация и обработчики

Начиная с Go 1.22, стандартный `ServeMux` поддерживает продвинутые паттерны маршрутизации.

## Базовые маршруты

```go
mux := http.NewServeMux()
mux.HandleFunc("/", homeHandler)
mux.HandleFunc("/items", itemsHandler)
```
## Методы HTTP
Можно указать HTTP-метод прямо в паттерне:
```go
mux.HandleFunc("GET /items/{id}", getItem)   // только GET
mux.HandleFunc("POST /items", createItem)    // только POST
```

## Параметры пути
Для извлечения параметров используется метод `Request.PathValue`
```go
mux.HandleFunc("/items/{id}", func(w http.ResponseWriter, r *http.Request) {
    id := r.PathValue("id")
    fmt.Fprintf(w, "Item ID: %s", id)
})
```
## Ограничения
* `ServeMux` не поддерживает регулярные выражения в путях.
* Для сложной маршрутизации можно использовать `gorilla/mux` или `chi`, но в большинстве случаев нового `ServeMux` достаточно.

Смотрите пример в `examples/routing-example.go`.