# Продвинутые возможности: CTE, JOIN, enum, транзакции

## JOIN и вложенные структуры

```sql
-- name: ListUsersWithOrders :many
SELECT users.*, orders.id as order_id, orders.amount
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```
sqlc сгенерирует плоскую структуру `ListUsersWithOrdersRow` со всеми полями. Для получения вложенной структуры используйте `sqlc.embed`:
```sql
-- name: ListUsersWithOrdersNested :many
SELECT sqlc.embed(users), sqlc.embed(orders)
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```
Теперь `Row` содержит `User` и `Order` как вложенные поля.

## CTE (WITH)
```sql
-- name: RecentActiveUsers :many
WITH active AS (
    SELECT * FROM users WHERE active = true
)
SELECT * FROM active WHERE created_at > $1;
```

## ENUM и пользовательские типы
При наличии в схеме `CREATE TYPE mood AS ENUM ('happy', 'sad');` sqlc сгенерирует соответствующий Go-тип (например, `string` или собственный тип).

## Транзакции
sqlc генерирует интерфейс `Querier`, который может использовать как `*sql.DB`, так и `*sql.Tx`. Просто передайте транзакцию:
```go
tx, _ := db.Begin(ctx)
defer tx.Rollback()

q := generated.New(tx)
q.CreateUser(ctx, params)
tx.Commit()
```
## Пакетные операции (batch)
```sql
-- name: InsertUsersBatch :batchone
INSERT INTO users (name, age) VALUES ($1, $2) RETURNING id;
```
Сгенерируется метод `InsertUsersBatch`, принимающий слайс параметров и возвращающий результаты.

## Копирование (COPY FROM)
```sql
-- name: CopyUsers :copyfrom
INSERT INTO users (name, age) VALUES ($1, $2);
```
Используется для высокопроизводительной вставки через pgx.
