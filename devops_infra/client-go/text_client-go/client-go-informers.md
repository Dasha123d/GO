# Informers: эффективное кеширование и реакция на изменения

## Что такое Informer

Informer подписывается на изменения объектов в Kubernetes и поддерживает локальный кеш, уменьшая нагрузку на API‑сервер.

## Создание SharedInformerFactory

```go
factory := informers.NewSharedInformerFactory(clientset, 10*time.Minute)
podInformer := factory.Core().V1().Pods().Informer()
```
## Регистрация обработчиков
```go
podInformer.AddEventHandler(cache.ResourceEventHandlerFuncs{
    AddFunc:    func(obj interface{}) { fmt.Println("Pod added") },
    UpdateFunc: func(oldObj, newObj interface{}) { fmt.Println("Pod updated") },
    DeleteFunc: func(obj interface{}) { fmt.Println("Pod deleted") },
})
```

## Запуск и использование кеша
```go
stopCh := make(chan struct{})
defer close(stopCh)
factory.Start(stopCh)
// Дождаться синхронизации кеша
if !cache.WaitForCacheSync(stopCh, podInformer.HasSynced) {
    panic("cache sync failed")
}

// Получить все Pod'ы из кеша (без запроса к API)
pods, err := factory.Core().V1().Pods().Lister().List(labels.Everything())
```

## Фильтрация по меткам в Informer
```go
factory := informers.NewSharedInformerFactoryWithOptions(
    clientset, 10*time.Minute,
    informers.WithNamespace("default"),
    informers.WithTweakListOptions(func(opts *metav1.ListOptions) {
        opts.LabelSelector = "app=myapp"
    }),
)
```

## Индексы для быстрого поиска
Можно добавлять кастомные индексы в кеш (например, по имени пода).