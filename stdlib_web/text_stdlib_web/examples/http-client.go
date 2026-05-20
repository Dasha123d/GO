// Примеры HTTP-запросов к локальному серверу (simple-server.go).
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
	"time"
)

func main() {
	// Простой GET
	resp, err := http.Get("http://localhost:8080/")
	if err != nil {
		log.Fatal(err)
	}
	body, _ := io.ReadAll(resp.Body)
	resp.Body.Close()
	fmt.Printf("GET / : %s\n", body)

	// Кастомный клиент с таймаутом
	client := &http.Client{Timeout: 5 * time.Second}

	// POST запрос
	reqBody := strings.NewReader(`{"name":"test"}`)
	resp, err = client.Post("http://localhost:8080/status", "application/json", reqBody)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, _ = io.ReadAll(resp.Body)
	fmt.Printf("POST /status: %s\n", body)
}