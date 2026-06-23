# Продвинутое использование: кастомные маршалеры, анмаршалеры, omitempty

## Вложенные структуры и слайсы

Easyjson рекурсивно генерирует быстрый код для всех используемых типов (при условии, что для них тоже сгенерирован код).

```go
type Order struct {
    ID    int    `json:"id"`
    Items []Item `json:"items"`
}
//easyjson:json
type Item struct {
    Name  string `json:"name"`
    Price int    `json:"price"`
}
```
Метод `MarshalEasyJSON` для Order будет напрямую вызывать `MarshalEasyJSON` каждого элемента слайса.

## Кастомные маршалеры
Если для поля нужна нестандартная сериализация, можно реализовать интерфейс `easyjson.Marshaler`:
```go
type CustomDate time.Time

func (d CustomDate) MarshalEasyJSON(w *jwriter.Writer) {
    // форматируем в нужном виде
    w.String(time.Time(d).Format("2006-01-02"))
}
func (d *CustomDate) UnmarshalEasyJSON(r *jlexer.Lexer) {
    t, _ := time.Parse("2006-01-02", r.String())
    *d = CustomDate(t)
}
```
После этого используйте CustomDate в структурах – easyjson автоматически подхватит кастомный маршалер.

## Неэкспортируемые поля
По умолчанию easyjson работает только с экспортируемыми полями. Чтобы включить неэкспортируемые поля, добавьте аннотацию `//easyjson:json` к полю:
```go
//easyjson:json
type data struct {
    value int `json:"value"` // будет обработано
}
```
Но обычно проще оставить их инкапсулированными и добавить экспортируемые методы.

## Пропуск полей с omitempty
Easyjson уважает `json:",omitempty"` и не включает пустые значения в результат.

## Работа с `map[string]interface{}` и raw message
Генерируемый код напрямую обрабатывает и map, и `json.RawMessage`. Не требуется дополнительных действий.