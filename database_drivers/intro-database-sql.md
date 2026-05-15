# Введение в database/sql

Пакет `database/sql` предоставляет универсальный интерфейс для работы с реляционными базами данных в Go. Он не реализует подключение сам – вместо этого используются сторонние драйверы, соответствующие интерфейсу `database/sql/driver`.

## Регистрация драйверов

Обычно драйвер импортируется с пустым идентификатором, чтобы выполнилась его функция `init()`, регистрирующая драйвер:

```go
import (
    "database/sql"
    _ "github.com/lib/pq" // драйвер PostgreSQL
)```
После этого можно открыть соединение с помощью sql.Open(driverName, dataSourceName).
sql.Open не устанавливает соединение сразу – лишь инициализирует пул.

## Подключение и Ping
```go
db, err := sql.Open("postgres", "postgres://user:pass@localhost/testdb?sslmode=disable")
if err != nil {
    log.Fatal(err)
}
defer db.Close()

err = db.Ping()
if err != nil {
    log.Fatal("cannot reach database:", err)
}
```

## Выполнение запросов
Exec – для команд, не возвращающих строки (INSERT, UPDATE, DELETE)
```go
result, err := db.Exec("INSERT INTO users(name) VALUES($1)", "Alice")
if err != nil {
    // обработка
}
id, _ := result.LastInsertId()
affected, _ := result.RowsAffected()
```

## Query – для выборки нескольких строк
```go
rows, err := db.Query("SELECT id, name FROM users WHERE age > $1", 18)
if err != nil {
    log.Fatal(err)
}
defer rows.Close()

for rows.Next() {
    var id int
    var name string
    if err := rows.Scan(&id, &name); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%d: %s\n", id, name)
}
if err = rows.Err(); err != nil {
    log.Fatal(err)
}
```

## QueryRow – для одной строки
```go
var name string
err := db.QueryRow("SELECT name FROM users WHERE id = $1", 1).Scan(&name)
if err == sql.ErrNoRows {
    fmt.Println("not found")
} else if err != nil {
    log.Fatal(err)
}```

## Подготовленные выражения (Prepared Statements)
```go
stmt, err := db.Prepare("INSERT INTO users(name) VALUES($1)")
if err != nil {
    log.Fatal(err)
}
defer stmt.Close()

for _, name := range []string{"Bob", "Charlie"} {
    _, err = stmt.Exec(name)
    if err != nil {
        log.Fatal(err)
    }
}```

Подготовленные выражения повышают производительность при многократном выполнении и защищают от SQL-инъекций (параметры плейсхолдером).

## Обработка ошибок
* Всегда проверяйте ошибки после Exec, Query, Scan.
* Закрывайте rows с помощью defer rows.Close(), чтобы освободить соединение.
* Проверяйте rows.Err() после цикла.
* Используйте sql.ErrNoRows для проверки отсутствия результата.

## Транзакции
```go
tx, err := db.Begin()
if err != nil {
    log.Fatal(err)
}
defer tx.Rollback() // откат, если не закоммитили

_, err = tx.Exec("UPDATE accounts SET balance = balance - 100 WHERE id = $1", 1)
if err != nil {
    return // rollback произойдёт
}
_, err = tx.Exec("UPDATE accounts SET balance = balance + 100 WHERE id = $1", 2)
if err != nil {
    return
}
err = tx.Commit()
if err != nil {
    log.Fatal(err)
}```

## Резюме
* database/sql – это легковесный слой абстракции.
* Выбор драйвера осуществляется через импорт и driverName.
* Всегда управляйте ресурсами: закрывайте rows, stmt, db.
* Используйте контексты (QueryContext, ExecContext) для таймаутов и отмены.