# Пример: Список релизов

Файл: `examples/list-releases.go`

```go
list := action.NewList(actionConfig)
list.All = true
releases, _ := list.Run()
for _, rel := range releases {
    fmt.Println(rel.Name, rel.Info.Status)
}
```