# Ассоциации: связи и предзагрузка

## Типы связей

- `Has One` / `Has Many` / `Belongs To` / `Many To Many`
- `References` и `Foreign Keys` настраиваются тегами.

### Примеры определений

```go
type User struct {
    gorm.Model
    Name      string
    CompanyID uint
    Company   Company `gorm:"foreignKey:CompanyID"` // Belongs To
    Orders    []Order // Has Many
}

type Company struct {
    ID   uint
    Name string
}

type Order struct {
    gorm.Model
    UserID uint
    Amount float64
    User   User `gorm:"foreignKey:UserID"` // Belongs To
}
```
## Создание со связями
```go
company := Company{Name: "Google"}
db.Create(&company)

user := User{Name: "Alice", Company: company}
db.Create(&user) // при создании автоматически свяжет
```

## Предзагрузка (Preload / Eager Loading)
```go
var users []User
db.Preload("Company").Preload("Orders").Find(&users)
```

## Вложенная предзагрузка
```go
db.Preload("Orders.Product").Find(&users)
```

## Предзагрузка с условием
```go
db.Preload("Orders", "amount > ?", 100).Find(&users)
```

## Association Mode
```go
var user User
db.First(&user, 1)

// добавить заказ
db.Model(&user).Association("Orders").Append(&Order{Amount: 50})

// удалить связь
db.Model(&user).Association("Orders").Delete(&Order{ID: 1})

// замена всех связей
db.Model(&user).Association("Orders").Replace(&newOrders)

// подсчёт
count := db.Model(&user).Association("Orders").Count()
```