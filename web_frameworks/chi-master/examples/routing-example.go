package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {
	r := chi.NewRouter()

	// Базовые методы
	r.Get("/get", handler("GET"))
	r.Post("/post", handler("POST"))
	r.Put("/put/{id}", handler("PUT"))
	r.Delete("/delete/{id}", handler("DELETE"))
	r.Patch("/patch/{id}", handler("PATCH"))

	// Параметры пути
	r.Get("/users/{id}", func(w http.ResponseWriter, r *http.Request) {
		id := chi.URLParam(r, "id")
		w.Write([]byte("User: " + id))
	})

	// Несколько параметров
	r.Get("/users/{userId}/posts/{postId}", func(w http.ResponseWriter, r *http.Request) {
		userId := chi.URLParam(r, "userId")
		postId := chi.URLParam(r, "postId")
		w.Write([]byte("User " + userId + ", Post " + postId))
	})

	// Query параметры
	r.Get("/search", func(w http.ResponseWriter, r *http.Request) {
		query := r.URL.Query().Get("q")
		page := r.URL.Query().Get("page")
		w.Write([]byte("Search: " + query + ", Page: " + page))
	})

	// Wildcard
	r.Get("/files/*", func(w http.ResponseWriter, r *http.Request) {
		path := chi.URLParam(r, "*")
		w.Write([]byte("File path: " + path))
	})

	http.ListenAndServe(":8080", r)
}

func handler(method string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(method + " request handled"))
	}
}
