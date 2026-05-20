package main

import (
	"log"
	"time"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/logger"
)

// Кастомный middleware для измерения времени выполнения запроса
func latencyMiddleware(c fiber.Ctx) error {
	start := time.Now()
	// Передаём управление следующему обработчику в стеке
	err := c.Next()
	// Вычисление времени после выполнения хендлера
	duration := time.Since(start)
	log.Printf("Request %s %s took %v", c.Method(), c.Path(), duration)
	return err
}

func main() {
	app := fiber.New()

	// Глобальный логгер с кастомным форматом вывода
	app.Use(logger.New(logger.Config{
		Format:   "[${time}] ${status} | ${latency} | ${method} ${url}\n",
		TimeZone: "Local",
	}))

	// Применение кастомного middleware
	app.Use(latencyMiddleware)

	app.Get("/fast", func(c fiber.Ctx) error {
		return c.SendString("Fast response ⚡")
	})

	app.Get("/slow", func(c fiber.Ctx) error {
		time.Sleep(500 * time.Millisecond) // Имитация долгой операции
		return c.SendString("Slow response 🐢")
	})

	log.Fatal(app.Listen(":3000"))
}
