# Источник: https://uber-go.github.io/fx/modules.html
# Лицензия: MIT
# Добавлено: 2026-05-20

# Модули в Fx

## Что такое модуль?
`fx.Module` — это способ сгруппировать связанные зависимости, хуки и инвокеры в логическую единицу. Модули позволяют:
- Разбивать большое приложение на независимые части
- Переиспользовать конфигурации между проектами
- Изолировать тестирование компонентов

## Создание модуля
```go
databaseModule := fx.Module("database",
    fx.Provide(NewDatabase),
    fx.Invoke(InitDatabase),
    fx.Decorate(AddLoggingToDB),
)

app := fx.New(
    fx.Provide(NewConfig),
    databaseModule, // Встраивание модуля
    fx.Invoke(RunApp),
)