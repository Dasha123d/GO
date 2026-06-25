# Пример: Мок с testify
```go
package example_test

import (
    "testing"
    "github.com/stretchr/testify/mock"
    "github.com/stretchr/testify/assert"
)

type Greeter interface {
    Greet(name string) string
}

type MockGreeter struct {
    mock.Mock
}

func (m *MockGreeter) Greet(name string) string {
    args := m.Called(name)
    return args.String(0)
}

func TestGreeting(t *testing.T) {
    m := new(MockGreeter)
    m.On("Greet", "World").Return("Hello, World!")

    result := m.Greet("World")
    assert.Equal(t, "Hello, World!", result)
    m.AssertExpectations(t)
}
```