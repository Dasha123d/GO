//go:build ignore

package main

import (
	"context"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type contextKey string

const userIDKey contextKey = "userID"

func UserIDMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Извлекаем ID из заголовка или параметра
		id := r.Header.Get("X-User-ID")
		if id == "" {
			id = chi.URLParam(r, "userId")
		}

		// Добавляем в контекст
		ctx := context.WithValue(r.Context(), userIDKey, id)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func RequireAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		id := r.Context().Value(userIDKey)
		if id == nil || id == "" {
			http.Error(w, "Authentication required", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func main() {
	r := chi.NewRouter()

	r.Use(UserIDMiddleware)

	r.Get("/user/{userId}", RequireAuth(func(w http.ResponseWriter, r *http.Request) {
		id := r.Context().Value(userIDKey)
		w.Write([]byte("User ID from context: " + id.(string)))
	}))

	http.ListenAndServe(":8080", r)
}
