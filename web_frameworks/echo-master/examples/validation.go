package main

import (
	"net/http"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

// CustomValidator реализует интерфейс echo.Validator
type CustomValidator struct {
	Validator *validator.Validate
}

func (cv *CustomValidator) Validate(i interface{}) error {
	return cv.Validator.Struct(i)
}

type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name" validate:"required,min=3,max=20"`
	Email string `json:"email" validate:"required,email"`
}

func main() {
	e := echo.New()

	// Регистрируем валидатор
	e.Validator = &CustomValidator{Validator: validator.New()}

	e.POST("/users", func(c echo.Context) error {
		u := new(User)
		if err := c.Bind(u); err != nil {
			return err
		}

		// Валидация данных
		if err := c.Validate(u); err != nil {
			return echo.NewHTTPError(http.StatusBadRequest, err.Error())
		}

		return c.JSON(http.StatusCreated, u)
	})

	e.Logger.Fatal(e.Start(":8080"))
}
