# Быстрый старт: установка, подключение и первый CRUD

## Установка

```bash
go get gorm.io/gorm
go get gorm.io/driver/postgres   # для PostgreSQL
# или gorm.io/driver/mysql, gorm.io/driver/sqlite
```
## Подключение
```go
import (
    "gorm.io/gorm"
    "gorm.io/driver/postgres"
)

func main() {
    dsn := "host=localhost user=test password=test dbname=test port=5432 sslmode=disable"
    db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if err != nil {
        panic("failed to connect database")
    }
}
```

## Модель и миграция
```go
type User struct {
    ID    uint   `gorm:"primaryKey"`
    Name  string `gorm:"size:255"`
    Email string `gorm:"uniqueIndex"`
}

db.AutoMigrate(&User{})
```

## CRUD
```go
// Create
user := User{Name: "Alice", Email: "alice@example.com"}
db.Create(&user)

// Read
var u User
db.First(&u, user.ID) // по первичному ключу
db.First(&u, "email = ?", "alice@example.com")

// Update
db.Model(&u).Update("Name", "Alice Updated")
// или
db.Model(&u).Updates(User{Name: "Alice", Email: "new@example.com"})

// Delete
db.Delete(&u, user.ID)
```
Готово — базовый GORM настроен и работает.