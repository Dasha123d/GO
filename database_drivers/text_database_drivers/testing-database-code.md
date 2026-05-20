# Тестирование кода баз данных

Тестировать код, работающий с БД, можно несколькими способами.

## 1. In-memory SQLite

Самый лёгкий вариант – использовать SQLite в памяти. Замените реальный драйвер на `sqlite3` в тестах, передавая `*sql.DB`.

Пример:
```go
func setupTestDB(t *testing.T) *sql.DB {
    db, err := sql.Open("sqlite3", ":memory:")
    if err != nil {
        t.Fatalf("failed to open sqlite: %v", err)
    }
    // выполняем миграции
    db.Exec(`CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)`)
    return db
}
```

Плюсы: быстро, не требует внешней инфраструктуры. Минусы: не тестирует специфику целевой БД (например, особенности SQL диалекта PostgreSQL).

## 2. Docker-контейнеры с тестовыми БД
Запускаете экземпляр PostgreSQL, MySQL в Docker (например, через `testcontainers-go`). Подключаетесь к нему и выполняете тесты. Это даёт максимальное приближение к реальной среде.

Пример с testcontainers:
```go
import "github.com/testcontainers/testcontainers-go/modules/postgres"
container, err := postgres.RunContainer(ctx, testcontainers.WithImage("postgres:15-alpine"))
defer container.Terminate(ctx)
connStr, _ := container.ConnectionString(ctx)
db, _ := sql.Open("postgres", connStr)
```

Плюсы: полное соответствие production, поддержка специфических фич. Минусы: медленнее, требует Docker.

## 3. Моки с sqlmock
Библиотека `github.com/DATA-DOG/go-sqlmock` позволяет мокировать вызовы `database/sql` без реальной БД.`
```go
import "github.com/DATA-DOG/go-sqlmock"
db, mock, _ := sqlmock.New()
mock.ExpectQuery("SELECT name FROM users WHERE id = ?").
    WithArgs(1).
    WillReturnRows(sqlmock.NewRows([]string{"name"}).AddRow("Alice"))
```
Плюсы: очень быстро, изолированно. Минусы: тестируется лишь взаимодействие на уровне SQL-запросов, не выполняется настоящий SQL.

## 4. Репозиторий с интерфейсом
Шаблон: определяете интерфейс репозитория, в тестах подставляете мок-реализацию (ручную или через mockgen). Это unit-тесты бизнес-логики, не затрагивающие БД.

## Интеграционные тесты
Лучшая стратегия – комбинация:

unit-тесты с моками интерфейсов репозиториев,

интеграционные тесты с реальной БД (SQLite или Docker) для проверки запросов и миграций.

Используйте build tags: `//go:build integration` для медленных тестов, чтобы запускать их отдельно:
```go
//go:build integration
package mypackage
```
Запуск: `go test -tags=integration`.

## Заключение
Выбор подхода зависит от баланса между скоростью обратной связи и точностью. Начинайте с in-memory SQLite для быстрых тестов, добавляйте интеграционные тесты на CI с Docker.

