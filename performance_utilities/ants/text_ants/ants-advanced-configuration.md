# Продвинутая конфигурация пула

## Опции NewPool

```go
pool, err := ants.NewPool(
    1000,
    ants.WithPreAlloc(true),                     // предварительно выделить горутины
    ants.WithNonblocking(true),                  // не блокировать при переполнении
    ants.WithMaxBlockingTasks(500),              // максимальная очередь ожидания
    ants.WithPanicHandler(func(i interface{}) {   // обработка паник
        log.Printf("паника в задаче: %v", i)
    }),
    ants.WithExpiryDuration(10*time.Second),     // время жизни неактивной горутины
    ants.WithLogger(log.New(os.Stdout, "[ants]", log.LstdFlags)),
)
```
* PreAlloc – все горутины создаются сразу при инициализации, уменьшает задержки.
* Nonblocking – если пул и очередь заполнены, `Submit` вернёт `ants.ErrPoolOverload` вместо блокировки.
* MaxBlockingTasks – лимит ожидающих задач (при `Nonblocking=false`).
* PanicHandler – функция, вызываемая при панике в задаче.
* ExpiryDuration – горутина, простаивающая дольше этого времени, будет остановлена и пересоздана позже (экономит память).
* Logger – совместимый интерфейс логгера (можно подключить Logrus/Zap через адаптер).

## Тонкая настройка вместимости
По умолчанию размер пула фиксирован. Если нужен динамический пул, используйте `ants.NewPoolWithFunc` или настройте через `Tune(size int)`:
```go
pool.Tune(2000) // изменить размер пула на лету (не уменьшает ниже текущего числа занятых горутин)
```
## Инспекция пула
```go
fmt.Println("Ёмкость:", pool.Cap())          // максимальный размер
fmt.Println("Занято:", pool.Running())       // выполняются сейчас
fmt.Println("Свободно:", pool.Free())        // готовы принять задачу
```
Эти метрики полезны для мониторинга.