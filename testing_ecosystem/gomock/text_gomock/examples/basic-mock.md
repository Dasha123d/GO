# Пример: Простой мок

Файл: `examples/basic-mock_test.go`

```go
package example_test

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "go.uber.org/mock/gomock"
    "myapp/mocks"
)

func TestGetUser(t *testing.T) {
    ctrl := gomock.NewController(t)
    defer ctrl.Finish()

    mockRepo := mocks.NewMockRepository(ctrl)
    mockRepo.EXPECT().
        FindByID(1).
        Return(&User{Name: "Alice"}, nil)

    svc := NewUserService(mockRepo)
    name, err := svc.GetUserName(1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
}
```