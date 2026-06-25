# Построение SELECT-запросов

## Базовые операции

```go
psql.Select("*").From("users")
psql.Select("id", "name").From("users")
```
## Условия WHERE
squirrel поддерживает удобные мапы для условий:
* `sq.Eq{"field": value}` — field = value
* `sq.NotEq{"field": value}` — field != value
* `sq.Gt{"field": value}`, `sq.GtOrEq`, `sq.Lt`, `sq.LtOrEq`
* `sq.Like{"field": "%pattern%"}` — LIKE
```go
psql.Select("*").From("users").Where(sq.Eq{
    "active": true,
    "role":   "admin",
})
```
Для сложных условий можно использовать `sq.And` и `sq.Or`:
```go
psql.Select("*").From("users").Where(sq.And{
    sq.Eq{"active": true},
    sq.Or{
        sq.Eq{"role": "admin"},
        sq.Gt{"age": 18},
    },
})
```
## JOIN
```go
psql.Select("u.name, o.amount").
    From("users u").
    Join("orders o ON u.id = o.user_id").
    LeftJoin("profiles p ON u.id = p.user_id")
```
## GROUP BY, HAVING
```go
psql.Select("department, COUNT(*) as cnt").
    From("employees").
    GroupBy("department").
    Having("COUNT(*) > 5")
```
## ORDER BY, LIMIT, OFFSET
```go
psql.Select("*").From("users").
    OrderBy("created_at DESC").
    Limit(20).
    Offset(40)
```
## Подзапросы
```go
subQuery := psql.Select("id").From("users").Where(sq.Eq{"active": true})
psql.Select("*").From("orders").Where(subQuery.Prefix("user_id IN (").Suffix(")"))
```
## Сканирование одной строки
squirrel не умеет сканировать — используйте `QueryRow` / `Scan` стандартной библиотеки или `sqlx`. squirrel только генерирует SQL и аргументы.