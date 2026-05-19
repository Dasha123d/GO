package main

import (
	"html/template"
	"io"
	"net/http"

	"github.com/labstack/echo/v4"
)

// Template реализует интерфейс echo.Renderer
type Template struct {
	Templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.Templates.ExecuteTemplate(w, name, data)
}

func main() {
	e := echo.New()

	e.Renderer = &Template{
		// Парсим все шаблоны из директории templates/
		Templates: template.Must(template.ParseGlob("templates/*.html")),
	}

	e.GET("/", func(c echo.Context) error {
		// Данные для передачи в шаблон
		data := map[string]interface{}{
			"Title": "Главная страница",
			"Users": []string{"Алиса", "Боб", "Чарли"},
		}
		// Рендеринг шаблона index.html
		return c.Render(http.StatusOK, "index.html", data)
	})

	e.Logger.Fatal(e.Start(":8080"))
}
