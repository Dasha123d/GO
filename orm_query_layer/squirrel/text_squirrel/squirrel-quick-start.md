# Быстрый старт: установка и первый запрос

## Установка

```bash
go get github.com/Masterminds/squirrel
```
Для работы с конкретной БД дополнительно нужен драйвер, например:
```bash
go get github.com/lib/pq          # PostgreSQL
go get github.com/go-sql-driver/mysql # MySQL
go get github.com/mattn/go-sqlite3    # SQLite
```

## Создание построителя
squirrel предоставляет `StatementBuilderType`, который можно создать так:
```go
import (
    sq "github.com/Masterminds/squirrel"
)

var psql = sq.StatementBuilder.PlaceholderFormat(sq.Dollar)
```
* `PlaceholderFormat(sq.Dollar)` — для PostgreSQL ($1, $2, ...)
* `PlaceholderFormat(sq.Question)` — для MySQL / SQLite (?)

## Простой SELECT
```go
sql, args, err := psql.
    Select("id, name, age").
    From("users").
    Where(sq.Eq{"active": true}).
    OrderBy("name ASC").
    Limit(10).
    ToSql()

if err != nil {
    log.Fatal(err)
}
fmt.Println(sql)  // SELECT id, name, age FROM users WHERE active = $1 ORDER BY name ASC LIMIT 10
fmt.Println(args) // [true]
```
## Выполнение запроса
```go
rows, err := db.Query(sql, args...)
```
## Почему squirrel?
* Позволяет строить SQL динамически без конкатенации строк.
* Защищает от SQL-инъекций (параметры подставляются через плейсхолдеры).
* Читаемый цепочечный синтаксис.
* Никакого ORM и маппинга — только SQL-построитель.