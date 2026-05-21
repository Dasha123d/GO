package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gorilla/mux"
)

// === Ключ для контекста ===
type contextKey string

const userIDKey contextKey = "userID"

// === Logging Middleware ===
func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		log.Printf("→ %s %s", r.Method, r.URL.Path)

		// Вызов следующего обработчика
		next.ServeHTTP(w, r)

		log.Printf("← %s %s (%v)", r.Method, r.URL.Path, time.Since(start))
	})
}

// === CORS Middleware ===
func CORSMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// === Auth Middleware с параметром ===
func AuthMiddleware(requiredRole string) mux.MiddlewareFunc {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			token := r.Header.Get("Authorization")
			if token != "secret-"+requiredRole {
				http.Error(w, "Unauthorized", http.StatusUnauthorized)
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

// === UserID Middleware (передача через контекст) ===
func UserIDMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		userID := vars["id"]

		ctx := context.WithValue(r.Context(), userIDKey, userID)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// === Recovery Middleware ===
func RecoveryMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				log.Printf("🚨 Panic recovered: %v", err)
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

// === Simple Rate Limiter ===
type RateLimiter struct {
	requests map[string]int
	mu       sync.Mutex
}

func NewRateLimiter() *RateLimiter {
	return &RateLimiter{requests: make(map[string]int)}
}

func (rl *RateLimiter) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		rl.mu.Lock()
		defer rl.mu.Unlock()

		ip := r.RemoteAddr
		rl.requests[ip]++

		if rl.requests[ip] > 10 {
			http.Error(w, "Rate limit exceeded (10 req/min)", http.StatusTooManyRequests)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// === Обработчики ===
func PublicHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "🌍 Public endpoint")
}

func ProtectedHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "🔐 Protected endpoint - accessed successfully")
}

func UserHandler(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(userIDKey).(string)
	fmt.Fprintf(w, "👤 User endpoint - ID: %s", userID)
}

func PanicHandler(w http.ResponseWriter, r *http.Request) {
	panic("Simulated panic for recovery demo!")
}

func main() {
	r := mux.NewRouter()
	limiter := NewRateLimiter()

	// Глобальные middleware
	r.Use(LoggingMiddleware)
	r.Use(RecoveryMiddleware)

	// Публичные маршруты
	r.HandleFunc("/", PublicHandler).Methods("GET")

	// Защищённые маршруты с аутентификацией
	protected := r.PathPrefix("/protected").Subrouter()
	protected.Use(AuthMiddleware("user"))
	protected.HandleFunc("/data", ProtectedHandler).Methods("GET")

	// Маршруты с передачей данных через контекст
	r.HandleFunc("/users/{id}", UserHandler).
		Methods("GET").
		Handlers(UserIDMiddleware)

	// Маршрут с rate limiting
	r.HandleFunc("/limited", PublicHandler).
		Methods("GET").
		Handlers(limiter.Middleware)

	// Маршрут для демонстрации recovery
	r.HandleFunc("/panic", PanicHandler).Methods("GET")

	// CORS для API
	api := r.PathPrefix("/api").Subrouter()
	api.Use(CORSMiddleware)
	api.HandleFunc("/data", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, `{"data":"example"}`)
	}).Methods("GET")

	log.Println("⚙️ Middleware demo on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", r))
}
