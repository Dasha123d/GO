//go:build ignore

package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Сервер работает")
	})

	// Запуск сервера в отдельной горутине
	go func() {
		if err := e.Start(":8080"); err != nil && err != http.ErrServerClosed {
			e.Logger.Fatal("Ошибка запуска сервера: ", err)
		}
	}()

	// Ожидание сигнала завершения (SIGINT или SIGTERM)
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	// Подготовка контекста с таймаутом для завершения
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	e.Logger.Info("Выключение сервера...")
	if err := e.Shutdown(ctx); err != nil {
		e.Logger.Fatal("Ошибка выключения: ", err)
	}
	e.Logger.Info("Сервер успешно выключен")
}
