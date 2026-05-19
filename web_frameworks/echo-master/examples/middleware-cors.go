// examples/middleware-cors.go
// Настройка CORS middleware в Echo
// Запуск: go run middleware-cors.go
//go:build ignore
package main

import (
    "net/http"
    "github.com/labstack/echo/v4"
    "github.com/labstack/echo/v4/middleware"
)

func main() {
    e := echo.New()

    // === Вариант 1: Базовая конфигурация ===
    // e.Use(middleware.CORS())

    // === Вариант 2: Расширенная конфигурация ===
    e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
        // Разрешённые источники
        AllowOrigins: []string{
            "https://example.com",
            "https://app.example.com",
            "http://localhost:3000",
            "http://localhost:8080",
        },
        
        // Разрешённые методы
        AllowMethods: []string{
            http.MethodGet,
            http.MethodPost,
            http.MethodPut,
            http.MethodPatch,
            http.MethodDelete,
            http.MethodOptions,
        },
        
        // Разрешённые заголовки запроса
        AllowHeaders: []string{
            echo.HeaderOrigin,
            echo.HeaderContentType,
            echo.HeaderAccept,
            echo.HeaderAuthorization,
            "X-Requested-With",
            "X-API-Key",
        },
        
        // Заголовки, доступные клиенту
        ExposeHeaders: []string{
            echo.HeaderContentLength,
            "X-Request-ID",
            "X-RateLimit-Limit",
        },
        
        // Разрешить отправку credentials (cookies, auth headers)
        AllowCredentials: true,
        
        // Максимальное время кэширования preflight запросов (в секундах)
        MaxAge: 86400, // 24 часа
    }))

    // === Публичные API эндпоинты ===
    
    e.GET("/api/public", func(c echo.Context) error {
        return c.JSON(http.StatusOK, map[string]interface{}{
            "data": []string{"item1", "item2", "item3"},
            "cors": "enabled",
        })
    })

    e.POST("/api/public", func(c echo.Context) error {
        var payload map[string]interface{}
        if err := c.Bind(&payload); err != nil {
            return err
        }
        
        return c.JSON(http.StatusCreated, map[string]interface{}{
            "received": payload,
            "status": "created",
        })
    })

    // === Защищённые эндпоинты (требуют авторизацию) ===
    
    protected := e.Group("/api/protected")
    protected.Use(middleware.JWTWithConfig(middleware.JWTConfig{
        SigningKey: []byte("your-secret-key"),
    }))
    
    protected.GET("/user", func(c echo.Context) error {
        user := c.Get("user")
        return c.JSON(http.StatusOK, map[string]interface{}{
            "user": user,
            "message": "Protected data accessed",
        })
    })

    // === Health check (всегда доступен) ===
    e.GET("/health", func(c echo.Context) error {
        return c.JSON(http.StatusOK, map[string]string{
            "status": "healthy",
            "cors":   "configured",
        })
    })

    e.Logger.Info("🚀 CORS-enabled server starting on http://localhost:8080")
    e.Logger.Fatal(e.Start(":8080"))
}