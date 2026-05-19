# Template Rendering

Пример рендеринга HTML-шаблонов с использованием стандартной библиотеки `html/template`.

## Описание
Echo позволяет использовать любой шаблонизатор. В этом примере реализован интерфейс `echo.Renderer` для интеграции `html/template`.

## Структура файлов
Для работы примера в директории рядом с `main.go` должна быть папка `templates/` с файлом `index.html`.

**templates/index.html:**
```html
<!DOCTYPE html>
<html>
  <head><title>{{.Title}}</title></head>
  <body>
    <h1>{{.Title}}</h1>
    <ul>
      {{range .Users}}
        <li>{{.}}</li>
      {{end}}
    </ul>
  </body>
</html>