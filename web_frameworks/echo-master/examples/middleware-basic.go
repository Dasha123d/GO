//go:build ignore

// examples/middleware-basic.go
// Простые примеры middleware в Echo
// Запуск: go run middleware-basic.go
package main

import (
	"net/http"
	"time"

	"github.com/labstack/echo/v4"
)

// === Custom Middleware: Timing ===
// Замеряет время выполнения запроса
func TimingMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		start := time.Now()

		// Выполнение следующего хендлера
		err := next(c)

		// Логирование времени
		duration := time.Since(start)
		c.Logger().Infof(
			"[%s] %s %s - %d - %v",
			c.Request().Method,
			c.RealIP(),
			c.Path(),
			c.Response().Status,
			duration,
		)

		return err
	}
}

// === Custom Middleware: Request ID ===
// Добавляет уникальный ID каждому запросу
func RequestIDMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		// Генерация или получение Request ID
		reqID := c.Request().Header.Get("X-Request-ID")
		if reqID == "" {
			reqID = echo.NewUUID()
		}

		// Добавление в контекст и ответ
		c.Set("requestID", reqID)
		c.Response().Header().Set("X-Request-ID", reqID)

		return next(c)
	}
}

// === Custom Middleware: API Key Auth ===
// Простая аутентификация по API ключу
func APIKeyMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		apiKey := c.Request().Header.Get("X-API-Key")

		// Проверка ключа (в реальности - проверка в БД)
		validKeys := map[string]bool{
			"secret-key-123": true,
			"demo-key-456":   true,
		}

		if !validKeys[apiKey] {
			return echo.NewHTTPError(http.StatusUnauthorized, "Invalid API key")
		}

		return next(c)
	}
}

// === Custom Middleware: CORS (упрощённый) ===
func SimpleCORSMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		c.Response().Header().Set("Access-Control-Allow-Origin", "*")
		c.Response().Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE")
		c.Response().Header().Set("Access-Control-Allow-Headers", "Content-Type,Authorization")

		// Обработка preflight запросов
		if c.Request().Method == http.MethodOptions {
			return c.NoContent(http.StatusNoContent)
		}

		return next(c)
	}
}

func main() {
	e := echo.New()

	// Глобальные мидлвары
	e.Use(TimingMiddleware)
	e.Use(RequestIDMiddleware)
	e.Use(SimpleCORSMiddleware)

	// Публичные маршруты
	e.GET("/public", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Public endpoint",
			"req_id":  c.Get("requestID").(string),
		})
	})

	// Защищённые маршруты (требуют API ключ)
	api := e.Group("/api")
	api.Use(APIKeyMiddleware)

	api.GET("/protected", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Protected endpoint",
			"req_id":  c.Get("requestID").(string),
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
