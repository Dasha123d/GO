# Конфигурация sqlc: `sqlc.yaml` и `sqlc.json`

## Базовый формат

```yaml
version: "2"
sql:
  - engine: "postgresql"   # или "mysql", "sqlite"
    schema: "schema/*.sql"
    queries: "queries/*.sql"
    gen:
      go:
        package: "db"
        out: "db"
        sql_package: "pgx/v5"   # "database/sql" или "pgx/v5"
```
## Несколько наборов запросов
Можно генерировать код для разных схем или разных языков:
```yaml
sql:
  - engine: "postgresql"
    schema: "schema/pg.sql"
    queries: "queries/pg/"
    gen:
      go:
        package: "pg"
        out: "pg"
  - engine: "mysql"
    schema: "schema/mysql.sql"
    queries: "queries/mysql/"
    gen:
      go:
        package: "mysql"
        out: "mysql"
```
## Правила нейминга
В `sqlc.yaml` можно настроить переименование таблиц и колонок:
```yaml
gen:
  go:
    emit_json_tags: true
    json_tags_case_style: "camel"   # или "snake"
    emit_db_tags: true
```
## Переопределение типов
Для кастомных типов (например, `uuid.UUID`, `time.Time` в нужном формате) используется `overrides`:
```go
gen:
  go:
    overrides:
      - db_type: "uuid"
        go_type: "github.com/gofrs/uuid.UUID"
      - db_type: "timestamptz"
        go_type: "time.Time"
```
## Игнорирование таблиц
В секции `schema` можно указать `ignore_tables: ["migrations"]`.

## Продвинутая настройка
* `emit_interface` – генерирует интерфейс `Querier` со всеми методами (для мокирования).
* `emit_methods_with_db_argument` – добавляет `*sql.DB` аргумент в каждый метод.
* `emit_prepared_queries` – кэширование подготовленных выражений.