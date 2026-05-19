//go:build ignore

package main

import (
	"net/http"
	"time"

	"github.com/labstack/echo/v4"
)

// RequestIDMiddleware добавляет уникальный ID запросу
func RequestIDMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := "req-" + time.Now().Format("20060102150405")
		c.Set("requestID", id)
		c.Response().Header().Set("X-Request-ID", id)
		return next(c)
	}
}

// TimingMiddleware замеряет время выполнения запроса
func TimingMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		start := time.Now()
		err := next(c)
		stop := time.Now()

		id := c.Get("requestID")
		c.Logger().Infof("Request %v completed in %v", id, stop.Sub(start))

		return err
	}
}

func main() {
	e := echo.New()

	// Подключаем кастомные мидлвары
	e.Use(RequestIDMiddleware)
	e.Use(TimingMiddleware)

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Привет")
	})

	e.Logger.Fatal(e.Start(":8080"))
}
