# Источник: https://uber-go.github.io/fx/#dependency-injection
# Лицензия: MIT
# Добавлено: 2026-05-20

# Внедрение зависимостей в Fx

## Базовый принцип
Fx использует **инъекцию по типу**: если функция возвращает тип `T`, а другая функция принимает `T` как параметр — Fx автоматически свяжет их.

```go
// Конструктор: создаёт *Config
func NewConfig() *Config { return &Config{...} }

// Конструктор: принимает *Config, создаёт *Database
func NewDatabase(cfg *Config) *Database { ... }

// Инвокер: принимает *Database
func runApp(db *Database) { ... }

// Fx автоматически:
// 1. Вызовет NewConfig()
// 2. Передаст результат в NewDatabase()
// 3. Передаст результат в runApp()