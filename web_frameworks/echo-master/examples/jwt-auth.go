//go:build ignore

package main

import (
	"net/http"
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type CustomClaims struct {
	Name  string `json:"name"`
	Admin bool   `json:"admin"`
	jwt.StandardClaims
}

type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func main() {
	e := echo.New()

	// Конфигурация JWT Middleware
	config := middleware.JWTConfig{
		SigningKey: []byte("secret"),
	}

	// Публичный маршрут (Логин)
	e.POST("/login", func(c echo.Context) error {
		req := new(LoginRequest)
		if err := c.Bind(req); err != nil {
			return err
		}

		// Простая проверка (в реальности запрос к БД)
		if req.Username != "admin" || req.Password != "password" {
			return echo.NewHTTPError(http.StatusUnauthorized, "Неверные данные")
		}

		// Создание токена
		claims := &CustomClaims{
			Name:  req.Username,
			Admin: req.Username == "admin",
			StandardClaims: jwt.StandardClaims{
				ExpiresAt: time.Now().Add(time.Hour * 72).Unix(),
			},
		}

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
		t, err := token.SignedString([]byte("secret"))
		if err != nil {
			return err
		}

		return c.JSON(http.StatusOK, map[string]string{"token": t})
	})

	// Защищенная группа маршрутов
	restricted := e.Group("/admin")
	restricted.Use(middleware.JWTWithConfig(config))

	restricted.GET("/", func(c echo.Context) error {
		user := c.Get("user").(*jwt.Token)
		claims := user.Claims.(*CustomClaims)
		return c.JSON(http.StatusOK, map[string]interface{}{
			"message": "Доступ разрешен",
			"user":    claims.Name,
			"admin":   claims.Admin,
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
