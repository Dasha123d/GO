# Пример: Ожидание количества вызовов

Файл: `examples/mock-with-times_test.go`

```go
package example_test

import (
    "testing"
    "go.uber.org/mock/gomock"
)

func TestBatchSave(t *testing.T) {
    ctrl := gomock.NewController(t)
    defer ctrl.Finish()

    mockRepo := mocks.NewMockRepository(ctrl)
    mockRepo.EXPECT().Save(gomock.Any()).Times(3)

    svc := NewBatchService(mockRepo)
    svc.SaveMultiple(3) // должно вызвать Save ровно 3 раза
}
```