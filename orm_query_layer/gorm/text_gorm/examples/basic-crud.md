# Пример: Базовый CRUD

```go
package main

import (
    "gorm.io/driver/sqlite"
    "gorm.io/gorm"
)

type User struct {
    gorm.Model
    Name  string
    Email string `gorm:"unique"`
}

func main() {
    db, _ := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
    db.AutoMigrate(&User{})

    // Create
    user := User{Name: "Alice", Email: "alice@example.com"}
    db.Create(&user)

    // Read
    var u User
    db.First(&u, user.ID)

    // Update
    db.Model(&u).Update("Name", "Alice Updated")

    // Delete
    db.Delete(&u, u.ID)
}
```