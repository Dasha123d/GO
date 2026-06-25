# Модели и миграции

## Определение модели

```go
type Product struct {
    gorm.Model            // ID, CreatedAt, UpdatedAt, DeletedAt
    Code  string `gorm:"unique;not null"`
    Price uint
    Tags  []Tag  `gorm:"many2many:product_tags"`
}
```
`gorm.Model` добавляет поля `ID`, `CreatedAt`, `UpdatedAt`, `DeletedAt` (soft delete).

## Теги полей
Основные теги:
* `primaryKey` — первичный ключ
* `unique` / `uniqueIndex` — уникальность
* `not null` — обязательное
* `default:value` — значение по умолчанию
* `size:255` — размер строки
* `precision` / `scale` — для чисел
* `autoIncrement` — автоинкремент
* `embedded` / `embeddedPrefix` — встраивание структур

Пример:
```go
type User struct {
    ID        uint   `gorm:"primaryKey;autoIncrement"`
    Name      string `gorm:"size:100;not null;default:'unknown'"`
    Age       uint   `gorm:"index"`
    CreatedAt time.Time
}
```
## AutoMigrate
```bash
db.AutoMigrate(&User{}, &Product{})
```
Создаёт/обновляет таблицы на основе структур. Не используйте в проде без версионирования; для production лучше использовать миграции (Atlas, golang-migrate).

## Конфигурация GORM
```go
gorm.Open(postgres.Open(dsn), &gorm.Config{
    SkipDefaultTransaction: true,  // отключает транзакцию по умолчанию для одиночных Create/Update/Delete
    PrepareStmt:            true,  // кэшировать подготовленные запросы
    Logger:                 logger.Default.LogMode(logger.Info),
})
```