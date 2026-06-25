# Пример: Мок с expecter-стилем

Файл-пример: `examples/mock-with-expectations_test.go`

Предполагаем, что мок сгенерирован с `with-expecter: true`.

```go
package example

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/vektra/mockery/v3/mocks"
)

func TestUserService_Expecter(t *testing.T) {
    repo := mocks.NewUserRepository(t)

    repo.EXPECT().FindByID(1).Return(&User{Name: "Alice"}, nil).Once()
    repo.EXPECT().Save(mock.AnythingOfType("*User")).Return(nil).Maybe()

    svc := UserService{repo: repo}
    name, err := svc.GetUserName(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
    // авто-assert через t.Cleanup
}
```
Обратите внимание: `Save` помечен как `Maybe()`, т.к. в тестируемом методе он может не вызываться.