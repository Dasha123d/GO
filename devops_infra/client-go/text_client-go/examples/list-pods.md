# Пример: Вывод списка Pod'ов

Файл: `examples/list-pods.go`

```go
func main() {
    config, _ := clientcmd.BuildConfigFromFlags("", clientcmd.RecommendedHomeFile)
    clientset, _ := kubernetes.NewForConfig(config)
    pods, _ := clientset.CoreV1().Pods("").List(context.Background(), metav1.ListOptions{})
    for _, p := range pods.Items {
        fmt.Println(p.Name)
    }
}
```