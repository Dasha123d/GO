package main

import (
	"fmt"
	"log"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/recover"
)

func main() {
	app := fiber.New(fiber.Config{
		// Кастомный обработчик ошибок для единого формата ответов
		ErrorHandler: func(c fiber.Ctx, err error) error {
			log.Printf("[ERROR] %v", err)
			return c.Status(500).JSON(fiber.Map{
				"success":    false,
				"error":      "Internal server error",
				"request_id": c.Locals("request_id"),
			})
		},
	})

	// Обязательно: recover должен быть первым в стеке middleware
	app.Use(recover.New(recover.Config{
		EnableStackTrace: true,
	}))

	app.Get("/safe", func(c fiber.Ctx) error {
		return c.SendString("This route works perfectly ✅")
	})

	app.Get("/panic", func(c fiber.Ctx) error {
		// Имитация критической ошибки (будет поймана recover)
		panic("simulated runtime panic 🚨")
	})

	app.Get("/error", func(c fiber.Ctx) error {
		// Возврат ошибки через return (правильный способ для бизнес-логики)
		return fmt.Errorf("custom business logic error: invalid state")
	})

	log.Fatal(app.Listen(":3000"))
}
