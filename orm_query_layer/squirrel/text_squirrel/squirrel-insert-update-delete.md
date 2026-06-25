# INSERT, UPDATE, DELETE

## INSERT

```go
sql, args, err := psql.Insert("users").
    Columns("name", "email", "age").
    Values("Alice", "alice@example.com", 30).
    ToSql()
// INSERT INTO users (name,email,age) VALUES ($1,$2,$3)
```
Для PostgreSQL поддерживается `RETURNING`:
```go
sql, args, err := psql.Insert("users").
    Columns("name", "email").
    Values("Alice", "alice@example.com").
    Suffix("RETURNING id").
    ToSql()
```
## Массовая вставка
```go
builder := psql.Insert("users").Columns("name", "email")
for _, user := range users {
    builder = builder.Values(user.Name, user.Email)
}
sql, args, err := builder.ToSql()
```
## UPDATE
```go
sql, args, err := psql.Update("users").
    Set("name", "Alice Updated").
    Set("active", false).
    Where(sq.Eq{"id": 1}).
    ToSql()
```
Использование мапы для обновления нескольких полей:
```go
user := map[string]interface{}{
    "name":   "Bob",
    "active": true,
}
sql, args, err := psql.Update("users").
    SetMap(user).
    Where(sq.Eq{"id": 1}).
    ToSql()
```
## DELETE
```go
sql, args, err := psql.Delete("users").
    Where(sq.Eq{"id": 1}).
    ToSql()
```
Для удаления по нескольким ID:
```go
psql.Delete("users").Where(sq.Eq{"id": []int{1,2,3}})
// ... WHERE id IN ($1,$2,$3)
```