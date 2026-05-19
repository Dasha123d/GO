// auth-jwt.go – middleware для проверки JWT
package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

var secretKey = []byte("my-secret-key")

type contextKey string

const claimsKey contextKey = "claims"

func JWTAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			http.Error(w, "missing token", http.StatusUnauthorized)
			return
		}
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		token, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method")
			}
			return secretKey, nil
		})
		if err != nil || !token.Valid {
			http.Error(w, "invalid token", http.StatusUnauthorized)
			return
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			http.Error(w, "invalid claims", http.StatusUnauthorized)
			return
		}
		ctx := context.WithValue(r.Context(), claimsKey, claims)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func userHandler(w http.ResponseWriter, r *http.Request) {
	claims := r.Context().Value(claimsKey).(jwt.MapClaims)
	user := claims["sub"].(string)
	w.Write([]byte("Hello, " + user))
}

func main() {
	// Генерация тестового токена (для демонстрации)
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": "user123",
	})
	tokenString, _ := token.SignedString(secretKey)
	fmt.Println("Use this token:", tokenString)

	mux := http.NewServeMux()
	mux.HandleFunc("/me", userHandler)

	handler := JWTAuth(mux)
	log.Println("JWT-protected server on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}