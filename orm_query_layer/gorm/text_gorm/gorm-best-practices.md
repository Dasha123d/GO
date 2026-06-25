# Лучшие практики GORM

## 1. Не используйте `AutoMigrate` в production

Для продакшена используйте версионированные миграции (Atlas, golang-migrate).

## 2. Всегда проверяйте ошибки

```go
if err := db.Create(&user).Error; err != nil {
    // обработка
}
```
## 3. Используйте Select/Omit для частичного обновления
```go
db.Model(&user).Select("Name").Updates(User{Name: "New", Age: 0})
// обновит только Name
```

## 4. Будьте осторожны с массовым Update
Без `Where` обновляются все записи. Используйте `db.Where` или `db.Model`.

## 5. Для больших наборов данных используйте `Rows()`
```go
rows, _ := db.Model(&User{}).Rows()
defer rows.Close()
for rows.Next() {
    var user User
    db.ScanRows(rows, &user)
}
```
## 6. Настройте пул соединений
```go
sqlDB, _ := db.DB()
sqlDB.SetMaxIdleConns(10)
sqlDB.SetMaxOpenConns(100)
sqlDB.SetConnMaxLifetime(time.Hour)
```

## 7. Используйте контекст
```go
db.WithContext(ctx).First(&user, id)
```

## 8. Логируйте медленные запросы
Настройте свой логгер: `logger.New(writer, logger.Config{SlowThreshold: 200 * time.Millisecond})`

## 9. Включайте PrepareStmt в production для кэширования
```go
gorm.Open(postgres.Open(dsn), &gorm.Config{PrepareStmt: true})
```

## 10. Тестируйте с реальной БД или SQLite in-memory
Используйте `gorm.io/driver/sqlite` с `:memory:` для юнит-тестов.