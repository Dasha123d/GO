# Хуки (жизненный цикл)

## Виды хуков

- `BeforeCreate`, `AfterCreate`
- `BeforeUpdate`, `AfterUpdate`
- `BeforeSave` (перед Create и Update), `AfterSave`
- `BeforeDelete`, `AfterDelete`
- `AfterFind`

## Реализация

```go
func (u *User) BeforeCreate(tx *gorm.DB) (err error) {
    u.UUID = uuid.New().String()
    return nil
}

func (u *User) BeforeUpdate(tx *gorm.DB) (err error) {
    if u.Age < 0 {
        return errors.New("age must be positive")
    }
    return nil
}
```
## Применение ко всем операциям
```go
func (u *User) BeforeSave(tx *gorm.DB) (err error) {
    // будет вызван и перед Create, и перед Update
    return nil
}
```
## Ошибка в хуке
Если хук возвращает ошибку, операция прерывается.

## Хуки для ассоциаций
Существуют также хуки для связей: `BeforeCreateAssociation`, `AfterCreateAssociation` и т.д.