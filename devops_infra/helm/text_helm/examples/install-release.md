# Пример: Установка чарта из файла

Файл: `examples/install-release.go`

```go
func main() {
    actionConfig := new(action.Configuration)
    // инициализация...
    install := action.NewInstall(actionConfig)
    install.ReleaseName = "my-nginx"
    chart, _ := loader.Load("./nginx")
    rel, _ := install.Run(chart, nil)
    fmt.Println(rel.Name)
}
```