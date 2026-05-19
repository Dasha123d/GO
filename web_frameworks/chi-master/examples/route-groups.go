package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	r := chi.NewRouter()

	r.Use(middleware.Logger)

	// Public routes
	r.Get("/", homeHandler)
	r.Get("/about", aboutHandler)

	// API v1 group
	r.Route("/api/v1", func(r chi.Router) {
		r.Use(apiVersionMiddleware("v1"))
		r.Get("/status", statusHandler)

		// Protected sub-group
		r.Group(func(r chi.Router) {
			r.Use(basicAuthMiddleware)
			r.Get("/users", listUsersHandler)
			r.Post("/users", createUserHandler)
		})
	})

	// API v2 group (JWT)
	r.Route("/api/v2", func(r chi.Router) {
		r.Use(apiVersionMiddleware("v2"))
		r.Use(jwtMiddleware)
		r.Get("/users", listUsersHandlerV2)
		r.Post("/users", createUserHandlerV2)
	})

	// Admin group
	r.Route("/admin", func(r chi.Router) {
		r.Use(basicAuthMiddleware)
		r.Get("/dashboard", adminDashboardHandler)
		r.Get("/stats", adminStatsHandler)
	})

	http.ListenAndServe(":8080", r)
}

func apiVersionMiddleware(version string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("X-API-Version", version)
			next.ServeHTTP(w, r)
		})
	}
}

func basicAuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		user, pass, ok := r.BasicAuth()
		if !ok || user != "admin" || pass != "password" {
			w.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func jwtMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Простая проверка токена
		auth := r.Header.Get("Authorization")
		if auth == "" || auth == "Bearer invalid" {
			http.Error(w, "Invalid token", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// Handlers
func homeHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Home"))
}
func aboutHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("About"))
}
func statusHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`{"status":"ok"}`))
}
func listUsersHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`{"users":["Alice","Bob"]}`))
}
func createUserHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusCreated)
	w.Write([]byte(`{"message":"User created"}`))
}
func listUsersHandlerV2(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`{"users":[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]}`))
}
func createUserHandlerV2(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusCreated)
	w.Write([]byte(`{"id":3,"name":"Charlie"}`))
}
func adminDashboardHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Admin Dashboard"))
}
func adminStatsHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(`{"total_users":100,"active":42}`))
}
