# Быстрый старт: установка, подключение и первый контейнер

## Установка

```bash
go get github.com/docker/docker/client
```
## Подключение к демону Docker
```go
import (
    "context"
    "github.com/docker/docker/client"
)

func main() {
    cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
    if err != nil {
        panic(err)
    }
    defer cli.Close()
    // cli готов
}
```
* `FromEnv` подхватывает `DOCKER_HOST`, `DOCKER_TLS_VERIFY`, `DOCKER_CERT_PATH`.
* `WithAPIVersionNegotiation()` автоматически выбирает подходящую версию API.

## Проверка: список контейнеров
```go
containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
if err != nil {
    panic(err)
}
for _, container := range containers {
    fmt.Println(container.ID[:10], container.Image)
}
```
Вы только что подключились к Docker и получили список контейнеров.