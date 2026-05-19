//go:build ignore

package main

import (
	"net/http"
	"sync"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"golang.org/x/time/rate"
)

// RateLimiter хранит лимитеры для каждого IP
type RateLimiter struct {
	visitors map[string]*rate.Limiter
	mu       *sync.RWMutex
	rate     rate.Limit
	burst    int
}

func NewRateLimiter(r rate.Limit, b int) *RateLimiter {
	return &RateLimiter{
		visitors: make(map[string]*rate.Limiter),
		mu:       &sync.RWMutex{},
		rate:     r,
		burst:    b,
	}
}

// Получает или создает лимитер для IP
func (rl *RateLimiter) GetVisitor(ip string) *rate.Limiter {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	limiter, exists := rl.visitors[ip]
	if !exists {
		limiter = rate.NewLimiter(rl.rate, rl.burst)
		rl.visitors[ip] = limiter
	}
	return limiter
}

// Middleware функция
func (rl *RateLimiter) LimitMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		ip := c.RealIP()
		limiter := rl.GetVisitor(ip)

		if !limiter.Allow() {
			return c.JSON(http.StatusTooManyRequests, map[string]string{
				"error": "Слишком много запросов",
			})
		}
		return next(c)
	}
}

func main() {
	e := echo.New()
	e.Use(middleware.Logger())

	// 5 запросов в секунду, всплеск до 10
	limiter := NewRateLimiter(5, 10)
	e.Use(limiter.LimitMiddleware)

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"status": "ok",
			"time":   time.Now().Format(time.RFC3339),
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
