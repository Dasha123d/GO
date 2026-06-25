# Быстрый старт: установка, схема и первый запрос

## Установка

```bash
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
```
## Структура проекта
```text
myapp/
├── sqlc.yaml          # конфигурация
├── queries/
│   └── users.sql      # SQL-запросы
├── schema/
│   └── schema.sql     # DDL (таблицы)
└── generated/         # будет создан sqlc
```
## Конфигурация (`sqlc.yaml`)
```yaml
version: "2"
sql:
  - engine: "postgresql"
    schema: "schema/schema.sql"
    queries: "queries/"
    gen:
      go:
        package: "generated"
        out: "generated"
        sql_package: "pgx/v5"
```
## Схема (`schema/schema.sql`)
```sql
CREATE TABLE users (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age  INT NOT NULL
);
```
## Запрос (`queries/users.sql`)
```sql
-- name: GetUser :one
SELECT * FROM users WHERE id = $1;

-- name: ListUsers :many
SELECT * FROM users ORDER BY name;

-- name: CreateUser :one
INSERT INTO users (name, age) VALUES ($1, $2) RETURNING *;
```
## Генерация кода
```bash
sqlc generate
```
В папке `generated/` появятся Go-файлы с функциями: `GetUser`, `ListUsers`, `CreateUser`.

## Использование
```go
import (
    "context"
    "github.com/jackc/pgx/v5"
    "myapp/generated"
)

func main() {
    conn, _ := pgx.Connect(context.Background(), "postgres://...")
    db := generated.New(conn)

    user, err := db.CreateUser(context.Background(), generated.CreateUserParams{
        Name: "Alice",
        Age:  30,
    })
    // user имеет типизированные поля
}
```
Всё готово: типизированный, безопасный код из чистого SQL.