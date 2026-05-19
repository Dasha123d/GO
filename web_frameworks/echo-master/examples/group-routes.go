//go:build ignore

// examples/group-routes.go
// Примеры группировки маршрутов в Echo
// Запуск: go run group-routes.go
package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// Middleware для проверки API версии
func APIVersionMiddleware(version string) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Response().Header().Set("X-API-Version", version)
			return next(c)
		}
	}
}

// Middleware для логирования группы
func GroupLogger(groupName string) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Logger().Infof("[%s] Request: %s %s", groupName, c.Request().Method, c.Path())
			return next(c)
		}
	}
}

func main() {
	e := echo.New()

	// === Глобальные middleware ===
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// === Public routes (без аутентификации) ===
	public := e.Group("/public")
	public.Use(GroupLogger("PUBLIC"))

	public.GET("/info", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Public information",
			"access":  "no-auth-required",
		})
	})

	public.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"status": "healthy",
		})
	})

	// === API v1 ===
	v1 := e.Group("/api/v1")
	v1.Use(APIVersionMiddleware("v1"))
	v1.Use(GroupLogger("API-V1"))

	// v1: Public endpoints
	v1.GET("/status", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"version": "v1",
			"status":  "operational",
		})
	})

	// v1: Protected endpoints (Basic Auth)
	v1Protected := v1.Group("")
	v1Protected.Use(middleware.BasicAuth(func(username, password string, c echo.Context) (bool, error) {
		// Простая проверка (в продакшене используйте БД)
		if username == "admin" && password == "password" {
			return true, nil
		}
		return false, nil
	}))

	v1Protected.GET("/users", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"version": "v1",
			"users":   []string{"Alice", "Bob"},
		})
	})

	v1Protected.POST("/users", func(c echo.Context) error {
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "User created (v1)",
		})
	})

	// === API v2 (с JWT) ===
	v2 := e.Group("/api/v2")
	v2.Use(APIVersionMiddleware("v2"))
	v2.Use(GroupLogger("API-V2"))

	// v2: JWT protected
	v2Protected := v2.Group("")
	v2Protected.Use(middleware.JWTWithConfig(middleware.JWTConfig{
		SigningKey: []byte("secret-key-v2"),
	}))

	v2Protected.GET("/users", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"version": "v2",
			"users": []map[string]string{
				{"id": "1", "name": "Alice"},
				{"id": "2", "name": "Bob"},
			},
		})
	})

	v2Protected.POST("/users", func(c echo.Context) error {
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "User created (v2)",
		})
	})

	// === Admin routes ===
	admin := e.Group("/admin")
	admin.Use(middleware.BasicAuth(func(username, password string, c echo.Context) (bool, error) {
		if username == "superadmin" && password == "admin123" {
			return true, nil
		}
		return false, nil
	}))
	admin.Use(GroupLogger("ADMIN"))

	admin.GET("/dashboard", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"page": "admin-dashboard",
		})
	})

	admin.GET("/stats", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"total_users":     100,
			"active_sessions": 42,
		})
	})

	// === Shop routes (nested groups) ===
	shop := e.Group("/shop")
	shop.Use(GroupLogger("SHOP"))

	products := shop.Group("/products")
	products.GET("", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"products": []string{"Product A", "Product B"},
		})
	})
	products.GET("/:id", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"product_id": id,
		})
	})

	orders := shop.Group("/orders")
	orders.Use(middleware.JWT([]byte("shop-secret")))

	orders.GET("", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"orders": []string{"Order #1", "Order #2"},
		})
	})
	orders.POST("", func(c echo.Context) error {
		return c.JSON(http.StatusCreated, map[string]string{
			"message": "Order created",
		})
	})

	e.Logger.Info("🚀 Grouped routes server starting on http://localhost:8080")
	e.Logger.Fatal(e.Start(":8080"))
}
