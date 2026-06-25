# Транзакции

## Автоматическая транзакция

```go
err := db.Transaction(func(tx *gorm.DB) error {
    if err := tx.Create(&User{Name: "Alice"}).Error; err != nil {
        return err
    }
    if err := tx.Create(&Order{Amount: 100}).Error; err != nil {
        return err
    }
    return nil
})
```
## Ручное управление
```go
tx := db.Begin()
defer tx.Rollback()

if err := tx.Create(&user).Error; err != nil {
    tx.Rollback()
    return
}
if err := tx.Create(&order).Error; err != nil {
    tx.Rollback()
    return
}
tx.Commit()
```

## Savepoints
```go
tx := db.Begin()
tx.SavePoint("sp1")
// ...
tx.RollbackTo("sp1")
tx.Commit()
```

## Контекст транзакции
Транзакцию можно передавать через контекст с помощью `db.WithContext(ctx)`.