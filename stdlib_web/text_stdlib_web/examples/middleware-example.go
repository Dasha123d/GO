// Цепочка middleware: логирование и базовая аутентификация.
package main

import (
	"log"
	"net/http"
	"time"
)

// Логирующий middleware.
func Logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		log.Printf("%s %s %v", r.Method, r.URL.Path, time.Since(start))
	})
}

// Простой middleware аутентификации.
func Auth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("Authorization")
		if token != "Bearer secret" {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func handler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", handler)

	// Применяем цепочку middleware
	wrapped := Logger(Auth(mux))

	log.Println("Server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", wrapped))
}