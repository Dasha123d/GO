# Пример: Проверка порядка вызовов

Файл-пример: `examples/mock-testify-example_test.go`

```go
package example

import (
    "testing"
    "github.com/stretchr/testify/mock"
)

func TestOrderProcessing(t *testing.T) {
    repo := mocks.NewOrderRepository(t)
    // Ожидаем сначала BeginTx, потом Save, потом Commit
    repo.EXPECT().BeginTx().Return(nil).Once()
    repo.EXPECT().Save(mock.AnythingOfType("*Order")).Return(nil).Once().After("BeginTx")
    repo.EXPECT().Commit().Return(nil).Once().After("Save")

    processor := OrderProcessor{repo: repo}
    err := processor.Process(&Order{})
    if err != nil {
        t.Fatal(err)
    }
    // проверка автоматическая
}
```