# Источник: https://github.com/gorilla/mux
# Лицензия: BSD-3-Clause
# Добавлено: 2026-05-20

# Маршрутизация в Gorilla Mux

## Базовое сопоставление маршрутов
Mux проверяет маршруты в порядке регистрации и использует первый подходящий.

```go
r := mux.NewRouter()

// Статический путь
r.HandleFunc("/users", GetUsers).Methods("GET")

// С методом
r.HandleFunc("/users", CreateUser).Methods("POST")

// С несколькими методами
r.HandleFunc("/items", ItemHandler).Methods("GET", "POST", "PUT")