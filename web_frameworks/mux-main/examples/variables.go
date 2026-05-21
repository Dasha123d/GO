package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Product для примеров с переменными
type Product struct {
	ID    string  `json:"id"`
	Name  string  `json:"name"`
	Price float64 `json:"price"`
}

var products = map[string]Product{
	"1": {ID: "1", Name: "Laptop", Price: 999.99},
	"2": {ID: "2", Name: "Mouse", Price: 29.99},
}

// === Обработчики с переменными пути ===
func GetUser(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]
	fmt.Fprintf(w, "User ID: %s", id)
}

func GetPost(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	slug := vars["slug"]
	fmt.Fprintf(w, "Post slug: %s", slug)
}

func GetItem(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	uuid := vars["uuid"]
	fmt.Fprintf(w, "Item UUID: %s", uuid)
}

func GetUserPost(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userId := vars["userId"]
	postId := vars["postId"]
	fmt.Fprintf(w, "User: %s, Post: %s", userId, postId)
}

// === Обработчики с query-параметрами ===
func FilterHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	category := vars["category"]
	sort := vars["sort"]
	fmt.Fprintf(w, "Filter: category=%s, sort=%s", category, sort)
}

// === Обработчики с wildcard ===
func FileHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	path := vars["*"]
	fmt.Fprintf(w, "Serving file: /files/%s", path)
}

func VersionedHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	version := vars["*1"]
	resource := vars["*2"]
	fmt.Fprintf(w, "API v%s, Resource: %s", version, resource)
}

// === Хост-переменные ===
func SubdomainHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	subdomain := vars["subdomain"]
	fmt.Fprintf(w, "Welcome to %s.example.com", subdomain)
}

// === Генерация URL ===
func URLDemoHandler(w http.ResponseWriter, r *http.Request) {
	router := mux.CurrentRouter(r)

	// Генерация относительного URL
	if url, err := router.GetRoute("user").URL("id", "123"); err == nil {
		fmt.Fprintf(w, "Relative URL: %s\n", url.String())
	}

	// С хостом
	if url, err := router.GetRoute("user-secure").URL("id", "456"); err == nil {
		fmt.Fprintf(w, "Secure URL: %s\n", url.String())
	}
}

func main() {
	r := mux.NewRouter()

	// 1. Простые переменные
	r.HandleFunc("/users/{id}", GetUser).Methods("GET")
	r.HandleFunc("/posts/{slug}", GetPost).Methods("GET")

	// 2. Переменные с регулярными выражениями
	r.HandleFunc("/items/{uuid:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}}", GetItem).Methods("GET")
	r.HandleFunc("/users/{userId}/posts/{postId}", GetUserPost).Methods("GET")

	// 3. Query-параметры через Queries()
	r.HandleFunc("/filter", FilterHandler).
		Queries("category", "{category}", "sort", "{sort}").
		Methods("GET")

	// 4. Wildcard параметры
	r.HandleFunc("/files/*", FileHandler).Methods("GET")
	r.HandleFunc("/v1/*/shop/*", VersionedHandler).Methods("GET")

	// 5. Хост-переменные
	r.Host("{subdomain}.example.com").HandleFunc("/", SubdomainHandler).Methods("GET")

	// 6. Именованные маршруты для генерации URL
	r.HandleFunc("/users/{id}", GetUser).Name("user")
	r.HandleFunc("/users/{id}", GetUser).
		Host("api.example.com").
		Schemes("https").
		Name("user-secure")

	r.HandleFunc("/url-demo", URLDemoHandler).Methods("GET")

	log.Println("🔗 Variables demo on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", r))
}
