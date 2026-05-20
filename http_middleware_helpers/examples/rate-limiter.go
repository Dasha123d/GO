// rate-limiter.go – простой middleware rate limiting
package main

import (
	"log"
	"net/http"
	"sync"
	"time"
)

type rateLimiter struct {
	mu       sync.Mutex
	visitors map[string]*visitor
}

type visitor struct {
	lastSeen time.Time
	tokens   int
}

func NewRateLimiter() *rateLimiter {
	rl := &rateLimiter{visitors: make(map[string]*visitor)}
	go rl.cleanup()
	return rl
}

func (rl *rateLimiter) cleanup() {
	for {
		time.Sleep(time.Minute)
		rl.mu.Lock()
		for ip, v := range rl.visitors {
			if time.Since(v.lastSeen) > 3*time.Minute {
				delete(rl.visitors, ip)
			}
		}
		rl.mu.Unlock()
	}
}

func (rl *rateLimiter) Limit(maxRequests int, window time.Duration) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ip := r.RemoteAddr
			rl.mu.Lock()
			v, exists := rl.visitors[ip]
			if !exists || time.Since(v.lastSeen) > window {
				rl.visitors[ip] = &visitor{lastSeen: time.Now(), tokens: maxRequests - 1}
				rl.mu.Unlock()
				next.ServeHTTP(w, r)
				return
			}
			if v.tokens <= 0 {
				rl.mu.Unlock()
				http.Error(w, "Too Many Requests", http.StatusTooManyRequests)
				return
			}
			v.tokens--
			v.lastSeen = time.Now()
			rl.mu.Unlock()
			next.ServeHTTP(w, r)
		})
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

func main() {
	rl := NewRateLimiter()
	mux := http.NewServeMux()
	mux.HandleFunc("/", handler)

	limited := rl.Limit(5, 10*time.Second)(mux)
	log.Println("Rate-limited server on :8080 (5 requests per 10s)")
	log.Fatal(http.ListenAndServe(":8080", limited))
}