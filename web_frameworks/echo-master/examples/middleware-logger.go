// examples/middleware-logger.go
// Настройка логгера в Echo
// Запуск: go run middleware-logger.go
//go:build ignore
package main

import (
    "io"
    "os"
    "time"
    "github.com/labstack/echo/v4"
    "github.com/labstack/echo/v4/middleware"
    "github.com/labstack/gommon/log"
)

func main() {
    e := echo.New()

    // === Вариант 1: Стандартный логгер ===
    // e.Use(middleware.Logger())

    // === Вариант 2: Логгер с кастомным форматом ===
    e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
        Format: `{"time":"${time_rfc3339}",` +
            `"id":"${id}",` +
            `"remote_ip":"${remote_ip}",` +
            `"host":"${host}",` +
            `"method":"${method}",` +
            `"uri":"${uri}",` +
            `"user_agent":"${user_agent}",` +
            `"status":${status},` +
            `"error":"${error}",` +
            `"latency":${latency},` +
            `"latency_human":"${latency_human}",` +
            `"bytes_in":${bytes_in},` +
            `"bytes_out":${bytes_out}}` + "\n",
        Output: os.Stdout,
    }))

    // === Вариант 3: Логгер в файл + консоль ===
    logFile, err := os.OpenFile("access.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
    if err != nil {
        e.Logger.Fatal(err)
    }
    
    e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
        Format: "${time_rfc3339} | ${status} | ${method} ${uri} | ${latency_human}\n",
        Output: io.MultiWriter(os.Stdout, logFile),
    }))

    // === Настройка уровня логирования самого Echo ===
    e.Logger.SetLevel(log.INFO)
    
    // Кастомный формат логов Echo
    e.Logger.SetHeader("${time_rfc3339} [${level}] ${prefix} ${message}")

    // === Маршруты для тестирования ===
    
    e.GET("/", func(c echo.Context) error {
        e.Logger.Info("Root handler called")
        return c.String(200, "Check logs!")
    })

    e.GET("/slow", func(c echo.Context) error {
        e.Logger.Debug("Starting slow operation...")
        time.Sleep(500 * time.Millisecond)
        e.Logger.Debug("Slow operation completed")
        return c.String(200, "Slow response")
    })

    e.GET("/error", func(c echo.Context) error {
        e.Logger.Error("Simulated error endpoint called")
        return echo.NewHTTPError(500, "Internal error for testing")
    })

    e.POST("/data", func(c echo.Context) error {
        var payload map[string]interface{}
        if err := c.Bind(&payload); err != nil {
            e.Logger.Errorf("Bind error: %v", err)
            return err
        }
        e.Logger.Infof("Received data: %+v", payload)
        return c.JSON(201, payload)
    })

    e.Logger.Info("📝 Logger-enabled server starting on http://localhost:8080")
    e.Logger.Fatal(e.Start(":8080"))
}