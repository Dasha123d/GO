### Файл: mysql-driver.md
```markdown
# Драйвер MySQL

Основной драйвер MySQL для Go: `github.com/go-sql-driver/mysql`.

## Подключение и DSN

```go
import (
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)
db, err := sql.Open("mysql", "user:password@tcp(127.0.0.1:3306)/dbname?parseTime=true")```

Формат DSN: `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...]`.
Важные параметры:

* `parseTime=true` – преобразует поля `DATE`, `DATETIME` в `time.Time` (рекомендуется всегда).
* `loc=Local` – часовой пояс для времени.
* `charset=utf8mb4` – кодировка.
* `tls=true` или `tls=custom` – включение TLS.
* `allowNativePasswords=true` – для старых способов аутентификации.

Пример полного DSN:
```text
user:pass@tcp(localhost:3306)/mydb?parseTime=true&loc=Europe%2FMoscow&charset=utf8mb4```

## Выполнение запросов
Аналогично стандартному database/sql, но с плейсхолдером ? (не $1):
```go
db.Exec("INSERT INTO users(name, created_at) VALUES(?, NOW())", "Alice")```

## Prepared Statements и interpolateParams
По умолчанию prepared statements выполняются на стороне сервера. При большом количестве уникальных запросов это может нагружать сервер. Чтобы включить интерполяцию параметров на стороне клиента (превращается в обычный запрос), добавьте `interpolateParams=true` в DSN.

## Работа с NULL
Если поле может быть NULL, используйте `sql.NullString`, `sql.NullInt64` и т.д., или указатели:
```go
var name sql.NullString
err := db.QueryRow("SELECT name FROM users WHERE id=?", 1).Scan(&name)
if name.Valid {
    fmt.Println(name.String)
}```

## Часовые пояса и parseTime
При `parseTime=true` драйвер автоматически сканирует `DATE` / `DATETIME` в `time.Time`, используя `loc`. Убедитесь, что параметр `loc` соответствует вашему приложению, иначе время может быть смещено.

## Транзакции
Поддерживаются стандартные транзакции с `db.Begin()`, `tx.Commit()`, `tx.Rollback()`.

## Лучшие практики
* Всегда указывайте `parseTime=true`.
* Используйте `sql.NullXXX` или указатели для nullable колонок.
* Настройте пул соединений (см. предыдущий раздел).
* Для production настройте TLS.