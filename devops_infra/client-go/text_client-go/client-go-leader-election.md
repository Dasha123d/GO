# Leader Election: выбор ведущего экземпляра

## Зачем нужно

Для высокодоступных контроллеров, чтобы только один экземпляр выполнял работу.

## Простая реализация

```go
import (
    "k8s.io/client-go/tools/leaderelection"
    "k8s.io/client-go/tools/leaderelection/resourcelock"
)

lock := &resourcelock.LeaseLock{
    LeaseMeta: metav1.ObjectMeta{
        Name:      "my-controller",
        Namespace: "default",
    },
    Client: clientset.CoordinationV1(),
    LockConfig: resourcelock.ResourceLockConfig{
        Identity: "pod-1",
    },
}

leaderelection.RunOrDie(context.Background(), leaderelection.LeaderElectionConfig{
    Lock:            lock,
    LeaseDuration:   15 * time.Second,
    RenewDeadline:   10 * time.Second,
    RetryPeriod:     2 * time.Second,
    Callbacks: leaderelection.LeaderCallbacks{
        OnStartedLeading: func(ctx context.Context) {
            // запуск контроллера
            runController(ctx)
        },
        OnStoppedLeading: func() {
            log.Println("lost leadership")
        },
    },
})
```
В кластере создаётся объект Lease, который периодически обновляется лидером.

## Замечание
Обязательно обрабатывайте сигнал `ctx.Done()` внутри `OnStartedLeading`.