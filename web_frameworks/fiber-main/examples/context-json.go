package main

import (
	"log"
	"time"

	"github.com/gofiber/fiber/v3"
)

// Структура для входящего запроса
type CreateUser struct {
	Username string `json:"username" validate:"required,min=3"`
	Email    string `json:"email" validate:"required,email"`
	Age      int    `json:"age"`
}

func main() {
	app := fiber.New()

	// POST /users - создание пользователя с валидацией
	app.Post("/users", func(c fiber.Ctx) error {
		user := new(CreateUser)

		// Автоматический парсинг JSON в структуру
		if err := c.Bind(user); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid JSON format"})
		}

		// Базовая валидация бизнес-логики
		if user.Age < 0 {
			return c.Status(400).JSON(fiber.Map{"error": "Age cannot be negative"})
		}

		// Возврат успешного ответа с кодом 201 Created
		return c.Status(201).JSON(fiber.Map{
			"message": "User created successfully",
			"data":    user,
		})
	})

	// GET /users/:id - работа с параметрами и query
	app.Get("/users/:id", func(c fiber.Ctx) error {
		id := c.Params("id")
		role := c.Query("role", "viewer") // Значение по умолчанию

		return c.JSON(fiber.Map{
			"user_id":   id,
			"role":      role,
			"timestamp": time.Now().Format(time.RFC3339),
		})
	})

	log.Fatal(app.Listen(":3000"))
}
