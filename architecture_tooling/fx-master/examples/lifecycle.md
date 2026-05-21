# Источник: https://uber-go.github.io/fx/lifecycle.html
# Лицензия: MIT
# Добавлено: 2026-05-20

# Управление жизненным циклом в Fx

## Что такое Lifecycle?
`fx.Lifecycle` — это механизм для регистрации хуков, которые выполняются при старте и остановке приложения. Это позволяет корректно инициализировать и освобождать ресурсы: подключения к БД, серверы, воркеры.

## Регистрация хуков
```go
func setup(lc fx.Lifecycle, db *Database) {
    lc.Append(fx.Hook{
        OnStart: func(ctx context.Context) error {
            return db.Connect(ctx)
        },
        OnStop: func(ctx context.Context) error {
            return db.Close()
        },
    })
}