// examples/response-handling.go
// Примеры отправки различных типов ответов в Echo
// Запуск: go run response-handling.go
//go:build ignore
package main

import (
    "net/http"
    "github.com/labstack/echo/v4"
    "github.com/labstack/echo/v4/middleware"
)

// === Модели для ответов ===

type APIResponse struct {
    Success bool        `json:"success"`
    Message string      `json:"message"`
    Data    interface{} `json:"data,omitempty"`
    Error   string      `json:"error,omitempty"`
}

type PaginatedResponse struct {
    Data       []interface{} `json:"data"`
    Page       int          `json:"page"`
    Limit      int          `json:"limit"`
    Total      int          `json:"total"`
    TotalPages int          `json:"total_pages"`
}

func main() {
    e := echo.New()
    e.Use(middleware.Logger())
    e.Use(middleware.Recover())

    // === 1. String Response ===
    e.GET("/text", func(c echo.Context) error {
        return c.String(http.StatusOK, "Plain text response")
    })

    // === 2. JSON Response ===
    e.GET("/json", func(c echo.Context) error {
        return c.JSON(http.StatusOK, map[string]interface{}{
            "message": "JSON response",
            "items":   []string{"a", "b", "c"},
        })
    })

    // === 3. JSON с кастомными заголовками ===
    e.GET("/json/headers", func(c echo.Context) error {
        c.Response().Header().Set("X-Custom-Header", "custom-value")
        c.Response().Header().Set("Cache-Control", "no-cache")
        
        return c.JSON(http.StatusOK, map[string]string{
            "message": "Response with custom headers",
        })
    })

    // === 4. Pretty JSON ===
    e.GET("/json/pretty", func(c echo.Context) error {
        return c.JSONPretty(http.StatusOK, map[string]interface{}{
            "users": []map[string]string{
                {"id": "1", "name": "Alice"},
                {"id": "2", "name": "Bob"},
            },
        }, "  ")
    })

    // === 5. JSONP Response ===
    e.GET("/jsonp", func(c echo.Context) error {
        callback := c.QueryParam("callback")
        if callback == "" {
            callback = "callback"
        }
        
        return c.JSONP(http.StatusOK, callback, map[string]string{
            "message": "JSONP response",
        })
    })

    // === 6. XML Response ===
    type User struct {
            XMLName xml.Name `xml:"user"`
            ID      int      `xml:"id"`
            Name    string   `xml:"name"`
            Email   string   `xml:"email"`
    }
    
    e.GET("/xml", func(c echo.Context) error {
        user := User{ID: 1, Name: "Alice", Email: "alice@example.com"}
        return c.XML(http.StatusOK, user)
    })

    // === 7. File Response ===
    e.GET("/file", func(c echo.Context) error {
        return c.File("README.md")
    })

    // === 8. File Download (Attachment) ===
    e.GET("/download", func(c echo.Context) error {
        return c.Attachment("README.md", "readme.txt")
    })

    // === 9. File Inline (в браузере) ===
    e.GET("/inline", func(c echo.Context) error {
        return c.Inline("README.md", "readme.txt")
    })

    // === 10. Blob/Binary Response ===
    e.GET("/binary", func(c echo.Context) error {
        data := []byte("Binary data here")
        return c.Blob(http.StatusOK, "application/octet-stream", data)
    })

    // === 11. Stream Response ===
    e.GET("/stream", func(c echo.Context) error {
        c.Response().Header().Set(echo.HeaderContentType, echo.MIMETextPlain)
        c.Response().WriteHeader(http.StatusOK)
        
        for i := 1; i <= 5; i++ {
            c.Response().Write([]byte(fmt.Sprintf("Chunk %d\n", i)))
            c.Response().Flush()
            time.Sleep(200 * time.Millisecond)
        }
        return nil
    })

    // === 12. No Content (204) ===
    e.DELETE("/resource/:id", func(c echo.Context) error {
        // Логика удаления...
        return c.NoContent(http.StatusNoContent)
    })

    // === 13. Redirect ===
    e.GET("/redirect", func(c echo.Context) error {
        return c.Redirect(http.StatusFound, "https://example.com")
    })

    // === 14. Standard Response Wrapper ===
    e.GET("/api/users", func(c echo.Context) error {
        users := []map[string]string{
            {"id": "1", "name": "Alice"},
            {"id": "2", "name": "Bob"},
        }
        
        return c.JSON(http.StatusOK, APIResponse{
            Success: true,
            Message: "Users retrieved successfully",
            Data:    users,
        })
    })

    // === 15. Paginated Response ===
    e.GET("/api/items", func(c echo.Context) error {
        page := 1
        limit := 10
        total := 100
        
        items := make([]interface{}, limit)
        for i := range items {
            items[i] = map[string]int{"id": page*limit + i}
        }
        
        return c.JSON(http.StatusOK, PaginatedResponse{
            Data:       items,
            Page:       page,
            Limit:      limit,
            Total:      total,
            TotalPages: (total + limit - 1) / limit,
        })
    })

    // === 16. Error Responses ===
    e.GET("/error/not-found", func(c echo.Context) error {
        return echo.NewHTTPError(http.StatusNotFound, "Resource not found")
    })

    e.GET("/error/unauthorized", func(c echo.Context) error {
        return c.JSON(http.StatusUnauthorized, APIResponse{
            Success: false,
            Error:   "Authentication required",
        })
    })

    e.GET("/error/validation", func(c echo.Context) error {
        return c.JSON(http.StatusBadRequest, APIResponse{
            Success: false,
            Error:   "Validation failed: email is required",
        })
    })

    e.Logger.Fatal(e.Start(":8080"))
}