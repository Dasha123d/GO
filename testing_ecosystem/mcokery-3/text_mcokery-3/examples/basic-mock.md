# Пример: Простейший мок с традиционным testify

Файл-пример: `examples/basic-mock_test.go`

```go
package example

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
)

// Допустим, есть сгенерированный мок
type MockUserRepo struct {
    mock.Mock
}

func (m *MockUserRepo) FindByID(id int) (*User, error) {
    args := m.Called(id)
    return args.Get(0).(*User), args.Error(1)
}

func TestGetUserName(t *testing.T) {
    repo := new(MockUserRepo)
    repo.On("FindByID", 1).Return(&User{Name: "Alice"}, nil)

    svc := UserService{repo: repo}
    name, err := svc.GetUserName(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
    repo.AssertExpectations(t)
}
```
Этот стиль подходит для ручного использования, но лучше применять expecter (см. следующий пример).