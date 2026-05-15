
---

### Файл: postgres-drivers.md
```markdown
# Драйверы PostgreSQL: pq и pgx

В экосистеме Go два основных драйвера для PostgreSQL: `lib/pq` и `jackc/pgx`.

## lib/pq

Старейший и стабильный драйвер, реализующий `database/sql`.  
GitHub: `github.com/lib/pq`

Подключение:
```go
import (
    "database/sql"
    _ "github.com/lib/pq"
)
db, err := sql.Open("postgres", "postgres://user:pass@localhost/testdb?sslmode=disable")```
Особенности:
* Чистая реализация на Go (не требует CGO).
* Поддерживает listen/notify, COPY, массивы, hstore, JSON.
* Не поддерживает 100% типов PostgreSQL (например, numeric может быть представлен строкой).
* Подготовленные выражения кэшируются на стороне сервера.

## jackc/pgx
Современный высокопроизводительный драйвер, также имеет адаптер для `database/sql` через `pgx/v5/stdlib.`
GitHub: `github.com/jackc/pgx/v5`

Преимущества:
* В 2-3 раза быстрее pq на многих операциях.
* Поддержка примерно 80 встроенных типов PostgreSQL, включая `uuid`, `inet`, `interval`, `numeric` как `pgtype.Numeric`.
* Использование бинарного протокола, COPY.
* Поддержка контекста, транзакций с уровнями изоляции, пула соединений (`pgxpool`).
* Можно работать напрямую через `pgx.Connect`, минуя `database/sql`, для максимальной производительности и функциональности.
Пример прямого подключения с pgx:
```go
import "github.com/jackc/pgx/v5"
conn, err := pgx.Connect(context.Background(), "postgres://user:pass@localhost/testdb")
defer conn.Close(context.Background())

var name string
err = conn.QueryRow(context.Background(), "SELECT name FROM users WHERE id=$1", 1).Scan(&name)```
Через `database/sql`:
```go
import (
    "database/sql"
    _ "github.com/jackc/pgx/v5/stdlib"
)
db, err := sql.Open("pgx", "postgres://user:pass@localhost/testdb")```

## Работа с COPY
Оба драйвера поддерживают COPY, но pgx предоставляет более удобный потоковый API:
```go
// pgx
rows := [][]interface{}{{"Alice", 30}, {"Bob", 25}}
_, err = conn.CopyFrom(
    context.Background(),
    pgx.Identifier{"users"},
    []string{"name", "age"},
    pgx.CopyFromRows(rows),
)```
## Listen / Notify
pgx:
```go
conn.Exec(context.Background(), "LISTEN mychannel")
for {
    notification, err := conn.WaitForNotification(context.Background())
    if err != nil { break }
    fmt.Println("received:", notification.Payload)
}```
## Выбор драйвера
* Если нужна максимальная производительность и функциональность (типы, COPY, pool) – выбирайте pgx.
* Если важна минимальная зависимость и стандартное поведение – pq всё ещё хорош.
* Для новых проектов рекомендуется pgx.