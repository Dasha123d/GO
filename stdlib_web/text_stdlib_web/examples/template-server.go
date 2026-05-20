// Сервер с рендерингом HTML-шаблона.
package main

import (
	"html/template"
	"log"
	"net/http"
)

type PageData struct {
	Title string
	Items []string
}

func main() {
	tmpl := template.Must(template.New("index").Parse(`
<!DOCTYPE html>
<html>
<head><title>{{.Title}}</title></head>
<body>
    <h1>{{.Title}}</h1>
    <ul>
        {{range .Items}}<li>{{.}}</li>{{end}}
    </ul>
</body>
</html>
`))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := PageData{
			Title: "My Page",
			Items: []string{"Item A", "Item B", "Item C"},
		}
		tmpl.Execute(w, data)
	})

	log.Println("Server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}