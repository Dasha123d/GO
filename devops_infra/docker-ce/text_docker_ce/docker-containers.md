# Работа с контейнерами

## Запуск контейнера

```go
resp, err := cli.ContainerCreate(ctx, &container.Config{
    Image: "nginx:alpine",
    Cmd:   []string{"nginx", "-g", "daemon off;"},
}, &container.HostConfig{}, nil, nil, "my-nginx")
if err != nil {
    panic(err)
}
err = cli.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{})
```
## Список контейнеров
```go
containers, err := cli.ContainerList(ctx, types.ContainerListOptions{All: true})
```

## Остановка и удаление
```go
timeout := 10 * time.Second
cli.ContainerStop(ctx, containerID, &timeout)
cli.ContainerRemove(ctx, containerID, types.ContainerRemoveOptions{Force: true})
```
## Логи контейнера
```go
out, err := cli.ContainerLogs(ctx, containerID, types.ContainerLogsOptions{ShowStdout: true})
if err != nil {
    panic(err)
}
defer out.Close()
io.Copy(os.Stdout, out)
```
## Exec (выполнение команды)
```go
execCfg := types.ExecConfig{
    Cmd:          []string{"ls", "-la"},
    AttachStdout: true,
    AttachStderr: true,
}
execResp, _ := cli.ContainerExecCreate(ctx, containerID, execCfg)
resp, _ := cli.ContainerExecAttach(ctx, execResp.ID, types.ExecStartCheck{})
defer resp.Close()
io.Copy(os.Stdout, resp.Reader)
```
## Инспектирование
```go
inspect, err := cli.ContainerInspect(ctx, containerID)
```
## Wait (ожидание завершения)
```go
statusCh, errCh := cli.ContainerWait(ctx, containerID, container.WaitConditionNotRunning)
select {
case err := <-errCh:
    if err != nil { panic(err) }
case status := <-statusCh:
    fmt.Println(status.StatusCode)
}
```