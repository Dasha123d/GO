# Сгенерированные модели: структура и API

## Базовая структура

Для таблицы `users` генерируется `models.User` с полями, соответствующими столбцам:

```go
type User struct {
    ID        int       `boil:"id" json:"id" toml:"id" yaml:"id"`
    Name      string    `boil:"name" json:"name" toml:"name" yaml:"name"`
    Age       int       `boil:"age" json:"age" toml:"age" yaml:"age"`
    CreatedAt time.Time `boil:"created_at" json:"created_at" toml:"created_at" yaml:"created_at"`

    R *userR `boil:"-" json:"-" toml:"-" yaml:"-"`
    L userL  `boil:"-" json:"-" toml:"-" yaml:"-"`
}
```
* `R` — структура для eager-loaded связанных моделей.
* `L` — локальные переменные (для внутренних нужд).

## Обязательные методы
Каждая модель реализует:
* `Insert(ctx, db, boil.Columns)` — вставка
* `Update(ctx, db, boil.Columns)` — обновление
* `Upsert(ctx, db, conflictColumns, updateColumns)` — upsert
* `Delete(ctx, db)` — удаление
* `Reload(ctx, db)` — перезагрузка из БД
* `Exists(ctx, db)` — проверка существования

## Слайсы моделей
Для каждого типа есть слайс (например, `UserSlice`), поддерживающий:
* `InsertAll(ctx, db, boil.Columns)`
* `UpdateAll(ctx, db, boil.Columns)`
* `DeleteAll(ctx, db)`

## Переменные столбцов
Генерируются переменные для безопасных ссылок на столбцы:
```go
models.UserColumns.ID   // "id"
models.UserColumns.Name // "name"
```
Используются в запросах (`qm.Select`, `qm.Where`).

## Конфигурация типов
В `sqlboiler.toml` можно переопределить маппинг типов, задать blacklist/whitelist таблиц.