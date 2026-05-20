# Внедрение зависимостей в bootstrap

При усложнении приложения появляются зависимости между компонентами: репозиторий → сервис → обработчик. Управлять ими вручную неудобно, используют DI-контейнеры или явную композицию.

## Явная композиция (Pure DI)

Простой и рекомендуемый способ: создаём всё в `main` или в фабричной функции.

```go
func setupApp(cfg Config) (*http.Server, func(), error) {
    db, err := sql.Open("postgres", cfg.DSN)
    if err != nil { return nil, nil, err }
    cleanup := func() { db.Close() }

    userRepo := user.NewRepository(db)
    userSvc := user.NewService(userRepo)
    userHandler := http.NewUserHandler(userSvc)

    router := chi.NewRouter()
    router.Get("/users", userHandler.List)
    srv := &http.Server{Addr: cfg.Addr, Handler: router}
    return srv, cleanup, nil
}
```
## Использование DI-контейнеров
Библиотеки типа `google/wire` (генерация кода) или `uber-go/fx` (runtime) автоматизируют связывание. Wire предпочтительнее, так как ошибки выявляются на этапе компиляции.
```go
// wire.go
func InitializeApp(cfg Config) (*App, func(), error) {
    wire.Build(
        NewDB,
        user.NewRepository,
        user.NewService,
        user.NewHandler,
        NewRouter,
        NewApp,
    )
    return nil, nil, nil
}
```
После запуска `wire` генерирует `wire_gen.go` с явным кодом.

## Рекомендации
* Начинайте с Pure DI.
* Переходите к Wire, когда количество компонентов превышает ~10.
* Избегайте магического связывания, сохраняйте прозрачность.

Этот подход напрямую связан с bootstrap — смотрите примеры в `examples/bootstrap.go`.