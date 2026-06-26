# Конфигурация подключения

## In‑cluster конфигурация (для подов)

```go
import "k8s.io/client-go/rest"

config, err := rest.InClusterConfig()
```
Используется сервис‑аккаунт Pod'а.

## Kubeconfig из флагов
```go
masterURL, kubeconfig := "", ""
flag.StringVar(&kubeconfig, "kubeconfig", clientcmd.RecommendedHomeFile, "path to kubeconfig")
flag.Parse()
config, err := clientcmd.BuildConfigFromFlags(masterURL, kubeconfig)
```
## Несколько кластеров
`clientcmd.NewNonInteractiveDeferredLoadingClientConfig` объединяет несколько источников.

## Настройка таймаутов и QPS
```go
config.QPS = 50
config.Burst = 100
config.Timeout = 30 * time.Second
```
## Аутентификация через Bearer Token
```go
config.BearerToken = "my-token"
```
## Обёртка для повторных попыток
client‑go по умолчанию не ретраит запросы; используйте `k8s.io/client-go/util/retry` или собственный `RetryOnConflict` для обновлений.