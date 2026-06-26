# Работа с образами

## Список образов

```go
images, err := cli.ImageList(ctx, types.ImageListOptions{All: true})
```

## Pull образа
```go
out, err := cli.ImagePull(ctx, "alpine:latest", types.ImagePullOptions{})
if err != nil {
    panic(err)
}
defer out.Close()
io.Copy(os.Stdout, out) // показывает прогресс
```

## Сборка образа
```go
tar, _ := archive.TarWithOptions("path/to/context", &archive.TarOptions{})
buildOptions := types.ImageBuildOptions{
    Dockerfile: "Dockerfile",
    Tags:       []string{"myimage:latest"},
}
resp, err := cli.ImageBuild(ctx, tar, buildOptions)
if err != nil {
    panic(err)
}
defer resp.Body.Close()
io.Copy(os.Stdout, resp.Body)
```
## Push образа
```go
out, err := cli.ImagePush(ctx, "myregistry/myimage:latest", types.ImagePushOptions{
    RegistryAuth: authStr,
})
```
## Удаление образа
```go
_, err := cli.ImageRemove(ctx, imageID, types.ImageRemoveOptions{Force: true})
```

## Tag
```go
cli.ImageTag(ctx, sourceImage, targetImage)
```
## Save / Load (экспорт в tar)
Используйте `cli.ImageSave` и `cli.ImageLoad`.