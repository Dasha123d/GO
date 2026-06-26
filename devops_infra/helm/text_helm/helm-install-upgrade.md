# Установка, обновление, удаление и откат

## Install

```go
install := action.NewInstall(actionConfig)
install.ReleaseName = "my-app"
install.Namespace = "production"
install.CreateNamespace = true
install.Wait = true
install.Timeout = 5 * time.Minute

chart, err := loader.Load("./path/to/chart")
rel, err := install.Run(chart, map[string]interface{}{
    "replicaCount": 3,
})
```
## Upgrade
```go
upgrade := action.NewUpgrade(actionConfig)
upgrade.Namespace = "production"
upgrade.Wait = true
chart, _ := loader.Load("./chart-v2")
rel, err := upgrade.Run("my-app", chart, map[string]interface{}{})
```
## Rollback
```go
rollback := action.NewRollback(actionConfig)
rollback.Version = 2
err := rollback.Run("my-app")
```
## Uninstall
```go
uninstall := action.NewUninstall(actionConfig)
uninstall.Wait = true
_, err := uninstall.Run("my-app")
```

## History
```go
histClient := action.NewHistory(actionConfig)
histClient.Max = 5
history, err := histClient.Run("my-app")
for _, rel := range history {
    fmt.Println(rel.Version, rel.Info.Status)
}
```
## Status
```go
status := action.NewStatus(actionConfig)
rel, err := status.Run("my-app")
fmt.Println(rel.Info.Status)
```