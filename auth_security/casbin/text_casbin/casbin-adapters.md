# Адаптеры: хранение политик в БД, файлах и Redis

## Встроенный файловый адаптер

`NewEnforcer("model.conf", "policy.csv")` использует файловый адаптер (не для прода, политика загружается в память).

## Популярные адаптеры

- **GORM:** `github.com/casbin/gorm-adapter/v3`
- **SQL:** `github.com/casbin/sqlx-adapter` (чистый SQL)
- **Redis:** `github.com/casbin/redis-adapter/v3`
- **MongoDB, DynamoDB** и др.

## Пример с GORM и PostgreSQL

```go
import (
    "github.com/casbin/casbin/v2"
    gormadapter "github.com/casbin/gorm-adapter/v3"
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
)

func main() {
    dsn := "host=localhost user=postgres password=... dbname=casbin port=5432"
    db, _ := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    adapter, _ := gormadapter.NewAdapterByDB(db)
    e, _ := casbin.NewEnforcer("model.conf", adapter)
    // загружаем политики из БД (или используем LoadPolicy)
    e.LoadPolicy()
    // ...
}
```
Адаптер автоматически создаст таблицы `casbin_rule`.

## Фильтрация с адаптером
```go
e.LoadFilteredPolicy(&casbin.Filter{
    P: [][]string{{"alice"}},
    G: [][]string{{"alice"}},
})
```
Загружаются только строки, где первый элемент совпадает с "alice".

## AutoSave
Включает немедленное сохранение в БД при добавлении/удалении:
```go
e.EnableAutoSave(true)
defer e.EnableAutoSave(false)
```
## Своя стратегия загрузки
Можно реализовать интерфейс `persist.Adapter` и загружать политики из внешнего источника (API, файлы).