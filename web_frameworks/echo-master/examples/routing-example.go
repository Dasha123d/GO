//go:build ignore

// examples/routing-example.go
// Примеры маршрутизации в Echo
// Запуск: go run routing-example.go
package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	// === Базовые HTTP методы ===

	// GET запрос
	e.GET("/get", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"method":  "GET",
			"message": "This is a GET request",
		})
	})

	// POST запрос
	e.POST("/post", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"method":  "POST",
			"message": "This is a POST request",
		})
	})

	// PUT запрос
	e.PUT("/put/:id", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"method":  "PUT",
			"id":      id,
			"message": "Resource updated",
		})
	})

	// DELETE запрос
	e.DELETE("/delete/:id", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"method":  "DELETE",
			"id":      id,
			"message": "Resource deleted",
		})
	})

	// PATCH запрос
	e.PATCH("/patch/:id", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"method":  "PATCH",
			"id":      id,
			"message": "Resource patched",
		})
	})

	// === Параметры маршрута ===

	// Один параметр
	e.GET("/users/:id", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"user_id": id,
		})
	})

	// Несколько параметров
	e.GET("/users/:userId/posts/:postId", func(c echo.Context) error {
		userId := c.Param("userId")
		postId := c.Param("postId")
		return c.JSON(http.StatusOK, map[string]string{
			"user_id": userId,
			"post_id": postId,
		})
	})

	// Query параметры
	e.GET("/search", func(c echo.Context) error {
		query := c.QueryParam("q")
		page := c.QueryParam("page")
		limit := c.QueryParam("limit")

		return c.JSON(http.StatusOK, map[string]string{
			"query": query,
			"page":  page,
			"limit": limit,
		})
	})

	// === Match и Any ===

	// Обработка любого метода
	e.Any("/catch-all", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"method": c.Request().Method,
			"path":   c.Path(),
			"query":  c.QueryParams(),
		})
	})

	// Обработка конкретных методов
	e.Match([]string{http.MethodGet, http.MethodPost}, "/multi", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"method":  c.Request().Method,
			"message": "GET or POST accepted",
		})
	})

	// === Regex параметры ===
	e.GET("/regex/:id\\d+", func(c echo.Context) error {
		id := c.Param("id")
		return c.JSON(http.StatusOK, map[string]string{
			"id":   id,
			"type": "numeric",
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
