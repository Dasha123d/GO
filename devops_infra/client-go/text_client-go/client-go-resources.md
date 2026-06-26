# Работа с ресурсами (CRUD)

## Clientset и пространства имён

```go
podsClient := clientset.CoreV1().Pods("my-namespace")
deploymentsClient := clientset.AppsV1().Deployments("my-namespace")
```
## Получение одного объекта
```go
pod, err := podsClient.Get(context.Background(), "my-pod", metav1.GetOptions{})
```
## Создание
```go
newPod := &corev1.Pod{...}
createdPod, err := podsClient.Create(context.Background(), newPod, metav1.CreateOptions{})
```
## Обновление
```go
pod.Spec.Containers[0].Image = "nginx:1.21"
updatedPod, err := podsClient.Update(context.Background(), pod, metav1.UpdateOptions{})
```

## Удаление
```go
err := podsClient.Delete(context.Background(), "my-pod", metav1.DeleteOptions{})
```

## Список с фильтрацией (метки, поля)
```go
pods, err := podsClient.List(context.Background(), metav1.ListOptions{
    LabelSelector: "app=myapp",
    FieldSelector: "status.phase=Running",
})
```

## Watch (наблюдение за изменениями)
```go
watcher, err := podsClient.Watch(context.Background(), metav1.ListOptions{})
if err != nil {
    panic(err)
}
for event := range watcher.ResultChan() {
    pod := event.Object.(*corev1.Pod)
    fmt.Println(event.Type, pod.Name)
}
```

## Работа с Custom Resources
Для CRD используйте `dynamic client` или генерируйте типизированный клиент через `code-generator`.