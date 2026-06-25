# Аннотации запросов: `:one`, `:many`, `:exec`, `:execrows` и др.

## Основные аннотации

- `:one` – возвращает одну строку (ошибка, если строк 0 или >1).
- `:many` – возвращает слайс строк.
- `:exec` – выполняет запрос, возвращает `sql.Result`.
- `:execrows` – выполняет запрос, возвращает количество затронутых строк (`int64`).
- `:execresult` – выполняет, возвращает `pgconn.CommandTag` (только pgx).
- `:batchone` / `:batchmany` – для пакетной вставки (batch).
- `:copyfrom` – для `COPY FROM` (pgx).

Примеры:

```sql
-- name: UpdateUserAge :exec
UPDATE users SET age = $1 WHERE id = $2;

-- name: DeleteUser :execrows
DELETE FROM users WHERE id = $1;

-- name: CountUsers :one
SELECT COUNT(*) FROM users;
```
## Именованные параметры и структуры
Если параметров много, `sqlc` может сгенерировать структуру `Params`:
```sql
-- name: CreateUser :one
INSERT INTO users (name, age, email) VALUES ($1, $2, $3) RETURNING *;
```
Сгенерируется `CreateUserParams` с полями `Name`, `Age`, `Email`.

## Именованные параметры через `sqlc.arg`
Можно задать имена вручную для ясности:
```sql
-- name: SearchUsers :many
SELECT * FROM users
WHERE name LIKE '%' || sqlc.arg(search) || '%'
  AND age > sqlc.arg(min_age);
```
Параметры: `Search string`, `MinAge int`.

## IN-клаузы и слайсы
`sqlc` поддерживает `ANY` или `IN`:
```sql
-- name: GetUsersByIDs :many
SELECT * FROM users WHERE id = ANY($1::int[]);
```
Параметр будет `[]int32`.