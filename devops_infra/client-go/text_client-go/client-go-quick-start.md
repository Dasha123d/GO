# Быстрый старт: установка, аутентификация и первый запрос

## Установка

```bash
go get k8s.io/client-go@latest
```
Требуется Go 1.21+.

## Настройка подключения
Обычно используется стандартный `kubeconfig` (файл `~/.kube/config`):
```go
import (
    "k8s.io/client-go/tools/clientcmd"
    "k8s.io/client-go/kubernetes"
)

func main() {
    config, err := clientcmd.BuildConfigFromFlags("", clientcmd.RecommendedHomeFile)
    if err != nil {
        panic(err)
    }
    clientset, err := kubernetes.NewForConfig(config)
    if err != nil {
        panic(err)
    }
    // clientset готов к использованию
}
```
## Первый запрос: список Pod'ов
```go
import (
    "context"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func main() {
    // ... инициализация clientset
    pods, err := clientset.CoreV1().Pods("default").List(context.Background(), metav1.ListOptions{})
    if err != nil {
        panic(err)
    }
    for _, pod := range pods.Items {
        fmt.Println(pod.Name)
    }
}
```
Вы только что получили список Pod'ов из кластера Kubernetes с помощью client-go.