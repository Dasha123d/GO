# Кодогенерация easyjson: флаги, теги и настройка

## Генерация для всех структур в пакете

```bash
easyjson -all pkg/models/*.go
```
Флаг `-all` генерирует код для всех подходящих структур (с комментарием `//easyjson:json` или без, если структура экспортируемая). Без флага – только для структур с явной аннотацией `//easyjson:json`.

## Другие флаги
* `-snake_case` – имена полей преобразуются в snake_case при генерации JSON-ключей.
* `-no_std_marshalers` – не генерировать адаптеры для json.Marshaler/json.Unmarshaler.
* `-lower_camel_case` – lowerCamelCase для ключей.
* `-build_tags` – указать build-теги.
* `-omit_empty` – автоматически добавлять `,omitempty` для всех полей.
* `-output_file` – задать имя выходного файла (по умолчанию `*_easyjson.go`).

Пример:
```bash
easyjson -snake_case -output_file custom_easyjson.go pkg/models/user.go
```
# Теги и аннотации
Основная аннотация:
```go
//easyjson:json
type MyStruct struct { ... }
```
Можно исключать поля из сериализации:
```go
//easyjson:json
type User struct {
    Name     string `json:"name"`
    Password string `json:"-"`
}
```
Дополнительные настройки в тегах:

* `easyjson:"-"` – пропустить поле.
* `easyjson:"optional"` – не вызывать ошибку при отсутствии поля.

## Интеграция в сборку
Добавьте вызов `easyjson` в `go generate`: