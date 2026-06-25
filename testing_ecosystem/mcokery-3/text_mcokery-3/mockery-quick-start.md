# Быстрый старт: установка и первый мок

## Установка

```bash
go install github.com/vektra/mockery/v3@latest
```
Убедитесь, что $GOPATH/bin в вашем PATH.

## Пишем интерфейс
service/user_service.go:
```go
package service

type UserRepository interface {
    FindByID(id int) (*User, error)
    Save(user *User) error
}
```
## Генерируем мок
В корне проекта (рядом с go.mod) выполните:
```bash
mockery
```
По умолчанию mockery ищет интерфейсы в текущем пакете и генерирует моки в папку `mocks/`.

После генерации получится `mocks/UserRepository.go`:
```go
package mocks

import "github.com/stretchr/testify/mock"
type UserRepository struct {
    mock.Mock
}
func (_m *UserRepository) FindByID(id int) (*User, error) {
    ret := _m.Called(id)
    ...
}
```
## Используем мок в тесте
```go
func TestSomething(t *testing.T) {
    mockRepo := new(mocks.UserRepository)
    mockRepo.On("FindByID", 1).Return(&User{Name: "Alice"}, nil)

    svc := NewUserService(mockRepo)
    name, err := svc.GetUserName(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
    mockRepo.AssertExpectations(t)
}
```
Всё! Теперь вы можете тестировать компоненты, зависящие от интерфейсов, без реальной реализации.