# Быстрый старт: установка, шаблон и первый плагин

## Установка SDK

```bash
go get github.com/grafana/grafana-plugin-sdk-go
```
Структура плагина
```text
my-datasource/
├── plugin.json          # метаданные плагина
├── main.go              # точка входа
└── go.mod
```
## plugin.json
```json
{
  "id": "myorg-simple-datasource",
  "name": "Simple Datasource",
  "version": "1.0.0",
  "backend": true,
  "executable": "gpx_myorg-simple-datasource",
  "metrics": true
}
```
## main.go
```go
package main

import (
    "github.com/grafana/grafana-plugin-sdk-go/backend/datasource"
    "github.com/grafana/grafana-plugin-sdk-go/backend/log"
)

func main() {
    if err := datasource.Serve(NewDataSource()); err != nil {
        log.DefaultLogger.Error(err.Error())
        os.Exit(1)
    }
}
```
SDK запускает gRPC-сервер для взаимодействия с Grafana.

Теперь плагин можно собрать и загрузить в Grafana.