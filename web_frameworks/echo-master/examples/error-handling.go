//go:build ignore

// examples/error-handling.go
// Примеры обработки ошибок в Echo
// Запуск: go run error-handling.go
package main

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// === Custom error types ===

type BusinessError struct {
	Code    string `json:"code"`
	Message string `json:"message"`
	Status  int    `json:"-"`
}

func (e *BusinessError) Error() string {
	return e.Message
}

type ValidationError struct {
	Field   string `json:"field"`
	Message string `json:"message"`
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("Validation failed for field: %s", e.Field)
}

// === Custom HTTP error handler ===

func customHTTPErrorHandler(err error, c echo.Context) {
	var (
		code = http.StatusInternalServerError
		msg  interface{}
	)

	switch e := err.(type) {
	case *echo.HTTPError:
		code = e.Code
		msg = map[string]interface{}{
			"error":   http.StatusText(code),
			"message": e.Message,
			"code":    code,
		}
		if e.Internal != nil {
			msg.(map[string]interface{})["internal"] = e.Internal.Error()
		}
	case *BusinessError:
		code = e.Status
		msg = map[string]interface{}{
			"error":   "business_error",
			"code":    e.Code,
			"message": e.Message,
		}
	case *ValidationError:
		code = http.StatusBadRequest
		msg = map[string]interface{}{
			"error":   "validation_error",
			"field":   e.Field,
			"message": e.Message,
		}
	default:
		msg = map[string]interface{}{
			"error":   "internal_error",
			"message": "Something went wrong",
		}
	}

	// Не отправляем ответ, если он уже отправлен
	if !c.Response().Committed {
		if c.Request().Method == http.MethodHead {
			c.NoContent(code)
		} else {
			c.JSON(code, msg)
		}
	}
}

// === Handlers ===

func handleNotFound(c echo.Context) error {
	return echo.NewHTTPError(http.StatusNotFound, "Resource not found")
}

func handleBadRequest(c echo.Context) error {
	return echo.NewHTTPError(http.StatusBadRequest, "Invalid request parameters")
}

func handleUnauthorized(c echo.Context) error {
	return echo.NewHTTPError(http.StatusUnauthorized, "Authentication required")
}

func handleForbidden(c echo.Context) error {
	return echo.NewHTTPError(http.StatusForbidden, "Access denied")
}

func handleBusinessError(c echo.Context) error {
	return &BusinessError{
		Code:    "INSUFFICIENT_FUNDS",
		Message: "Your account has insufficient funds",
		Status:  http.StatusPaymentRequired,
	}
}

func handleValidationError(c echo.Context) error {
	return &ValidationError{
		Field:   "email",
		Message: "Invalid email format",
	}
}

func handleInternalError(c echo.Context) error {
	// Симуляция внутренней ошибки
	dbError := errors.New("database connection failed")
	return echo.NewHTTPError(http.StatusInternalServerError, "Internal server error").SetInternal(dbError)
}

func handleRecoveredError(c echo.Context) error {
	// Симуляция паники (будет перехвачена Recover middleware)
	panic("unexpected panic occurred!")
}

func handleSuccess(c echo.Context) error {
	return c.JSON(http.StatusOK, map[string]string{
		"message": "Success!",
	})
}

func main() {
	e := echo.New()

	// Custom error handler
	e.HTTPErrorHandler = customHTTPErrorHandler

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Routes для тестирования ошибок
	e.GET("/error/not-found", handleNotFound)
	e.GET("/error/bad-request", handleBadRequest)
	e.GET("/error/unauthorized", handleUnauthorized)
	e.GET("/error/forbidden", handleForbidden)
	e.GET("/error/business", handleBusinessError)
	e.GET("/error/validation", handleValidationError)
	e.GET("/error/internal", handleInternalError)
	e.GET("/error/panic", handleRecoveredError)
	e.GET("/success", handleSuccess)

	// Global 404 handler
	e.NotFoundHandler = func(c echo.Context) error {
		return echo.NewHTTPError(http.StatusNotFound, map[string]interface{}{
			"error":   "not_found",
			"message": fmt.Sprintf("Route %s %s not found", c.Request().Method, c.Request().URL.Path),
			"path":    c.Request().URL.Path,
		})
	}

	e.Logger.Info("🚫 Error handling server starting on http://localhost:8080")
	e.Logger.Fatal(e.Start(":8080"))
}
