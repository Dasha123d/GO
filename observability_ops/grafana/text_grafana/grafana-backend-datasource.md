# Создание backend datasource

## Реализация `datasource.Datasource`

```go
type MyDataSource struct {
    // ...
}

func (d *MyDataSource) QueryData(ctx context.Context, req *backend.QueryDataRequest) (*backend.QueryDataResponse, error) {
    response := backend.NewQueryDataResponse()
    for _, q := range req.Queries {
        // парсим JSON-модель запроса, выполняем логику
        frame := data.NewFrame("response", data.NewField("time", nil, []time.Time{time.Now()}))
        response.Responses[q.RefID] = backend.DataResponse{
            Frames: data.Frames{frame},
        }
    }
    return response, nil
}

func (d *MyDataSource) CheckHealth(ctx context.Context, req *backend.CheckHealthRequest) (*backend.CheckHealthResult, error) {
    return &backend.CheckHealthResult{Status: backend.HealthStatusOk, Message: "Working"}, nil
}
```
## Регистрация
```go
func NewDataSource() *instancemgmt.DataSourceInstanceManager {
    return datasource.NewDataSourceInstanceManager(func(ctx context.Context, settings backend.DataSourceInstanceSettings) (instancemgmt.Instance, error) {
        return &MyDataSource{}, nil
    })
}
```
Теперь Grafana может отправлять запросы, а плагин — возвращать фреймы данных.