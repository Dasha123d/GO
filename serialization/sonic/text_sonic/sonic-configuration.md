# Конфигурация Sonic: Pretouch, API и тонкая настройка

## Предварительный прогрев (Pretouch)

Для достижения максимальной производительности в production среде рекомендуется предварительно «прогреть» типы, с которыми будете работать:

```go
import "github.com/bytedance/sonic"

func init() {
    sonic.Pretouch(reflect.TypeOf(User{}))
    // или через экземпляр
    sonic.Pretouch(reflect.TypeOf(User{}))
}
```
Вызывайте `Pretouch` на этапе инициализации для всех структур, участвующих в сериализации. Это компилирует специализированные кодексы.

Config API
Помимо глобальных функций, Sonic предоставляет `Config` для тонкой настройки:
```go
cfg := sonic.Config{
    EscapeHTML:  true,           // по умолчанию true, экранирует HTML
    SortMapKeys: false,          // сортировка ключей map
    Compact:     true,           // компактный вывод без пробелов
    IndentStep:  "  ",           // отступ при MarshalIndent
    NoValidateJSONMarshaler: false, // проверять интерфейс json.Marshaler
}.Froze() // обязательно заморозить для многопоточной безопасности

data, _ := cfg.Marshal(user)
```
После вызова `Froze()` конфигурация иммутабельна и потокобезопасна. Создавайте отдельные конфигурации для разных нужд.

## Опции анмаршалинга
Через `Config` можно управлять поведением:
* `UseNumber` – десериализация чисел в `json.Number`.
* `DisallowUnknownFields` – ошибка при неожиданных полях.
* `CaseSensitive` – чувствительность к регистру в именах полей.
* `ValidateString` – проверка на валидный UTF-8.

Пример:
```go
cfg := sonic.ConfigDefault
cfg.UseNumber = true
cfg.DisallowUnknownFields = true
cfg.Froze()

var m map[string]interface{}
err := cfg.Unmarshal([]byte(`{"a": 123}`), &m)
// m["a"] будет json.Number("123")
```
## Производительность и потоки
Sonic спроектирован для многопоточного использования. `Config.Froze()` гарантирует безопасность. Не забывайте вызывать `Pretouch` в `init()`, чтобы избежать гонок при первом обращении.