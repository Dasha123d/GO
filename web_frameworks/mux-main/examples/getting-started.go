package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// helloHandler обрабатывает запросы к корню приложения
func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, Gorilla Mux! 🦍")
}

// healthHandler возвращает статус здоровья сервиса
func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, `{"status":"ok","service":"mux-demo"}`)
}

func main() {
	// Создаём новый роутер Mux
	r := mux.NewRouter()

	// Регистрируем простые маршруты
	r.HandleFunc("/", helloHandler).Methods("GET")
	r.HandleFunc("/health", healthHandler).Methods("GET")

	// Запускаем HTTP-сервер на порту 8000
	// Mux реализует http.Handler, поэтому совместим со стандартным сервером
	log.Println("🚀 Server starting on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", r))
}
