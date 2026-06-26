# Сборка, push и Compose

## Полный цикл CI/CD

```go
// 1. Pull base
pullOut, _ := cli.ImagePull(ctx, "golang:1.21-alpine", types.ImagePullOptions{})
io.Copy(io.Discard, pullOut)

// 2. Build
buildCtx, _ := archive.TarWithOptions(".", &archive.TarOptions{})
buildResp, _ := cli.ImageBuild(ctx, buildCtx, types.ImageBuildOptions{
    Dockerfile: "Dockerfile",
    Tags:       []string{"app:latest"},
})
io.Copy(io.Discard, buildResp.Body)

// 3. Push
pushOut, _ := cli.ImagePush(ctx, "registry.example.com/app:latest", types.ImagePushOptions{})
io.Copy(io.Discard, pushOut)

// 4. Run
resp, _ := cli.ContainerCreate(ctx, &container.Config{Image: "app:latest"}, nil, nil, nil, "")
cli.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{})
```
## Docker Compose
Docker SDK не включает Compose напрямую, но есть:
* compose-go — парсер и types для docker-compose.yaml
* compose-spec — работа со спецификацией

Пример загрузки проекта:
```go
import "github.com/compose-spec/compose-go/v2/cli"
options, _ := cli.NewProjectOptions([]string{"docker-compose.yml"}, cli.WithOsEnv)
project, _ := cli.ProjectFromOptions(options)
```