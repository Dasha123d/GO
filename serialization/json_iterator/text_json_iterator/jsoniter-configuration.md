# Конфигурация jsoniter: API, режимы и тонкая настройка

## Конфигурация через API

jsoniter предоставляет несколько предустановленных конфигураций:

```go
import jsoniter "github.com/json-iterator/go"

var json = jsoniter.ConfigCompatibleWithStandardLibrary
var jsonFast = jsoniter.ConfigFastest
var jsonDefault = jsoniter.ConfigDefault
```
* `ConfigDefault` – сбалансированная.
* `ConfigFastest` – максимальная скорость, возможны небольшие расхождения в поведении с `encoding/json` (например, игнорирует `json.Unmarshaler` у полей для скорости).
* `ConfigCompatibleWithStandardLibrary` – полная совместимость, включены все проверки, чуть медленнее.

## Создание своей конфигурации
Можно тонко настроить через `jsoniter.API`:
```go
api := jsoniter.Config{
    EscapeHTML:                    true,  // экранирование HTML
    SortMapKeys:                   false, // сортировка ключей map
    ValidateJsonRawMessage:        true,
    ObjectFieldMustBeSimpleString: true,
    CaseSensitive:                 true,
}.Froze()

data, err := api.Marshal(obj)
```
После вызова `Froze()` конфигурация иммутабельна и потокобезопасна.

## Индивидуальные настройки для полей
Можно добавлять теги `json:"name"` и нестандартные поведения через регистрацию расширений, но базовая настройка идёт через API.

## Использование `jsoniter.Wrap` для сохранения конфигурации
Вместо глобальной переменной можно оборачивать стандартные вызовы:
```go
func Marshal(v interface{}) ([]byte, error) {
    return jsoniter.ConfigFastest.Marshal(v)
}
```
Рекомендуется один раз «заморозить» конфигурацию и использовать её везде.