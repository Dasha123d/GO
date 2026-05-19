//go:build ignore

// examples/hello-world.go
// Базовый пример "Hello World" для Echo Framework
// Запуск: go run hello-world.go
// Тест: curl http://localhost:8080
package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	// Создаём экземпляр Echo
	e := echo.New()

	// Подключаем стандартные мидлвары
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Простой текстовый ответ
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World! 🚀")
	})

	// JSON ответ
	e.GET("/api/hello", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Hello from Echo API",
			"status":  "success",
			"version": "v4.12.0",
		})
	})

	// Эндпоинт с параметром в пути
	e.GET("/greet/:name", func(c echo.Context) error {
		name := c.Param("name")
		return c.JSON(http.StatusOK, map[string]string{
			"greeting": "Hello, " + name + "! 👋",
		})
	})

	// POST эндпоинт для теста
	e.POST("/echo", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"method":  c.Request().Method,
			"path":    c.Path(),
			"message": "Echo server is working!",
		})
	})

	// Запуск сервера на порту 8080
	e.Logger.Info("🚀 Server starting on http://localhost:8080")
	e.Logger.Fatal(e.Start(":8080"))
}
