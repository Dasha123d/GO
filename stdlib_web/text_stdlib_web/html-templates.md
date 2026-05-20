# Работа с html/template

Пакет `html/template` предоставляет безопасный механизм генерации HTML, автоматически экранируя данные для предотвращения XSS-атак.

## Парсинг шаблонов

```go
tmpl := template.Must(template.New("index").Parse(`
    <h1>Hello, {{.Name}}!</h1>
    <ul>
        {{range .Items}}
            <li>{{.}}</li>
        {{end}}
    </ul>
`))
```
## Выполнение шаблона
```go
data := struct {
    Name  string
    Items []string
}{
    Name:  "User",
    Items: []string{"Item 1", "Item 2"},
}
tmpl.Execute(w, data)
```

## Загрузка из файлов
```go
tmpl, err := template.ParseFiles("templates/index.html", "templates/base.html")
if err != nil {
    log.Fatal(err)
}
```
## Особенности
* `html/template` экранирует данные в зависимости от контекста (HTML, JavaScript, CSS, URL).
* Для передачи данных в шаблон используйте структуры или map'ы.
* Шаблоны можно вкладывать с помощью `{{template "name" .}}`.

Смотрите пример в `examples/template-server.go`.