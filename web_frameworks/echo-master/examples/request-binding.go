// examples/request-binding.go
// Примеры привязки данных запроса к структурам
// Запуск: go run request-binding.go
//go:build ignore
package main

import (
    "net/http"
    "github.com/labstack/echo/v4"
    "github.com/labstack/echo/v4/middleware"
)

// === Модели данных ===

type User struct {
    ID       int    `json:"id" xml:"id" form:"id" query:"id"`
    Name     string `json:"name" xml:"name" form:"name" query:"name" validate:"required,min=3"`
    Email    string `json:"email" xml:"email" form:"email" query:"email" validate:"required,email"`
    Password string `json:"password,omitempty" xml:"password,omitempty" form:"password" validate:"required,min=8"`
    Age      *int   `json:"age,omitempty" xml:"age,omitempty" form:"age" query:"age" validate:"omitempty,min=18,max=120"`
}

type SearchQuery struct {
    Query  string `query:"q" validate:"required"`
    Page   int    `query:"page" validate:"omitempty,min=1"`
    Limit  int    `query:"limit" validate:"omitempty,min=1,max=100"`
    SortBy string `query:"sort" validate:"omitempty,oneof=name date relevance"`
}

type UpdateRequest struct {
    Email *string `json:"email,omitempty" validate:"omitempty,email"`
    Name  *string `json:"name,omitempty" validate:"omitempty,min=3"`
}

func main() {
    e := echo.New()
    e.Use(middleware.Logger())
    e.Use(middleware.Recover())

    // === JSON Binding ===
    
    e.POST("/users/json", func(c echo.Context) error {
        u := new(User)
        
        // Автоматическая привязка + валидация
        if err := c.Bind(u); err != nil {
            return echo.NewHTTPError(http.StatusBadRequest, err.Error())
        }
        
        if err := c.Validate(u); err != nil {
            return echo.NewHTTPError(http.StatusBadRequest, err.Error())
        }
        
        // Не возвращаем пароль в ответе
        u.Password = ""
        
        return c.JSON(http.StatusCreated, u)
    })

    // === Form Binding (application/x-www-form-urlencoded) ===
    
    e.POST("/users/form", func(c echo.Context) error {
        u := new(User)
        
        if err := c.Bind(u); err != nil {
            return err
        }
        
        return c.JSON(http.StatusCreated, map[string]interface{}{
            "message": "User created via form",
            "user": map[string]interface{}{
                "id":    u.ID,
                "name":  u.Name,
                "email": u.Email,
            },
        })
    })

    // === Multipart Form (с загрузкой файлов) ===
    
    e.POST("/users/multipart", func(c echo.Context) error {
        // Привязка полей формы
        u := new(User)
        if err := c.Bind(u); err != nil {
            return err
        }
        
        // Обработка файла
        file, err := c.FormFile("avatar")
        if err == nil {
            src, err := file.Open()
            if err != nil {
                return err
            }
            defer src.Close()
            
            // Здесь можно сохранить файл
            _ = src // заглушка
            
            return c.JSON(http.StatusCreated, map[string]interface{}{
                "user":   u,
                "avatar": file.Filename,
            })
        }
        
        return c.JSON(http.StatusCreated, u)
    })

    // === Query Parameter Binding ===
    
    e.GET("/search", func(c echo.Context) error {
        sq := new(SearchQuery)
        
        if err := c.Bind(sq); err != nil {
            return err
        }
        
        if err := c.Validate(sq); err != nil {
            return echo.NewHTTPError(http.StatusBadRequest, err.Error())
        }
        
        // Значения по умолчанию
        if sq.Page == 0 {
            sq.Page = 1
        }
        if sq.Limit == 0 {
            sq.Limit = 10
        }
        
        return c.JSON(http.StatusOK, map[string]interface{}{
            "query": sq,
            "results": []string{"result1", "result2"},
        })
    })

    // === Manual Extraction ===
    
    e.POST("/users/manual", func(c echo.Context) error {
        // Извлечение из JSON
        name := c.FormValue("name")
        email := c.FormValue("email")
        
        // Извлечение заголовков
        apiKey := c.Request().Header.Get("X-API-Key")
        
        // Извлечение cookies
        session, _ := c.Cookie("session_id")
        
        return c.JSON(http.StatusOK, map[string]interface{}{
            "name":     name,
            "email":    email,
            "api_key":  apiKey,
            "session":  session,
        })
    })

    // === Partial Update (PATCH) ===
    
    e.PATCH("/users/:id", func(c echo.Context) error {
        id := c.Param("id")
        req := new(UpdateRequest)
        
        if err := c.Bind(req); err != nil {
            return err
        }
        
        if err := c.Validate(req); err != nil {
            return echo.NewHTTPError(http.StatusBadRequest, err.Error())
        }
        
        // Здесь логика обновления только переданных полей
        updates := make(map[string]interface{})
        if req.Name != nil {
            updates["name"] = *req.Name
        }
        if req.Email != nil {
            updates["email"] = *req.Email
        }
        
        return c.JSON(http.StatusOK, map[string]interface{}{
            "id":      id,
            "updated": updates,
        })
    })

    e.Logger.Fatal(e.Start(":8080"))
}