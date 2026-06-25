# Работа с Data Frames

## Что такое `data.Frame`

Data frame — основной контейнер данных в Grafana. Содержит поля (`Field`), каждое из которых имеет тип и значения.

```go
import "github.com/grafana/grafana-plugin-sdk-go/data"

frame := data.NewFrame("metrics",
    data.NewField("time", nil, []time.Time{time.Now(), time.Now().Add(time.Minute)}),
    data.NewField("value", nil, []float64{1.0, 2.0}),
)
```
## Поддерживаемые типы полей
`int64`, `float64`, `string`, `bool`, `time.Time`, `json.RawMessage`.

## Добавление метаданных
```go
frame.Meta = &data.FrameMeta{
    Type: data.FrameTypeTimeSeriesWide,
}
```
## Лейблы
```go
field := data.NewField("value", data.Labels{"host": "server01"}, []float64{10})
```
Лейблы позволяют идентифицировать серии.

## Конвертация из структур
Используйте `data.FrameFromStruct` или ручное заполнение полей.