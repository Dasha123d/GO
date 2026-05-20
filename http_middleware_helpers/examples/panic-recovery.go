// panic-recovery.go – middleware восстановления после паники
package main

import (
	"log"
	"net/http"
	"runtime/debug"
)

func Recovery(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				log.Printf("panic: %v\n%s", err, debug.Stack())
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

func riskyHandler(w http.ResponseWriter, r *http.Request) {
	panic("something went wrong!")
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/panic", riskyHandler)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("safe handler"))
	})

	handler := Recovery(mux)
	log.Println("Server with recovery on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}