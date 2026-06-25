# Быстрый старт: установка и первый мок

## Установка

```bash
go get go.uber.org/mock/gomock
go install go.uber.org/mock/mockgen@latest
```
`mockgen` — утилита кодогенерации.

## Пишем интерфейс
`user/user.go`:
```go
package user

type Repository interface {
    FindByID(id int) (*User, error)
    Save(user *User) error
}
```

## Генерируем мок
```bash
mockgen -source user/user.go -destination mocks/user_mock.go -package mocks
```
Или через go:generate:
```go
//go:generate mockgen -source=$GOFILE -destination=../mocks/${GOFILE}_mock.go -package=mocks
```
## Используем в тесте
```go
func TestGetUser(t *testing.T) {
    ctrl := gomock.NewController(t)
    defer ctrl.Finish()

    mockRepo := mocks.NewMockRepository(ctrl)
    mockRepo.EXPECT().FindByID(1).Return(&User{Name: "Alice"}, nil)

    svc := NewUserService(mockRepo)
    name, err := svc.GetUserName(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
}
```
* `gomock.NewController(t)` — управляет моками, проверяет ожидания.
* `ctrl.Finish()` — обязательно в конце теста (или можно использовать `t.Cleanup`).
* `mockRepo.EXPECT().FindByID(1).Return(...)` — задаёт ожидание.