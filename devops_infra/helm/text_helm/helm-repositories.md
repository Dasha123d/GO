# Управление репозиториями

## Добавление репозитория

```go
import "helm.sh/helm/v3/pkg/repo"

chartRepo, _ := repo.NewChartRepository(&repo.Entry{
    Name: "bitnami",
    URL:  "https://charts.bitnami.com/bitnami",
}, getter.All(settings))
chartRepo.CachePath = "/tmp/helmcache"
_, err := chartRepo.DownloadIndexFile()
```
## Поиск чартов
```go
index, err := repo.LoadIndexFile("/tmp/helmcache/bitnami-index.yaml")
for name, versions := range index.Entries {
    fmt.Println(name, versions[0].Version)
}
```
## Загрузка чарта из репозитория
```go
chartPath, _, err := chartRepo.DownloadChart("nginx", "15.0.0", "/tmp/charts")
chart, err := loader.Load(chartPath)
```
## Использование нескольких репозиториев
Создайте файл репозиториев (`repositories.yaml`) или управляйте через `repo.Entry`.