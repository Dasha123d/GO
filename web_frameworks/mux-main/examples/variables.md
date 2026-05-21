# Источник: https://github.com/gorilla/mux
# Лицензия: BSD-3-Clause
# Добавлено: 2026-05-20

# Переменные URL и извлечение параметров

## Извлечение переменных пути
Используйте `mux.Vars(r)` для получения карты параметров:

```go
r.HandleFunc("/users/{id}", func(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]
    fmt.Fprintf(w, "User ID: %s", id)
})