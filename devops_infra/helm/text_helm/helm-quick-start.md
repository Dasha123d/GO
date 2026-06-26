# Быстрый старт: установка и первый релиз

## Установка

```bash
go get helm.sh/helm/v3
```
## Подготовка клиента
```go
import (
    "helm.sh/helm/v3/pkg/action"
    "k8s.io/client-go/tools/clientcmd"
)

func main() {
    kubeconfig := clientcmd.RecommendedHomeFile
    config, _ := clientcmd.BuildConfigFromFlags("", kubeconfig)

    actionConfig := new(action.Configuration)
    if err := actionConfig.Init(
        k8sConfigFlags, // или clientcmd.NewDefaultClientConfigLoadingRules()
        "default",       // namespace
        "secret",        // драйвер хранения (secret, configmap, memory)
        func(format string, v ...interface{}) {
            fmt.Sprintf(format, v...)
        },
    ); err != nil {
        panic(err)
    }
    // actionConfig готов для выполнения операций
}
```
## Установка чарта
```go
install := action.NewInstall(actionConfig)
install.ReleaseName = "my-release"
install.Namespace = "default"
chartPath := "./mychart" // локальный путь или имя в репозитории
rel, err := install.Run(chart, values)
if err != nil {
    panic(err)
}
fmt.Println("Установлен релиз:", rel.Name)
```
Теперь вы управляете Helm напрямую из Go.