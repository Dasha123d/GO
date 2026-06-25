# Health Check

## Обязательный метод

Каждый плагин должен реализовать `CheckHealth`:

```go
func (d *MyDataSource) CheckHealth(ctx context.Context, req *backend.CheckHealthRequest) (*backend.CheckHealthResult, error) {
    // проверка соединения с базой
    return &backend.CheckHealthResult{
        Status: backend.HealthStatusError,
        Message: "Cannot connect",
    }, nil
}
```
Статусы:
* `backend.HealthStatusOk`
* `backend.HealthStatusError`
* `backend.HealthStatusUnknown`

## Реакция в UI
При добавлении источника данных Grafana показывает статус и сообщение.