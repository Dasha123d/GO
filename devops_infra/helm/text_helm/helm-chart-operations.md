# Работа с чартами: загрузка, упаковка, шаблоны

## Загрузка чарта из разных источников

```go
import "helm.sh/helm/v3/pkg/chart/loader"

// Локальная директория
chart, err := loader.Load("/path/to/chart")

// Архив .tgz
chart, err := loader.LoadArchive(reader)

// Из репозитория (сначала нужно скачать)
// Используется pkg/repo
```
## Упаковка чарта
```go
import "helm.sh/helm/v3/pkg/chart"

// Создать архив
archive, err := chart.Save(ch, "/output/dir")
```
## Рендеринг шаблонов
```go
import "helm.sh/helm/v3/pkg/engine"

values := map[string]interface{}{
    "image": map[string]interface{}{
        "repository": "nginx",
        "tag": "alpine",
    },
}
out, err := engine.Render(chart, values)
for name, content := range out {
    fmt.Println(name)
    fmt.Println(content)
}
```
## Линтинг
```go
import "helm.sh/helm/v3/pkg/lint"
results := lint.All("/path/to/chart", values)
for _, msg := range results.Messages {
    fmt.Println(msg.Severity, msg.Text)
}
```