// auth-basic.go – middleware Basic Authentication
package main

import (
	"crypto/subtle"
	"log"
	"net/http"
)

func BasicAuth(users map[string]string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			user, pass, ok := r.BasicAuth()
			if !ok {
				w.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
				http.Error(w, "Unauthorized", http.StatusUnauthorized)
				return
			}
			expectedPass, exists := users[user]
			if !exists || subtle.ConstantTimeCompare([]byte(pass), []byte(expectedPass)) != 1 {
				http.Error(w, "Unauthorized", http.StatusUnauthorized)
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

func secretHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Secret page!"))
}

func main() {
	users := map[string]string{"admin": "secret"}
	mux := http.NewServeMux()
	mux.HandleFunc("/secret", secretHandler)

	handler := BasicAuth(users)(mux)
	log.Println("Protected server on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}