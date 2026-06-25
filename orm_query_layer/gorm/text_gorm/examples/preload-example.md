# Пример: Предзагрузка связей

```go
func main() {
    db, _ := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
    db.AutoMigrate(&User{}, &Order{})

    user := User{Name: "Alice"}
    db.Create(&user)
    db.Create(&Order{UserID: user.ID, Amount: 100})
    db.Create(&Order{UserID: user.ID, Amount: 200})

    var users []User
    db.Preload("Orders").Find(&users)
    for _, u := range users {
        fmt.Println(u.Name, len(u.Orders))
    }
}
```