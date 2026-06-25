# Пример: Интеграционный тест с моками

Файл: `examples/mock-integration-test_test.go`

```go
package example_test

import (
    "testing"
    "go.uber.org/mock/gomock"
    "github.com/stretchr/testify/require"
)

func TestOrderProcessing(t *testing.T) {
    ctrl := gomock.NewController(t)
    defer ctrl.Finish()

    orderRepo := mocks.NewMockOrderRepo(ctrl)
    payment := mocks.NewMockPaymentService(ctrl)
    notifier := mocks.NewMockNotifier(ctrl)

    // Ожидаем цепочку вызовов
    gomock.InOrder(
        orderRepo.EXPECT().Get(123).Return(&Order{Total: 100}, nil),
        payment.EXPECT().Charge(100).Return(nil),
        notifier.EXPECT().SendEmail(gomock.Any()),
    )

    processor := NewOrderProcessor(orderRepo, payment, notifier)
    err := processor.Process(123)
    require.NoError(t, err)
}
```