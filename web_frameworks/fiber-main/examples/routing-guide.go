package main

import (
	"fmt"
	"log"

	"github.com/gofiber/fiber/v3"
)

func main() {
	app := fiber.New()

	// 1. Базовые маршруты
	app.Get("/", func(c fiber.Ctx) error {
		return c.SendString("Fiber Routing Demo")
	})

	// 2. Обязательный параметр URL (:id)
	app.Get("/users/:id", func(c fiber.Ctx) error {
		id := c.Params("id")
		return c.SendString(fmt.Sprintf("Пользователь ID: %s", id))
	})

	// 3. Опциональный параметр (:name?)
	app.Get("/greet/:name?", func(c fiber.Ctx) error {
		name := c.Params("name")
		if name == "" {
			name = "Гость"
		}
		return c.SendString(fmt.Sprintf("Привет, %s!", name))
	})

	// 4. Группировка маршрутов
	api := app.Group("/api")
	api.Get("/status", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{"status": "active", "version": "v3"})
	})

	// 5. Wildcard маршруты
	app.Get("/files/*", func(c fiber.Ctx) error {
		path := c.Params("*")
		return c.SendString(fmt.Sprintf("Запрошен файл: /files/%s", path))
	})

	log.Fatal(app.Listen(":3000"))
}
