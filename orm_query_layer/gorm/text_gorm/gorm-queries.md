# Запросы в GORM

## Чтение

```go
var user User
db.First(&user, 1)                    // по ID
db.First(&user, "name = ?", "Alice")  // по условию
db.Take(&user)                        // случайная запись
db.Last(&user)                        // последняя запись

var users []User
db.Where("age > ?", 18).Find(&users)  // все подходящие
db.Where("name IN ?", []string{"Alice", "Bob"}).Find(&users)
db.Where("name LIKE ?", "%A%").Find(&users)
```
## Цепочки условий
```go
db.Where("age > ?", 18).Or("age < ?", 30).Find(&users)
db.Where("name = ?", "Alice").Or("name = ?", "Bob").Find(&users)
```
## Выборка полей
```go
db.Select("name", "age").Find(&users)
db.Select("COALESCE(age,42)").Find(&users)
```

## Порядок и пагинация
```go
db.Order("age desc, name").Find(&users)
db.Limit(10).Offset(20).Find(&users)
```

## Группировка и агрегаты
```go
type Result struct {
    Name  string
    Total int
}
var results []Result
db.Model(&User{}).Select("name, SUM(age) as total").Group("name").Find(&results)
```

## Joins
```go
db.Joins("Company").Find(&users)
db.Joins("JOIN emails ON emails.user_id = users.id").Find(&users)
```

## Сырые запросы
```go
db.Raw("SELECT name, age FROM users WHERE age > ?", 20).Scan(&users)
db.Exec("UPDATE users SET age = ? WHERE id = ?", 21, 1)
```