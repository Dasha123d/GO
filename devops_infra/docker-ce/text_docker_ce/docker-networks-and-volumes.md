# Сети и тома

## Создание сети

```go
network, err := cli.NetworkCreate(ctx, "my-network", types.NetworkCreate{
    Driver: "bridge",
})
```
## Подключение контейнера к сети
```go
cli.NetworkConnect(ctx, network.ID, containerID, &network.EndpointSettings{})
```
## Список сетей
```go
networks, err := cli.NetworkList(ctx, types.NetworkListOptions{})
```
## Тома (volumes)
```go
vol, err := cli.VolumeCreate(ctx, volume.VolumeCreateBody{
    Name: "my-volume",
    Driver: "local",
})
cli.VolumeRemove(ctx, vol.Name, true)
volumes, _ := cli.VolumeList(ctx, volume.VolumeListOptions{})
```
## Bind mounts при создании контейнера
```go
hostConfig := &container.HostConfig{
    Mounts: []mount.Mount{
        {
            Type:   mount.TypeBind,
            Source: "/host/path",
            Target: "/container/path",
        },
    },
}
```