# Лучшие практики client-go

## 1. Используйте Informers вместо прямых вызовов API

Для контроллеров Informers дают кеш, снижая нагрузку и задержки.

## 2. Настраивайте QPS и Burst

По умолчанию QPS=5, Burst=10. Для production увеличьте до 50/100.

## 3. Используйте контекст с таймаутом

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()
pods, err := clientset.CoreV1().Pods("").List(ctx, metav1.ListOptions{})
```

## 4. При обновлении объектов всегда перечитывайте их
Используйте `Get` перед `Update`, чтобы избежать конфликтов версий.

## 5. Используйте `RetryOnConflict`
Для обновлений оберните в `retry.RetryOnConflict(retry.DefaultRetry, func() error { ... })`.

## 6. Не храните clientset глобально без необходимости
Передавайте как зависимость.

## 7. Логируйте события лидерства
Потеря лидерства или ошибки обновления Lease должны быть видны.

## 8. Очищайте ресурсы
Закрывайте каналы (`stopCh`), завершайте горутины.

## 9. Тестируйте с fake‑клиентом
```go
import "k8s.io/client-go/kubernetes/fake"
fakeClientset := fake.NewSimpleClientset()
```

## 10. Следите за версиями API
Используйте правильные `GroupVersionResource` и обновляйте зависимости.