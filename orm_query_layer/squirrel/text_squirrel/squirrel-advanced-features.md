# Продвинутые возможности

## Динамическое построение запросов

Часто нужно добавлять условия в зависимости от входных параметров. squirrel построен на иммутабельных билдерах, поэтому можно строить запрос постепенно:

```go
query := psql.Select("*").From("users")

if filter.Active {
    query = query.Where(sq.Eq{"active": true})
}
if filter.Name != "" {
    query = query.Where(sq.Like{"name": "%" + filter.Name + "%"})
}

sql, args, _ := query.ToSql()
```
## CASE, функции, выражения
Внутри `Select`, `Where`, `Set` можно использовать `sq.Expr` для произвольного SQL:
```go
psql.Select("id", sq.Expr("CASE WHEN active THEN 'Active' ELSE 'Inactive' END AS status")).
    From("users")
```
## Поддержка разных placeholder-форматов
* `sq.Dollar` — $1, $2 (PostgreSQL)
* `sq.Question` — ? (MySQL, SQLite)
* `sq.Colon` — :arg (sqlx named)

## Использование с транзакциями
Просто передавайте `*sql.Tx` при выполнении сгенерированного SQL:
```go
tx, _ := db.Begin()
sql, args, _ := psql.Insert("users")...
tx.Exec(sql, args...)
tx.Commit()
```
## Сырые куски SQL
```go
psql.Select("*").From("users").Where("age > ?", 18)
```
Можно смешивать с мапами:
```go
psql.Select("*").From("users").Where(sq.And{
    sq.Eq{"active": true},
    sq.Expr("age > ?", 18),
})
```
## Custom Placeholder
Можно реализовать свой `PlaceholderFormat`, если драйвер использует нестандартный синтаксис.

## Отладка
Чтобы посмотреть генерируемый SQL без выполнения (для логирования), используйте `ToSql()`.