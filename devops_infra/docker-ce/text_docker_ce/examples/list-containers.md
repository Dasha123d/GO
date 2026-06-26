# Пример: Список контейнеров

Файл: `examples/list-containers.go`

```go
func main() {
    cli, _ := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
    containers, _ := cli.ContainerList(context.Background(), types.ContainerListOptions{})
    for _, c := range containers {
        fmt.Println(c.ID[:10], c.Names)
    }
}
```