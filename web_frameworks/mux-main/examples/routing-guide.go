package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// User представляет структуру пользователя для примеров
type User struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

var users = []User{
	{ID: "1", Name: "Alice", Email: "alice@example.com"},
	{ID: "2", Name: "Bob", Email: "bob@example.com"},
}

// === Обработчики для базовых маршрутов ===
func GetUsers(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

func GetUser(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	for _, user := range users {
		if user.ID == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(user)
			return
		}
	}
	http.Error(w, "User not found", http.StatusNotFound)
}

// === Обработчики с условиями ===
func APIHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "API endpoint - X-Requested-With: %s", r.Header.Get("X-Requested-With"))
}

func SearchHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	query := vars["query"]
	page := vars["page"]
	fmt.Fprintf(w, "Search: q=%s, page=%s", query, page)
}

// === Обработчики для подмаршрутизаторов ===
func GetUsersV1(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "API v1 - Users list")
}

func GetUsersV2(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "API v2 - Users with pagination and filters")
}

func DashboardHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Admin dashboard")
}

// === Middleware для аутентификации ===
func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("Authorization")
		if token != "admin-secret" {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func main() {
	r := mux.NewRouter()

	// 1. Базовые маршруты
	r.HandleFunc("/users", GetUsers).Methods("GET")
	r.HandleFunc("/users/{id}", GetUser).Methods("GET")

	// 2. Маршруты с условиями
	r.HandleFunc("/api", APIHandler).
		Headers("X-Requested-With", "XMLHttpRequest")

	r.HandleFunc("/search", SearchHandler).
		Queries("q", "{query}", "page", "{page:[0-9]+}")

	// 3. Подмаршрутизаторы (API versioning)
	api := r.PathPrefix("/api").Subrouter()
	v1 := api.PathPrefix("/v1").Subrouter()
	v2 := api.PathPrefix("/v2").Subrouter()

	v1.HandleFunc("/users", GetUsersV1).Methods("GET")
	v2.HandleFunc("/users", GetUsersV2).Methods("GET")

	// 4. Группа с middleware
	admin := r.PathPrefix("/admin").Subrouter()
	admin.Use(AuthMiddleware)
	admin.HandleFunc("/dashboard", DashboardHandler).Methods("GET")

	// 5. Именованные маршруты для генерации URL
	r.HandleFunc("/users/{id}", GetUser).
		Host("api.example.com").
		Name("user-api")

	// Демонстрация генерации URL (в логе)
	if url, err := r.GetRoute("user-api").URL("id", "123"); err == nil {
		log.Printf("Generated URL: %s", url.String())
	}

	log.Println("🚀 Mux routing demo on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", r))
}
