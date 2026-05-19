package main

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type AppError struct {
	Err     error
	Message string
	Status  int
}

func (e *AppError) Error() string {
	return fmt.Sprintf("%d: %s (%v)", e.Status, e.Message, e.Err)
}

func errorHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		err := next.ServeHTTP(w, r)
		if appErr, ok := err.(*AppError); ok {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(appErr.Status)
			fmt.Fprintf(w, `{"error":"%s"}`, appErr.Message)
		} else if err != nil {
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	})
}

func main() {
	r := chi.NewRouter()
	r.Use(errorHandler)

	r.Get("/error/not-found", func(w http.ResponseWriter, r *http.Request) error {
		return &AppError{
			Err:     errors.New("not found"),
			Message: "Resource not found",
			Status:  http.StatusNotFound,
		}
	})

	r.Get("/error/validation", func(w http.ResponseWriter, r *http.Request) error {
		return &AppError{
			Err:     errors.New("invalid input"),
			Message: "Validation failed",
			Status:  http.StatusBadRequest,
		}
	})

	r.Get("/success", func(w http.ResponseWriter, r *http.Request) error {
		w.Write([]byte("Success!"))
		return nil
	})

	http.ListenAndServe(":8080", r)
}
