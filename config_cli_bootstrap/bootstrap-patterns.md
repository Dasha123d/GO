# Паттерны начальной загрузки (bootstrap)

Bootstrap — процесс инициализации приложения от чтения конфигурации до запуска серверов. Хорошо структурированный `main()` облегчает тестирование и поддержку.

## Рекомендуемая последовательность

1. Загрузка конфигурации (файлы, env, флаги).
2. Инициализация логгера (см. `logging-setup.md`).
3. Создание основных компонентов (БД, клиенты, репозитории, сервисы).
4. Запуск HTTP/gRPC серверов.
5. Обработка сигналов ОС, graceful shutdown.

## Пример шаблона

```go
func main() {
    cfg := mustLoadConfig()
    logger := initLogger(cfg.LogLevel)
    db := mustConnectDB(cfg.DSN)
    defer db.Close()

    repo := repository.New(db)
    svc := service.New(repo)
    handler := transport.NewHTTP(svc)

    srv := &http.Server{Addr: cfg.Addr, Handler: handler}
    go func() {
        logger.Info("starting server", "addr", cfg.Addr)
        if err := srv.ListenAndServe(); err != http.ErrServerClosed {
            logger.Error("server error", err)
        }
    }()

    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    logger.Info("shutting down...")
    srv.Shutdown(context.Background())
}
```
## Разделение на этапы
Выносите каждый шаг в отдельную функцию, возвращающую ошибку — это упрощает тестирование и обработку ошибок.

Полный пример смотрите в `examples/bootstrap.go`.