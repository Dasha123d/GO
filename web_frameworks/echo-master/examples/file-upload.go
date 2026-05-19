//go:build ignore

package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	// Создаем папку uploads, если нет
	os.MkdirAll("uploads", os.ModePerm)

	e.POST("/upload", func(c echo.Context) error {
		// Получаем файл из формы
		file, err := c.FormFile("file")
		if err != nil {
			return err
		}

		src, err := file.Open()
		if err != nil {
			return err
		}
		defer src.Close()

		// Путь для сохранения
		dstPath := filepath.Join("uploads", file.Filename)
		dst, err := os.Create(dstPath)
		if err != nil {
			return err
		}
		defer dst.Close()

		// Копируем файл
		if _, err = io.Copy(dst, src); err != nil {
			return err
		}

		return c.JSON(http.StatusOK, map[string]string{
			"message": fmt.Sprintf("Файл '%s' загружен успешно", file.Filename),
			"size":    fmt.Sprintf("%d байт", file.Size),
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
