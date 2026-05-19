package main

import (
	"context"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
)

// Timing middleware
func TimingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		duration := time.Since(start)
		println(r.Method, r.URL.Path, duration)
	})
}

// Request ID middleware
func RequestIDMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		reqID := r.Header.Get("X-Request-ID")
		if reqID == "" {
			reqID = "req-" + time.Now().Format("150405")
		}
		w.Header().Set("X-Request-ID", reqID)
		ctx := context.WithValue(r.Context(), "requestID", reqID)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// API Key middleware
func APIKeyMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		apiKey := r.Header.Get("X-API-Key")
		if apiKey != "secret-key" {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func main() {
	r := chi.NewRouter()

	r.Use(TimingMiddleware)
	r.Use(RequestIDMiddleware)

	r.Get("/public", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Public endpoint"))
	})

	r.Group(func(r chi.Router) {
		r.Use(APIKeyMiddleware)
		r.Get("/protected", func(w http.ResponseWriter, r *http.Request) {
			w.Write([]byte("Protected endpoint"))
		})
	})

	http.ListenAndServe(":8080", r)
}
