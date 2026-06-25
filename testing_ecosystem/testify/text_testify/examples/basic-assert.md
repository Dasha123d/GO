# Пример: Базовое использование assert/require

Файл: `examples/basic-assert_test.go`

```go
package example_test

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func TestDivide(t *testing.T) {
    result, err := Divide(10, 2)
    require.NoError(t, err)
    assert.Equal(t, 5.0, result, "10/2 должно быть 5")

    _, err = Divide(1, 0)
    assert.Error(t, err)
}
```