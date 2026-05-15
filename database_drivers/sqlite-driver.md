# Драйвер SQLite3

Наиболее популярный драйвер: `github.com/mattn/go-sqlite3` (требует CGO).  
Есть альтернатива без CGO: `modernc.org/sqlite` (чистый Go), но рассмотрим классический.

## Особенности CGO

Драйвер использует библиотеку SQLite на C, поэтому для сборки требуется C-компилятор (gcc). В продакшене это может усложнить развёртывание. Альтернатива `modernc.org/sqlite` не требует CGO, но может быть медленнее.

## Подключение

```go
import (
    "database/sql"
    _ "github.com/mattn/go-sqlite3"
)
db, err := sql.Open("sqlite3", "./test.db") // файловая БД
```

Для in-memory базы (часто используется в тестах):
```go
db, err := sql.Open("sqlite3", ":memory:")
```

## Параметры DSN
Можно добавлять параметры после имени файла через `?`:

* `cache=shared` – разделяемый кэш между соединениями.
* `mode=rwc` – создать файл, если не существует.
* `_busy_timeout=5000` – ждать при блокировке (мс).
* `_foreign_keys=on` – включить поддержку внешних ключей (по умолчанию выключена).

Пример:
```go
db, err := sql.Open("sqlite3", "file:test.db?cache=shared&mode=rwc&_foreign_keys=on")
```

## Выполнение запросов
Плейсхолдеры: `?` или `$1`, `$2` (SQLite поддерживает оба, но лучше `?` для совместимости).
```go
db.Exec("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)")
```

## Транзакции и конкурентность
SQLite блокирует всю базу при записи. Используйте `_busy_timeout`, чтобы не получать ошибки `database is locked`. Лучше минимизировать конкурентные записи.

## Использование в тестах
Очень удобно создавать in-memory базу в каждом тесте:
```go
func TestSomething(t *testing.T) {
    db, err := sql.Open("sqlite3", ":memory:")
    if err != nil {
        t.Fatal(err)
    }
    defer db.Close()
    // миграции...
    // тесты...
}
```