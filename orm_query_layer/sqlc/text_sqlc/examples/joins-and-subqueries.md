# Пример: JOIN и вложенные структуры

Файл: `examples/joins-and-subqueries.md`

**Схема:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY, name TEXT
);
CREATE TABLE orders (
    id SERIAL PRIMARY KEY, user_id INT REFERENCES users(id), amount INT
);
```
## Запрос:
```sql
-- name: ListUsersWithOrders :many
SELECT sqlc.embed(users), sqlc.embed(orders)
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```
## Код:
```go
rows, _ := db.ListUsersWithOrders(ctx)
for _, row := range rows {
    fmt.Println(row.User.Name, row.Order.Amount)
}
```