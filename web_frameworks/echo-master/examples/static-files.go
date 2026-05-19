// examples/static-files.go
// Примеры раздачи статических файлов в Echo
// Запуск: go run static-files.go

package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()

	// Создаём тестовые директории и файлы
	os.MkdirAll("static/css", 0755)
	os.MkdirAll("static/js", 0755)
	os.MkdirAll("static/images", 0755)
	os.MkdirAll("public", 0755)
	os.MkdirAll("uploads", 0755)

	// Создаём тестовые файлы
	os.WriteFile("static/css/style.css", []byte("body { margin: 0; }"), 0644)
	os.WriteFile("static/js/app.js", []byte("console.log('Hello');"), 0644)
	os.WriteFile("static/index.html", []byte("<html><body>Index</body></html>"), 0644)
	os.WriteFile("public/readme.txt", []byte("Public file"), 0644)

	// === Вариант 1: Static files с префиксом ===
	// Доступ: http://localhost:8080/static/style.css
	e.Static("/static", "static")

	// === Вариант 2: Static files с кастомной конфигурацией ===
	e.Use(middleware.StaticWithConfig(middleware.StaticConfig{
		Root:       "public",
		Index:      "index.html",
		Browse:     true, // Разрешить просмотр директорий
		IgnoreBase: true,
	}))

	// === Вариант 3: Раздача файлов с разных путей ===
	e.Static("/css", "static/css")
	e.Static("/js", "static/js")
	e.Static("/images", "static/images")

	// === Вариант 4: Кастомный handler для файлов ===
	e.GET("/files/*", func(c echo.Context) error {
		path := filepath.Join("uploads", c.Param("*"))

		// Проверка существования файла
		if _, err := os.Stat(path); os.IsNotExist(err) {
			return echo.NewHTTPError(http.StatusNotFound, "File not found")
		}

		return c.File(path)
	})

	// === Вариант 5: Download файлов ===
	e.GET("/download/:name", func(c echo.Context) error {
		name := c.Param("name")
		path := filepath.Join("uploads", name)

		if _, err := os.Stat(path); os.IsNotExist(err) {
			return echo.NewHTTPError(http.StatusNotFound, "File not found")
		}

		return c.Attachment(path, name)
	})

	// === Вариант 6: Inline отображение файлов ===
	e.GET("/view/:name", func(c echo.Context) error {
		name := c.Param("name")
		path := filepath.Join("uploads", name)

		if _, err := os.Stat(path); os.IsNotExist(err) {
			return echo.NewHTTPError(http.StatusNotFound, "File not found")
		}

		return c.Inline(path, name)
	})

	// === Вариант 7: Загруженные файлы (upload) ===
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

		// Создаём файл для сохранения
		dst, err := os.Create(filepath.Join("uploads", file.Filename))
		if err != nil {
			return err
		}
		defer dst.Close()

		// Копируем содержимое
		if _, err = src.WriteTo(dst); err != nil {
			return err
		}

		return c.JSON(http.StatusOK, map[string]string{
			"message":  "File uploaded successfully",
			"filename": file.Filename,
			"size":     fmt.Sprintf("%d bytes", file.Size),
		})
	})

	// === Вариант 8: HTML страница со статикой ===
	e.GET("/", func(c echo.Context) error {
		html := `
        <!DOCTYPE html>
        <html>
        <head>
            <title>Static Files Demo</title>
            <link rel="stylesheet" href="/css/style.css">
        </head>
        <body>
            <h1>Static Files Demo</h1>
            <ul>
                <li><a href="/static/index.html">Static Index</a></li>
                <li><a href="/js/app.js">JS File</a></li>
                <li><a href="/public/readme.txt">Public File</a></li>
                <li><a href="/files/test.txt">Custom File Handler</a></li>
            </ul>
            <script src="/js/app.js"></script>
        </body>
        </html>
        `
		return c.HTML(http.StatusOK, html)
	})

	e.Logger.Info("📁 Static files server starting on http://localhost:8080")
	e.Logger.Fatal(e.Start(":8080"))
}
