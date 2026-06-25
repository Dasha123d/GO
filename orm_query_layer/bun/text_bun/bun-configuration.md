# Конфигурация bun: подключение, пулы, логирование

## Подключение через database/sql

```go
sqldb, _ := sql.Open("postgres", dsn)
db := bun.NewDB(sqldb, pgdialect.New())
```
## Пул соединений
Настройка через database/sql:
```go
sqldb.SetMaxOpenConns(25)
sqldb.SetMaxIdleConns(10)
sqldb.SetConnMaxLifetime(5 * time.Minute)
```

## Логирование запросов
```go
import "github.com/uptrace/bun/extra/bundebug"

db.AddQueryHook(bundebug.NewQueryHook(
    bundebug.WithVerbose(true),
    bundebug.FromEnv("BUNDEBUG"),
))
```

Теперь все SQL-запросы выводятся в stdout. `FromEnv` включает логирование при `BUNDEBUG=1`.

## Кастомный логгер
bun принимает любой логгер, реализующий интерфейс `bun.QueryHook`:
```go
type myQueryHook struct{}

func (h *myQueryHook) BeforeQuery(ctx context.Context, event *bun.QueryEvent) context.Context { return ctx }
func (h *myQueryHook) AfterQuery(ctx context.Context, event *bun.QueryEvent) {
    fmt.Println(time.Since(event.StartTime), string(event.Query))
}

db.AddQueryHook(&myQueryHook{})
```

## Настройка диалекта
Для каждого типа БД — свой диалект: `pgdialect`, `mysqldialect`, `sqlitedialect`.

## Контекст времени выполнения
Все методы принимают `context.Context`. Используйте `context.WithTimeout` для контроля времени запросов.