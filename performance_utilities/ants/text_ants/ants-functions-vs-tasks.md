# Функции и задачи: возврат результатов, пул с функцией

## Обычный Submit (без возврата значения)

Используйте `sync.WaitGroup` для синхронизации, результат передавайте через каналы или замыкания.

```go
pool, _ := ants.NewPool(10)
defer pool.Release()

results := make(chan int, 100)
for i := 0; i < 100; i++ {
    i := i
    pool.Submit(func() {
        results <- i * 2
    })
}
// собирать результаты из канала после завершения всех задач
```
## Пул с заданной функцией (PoolWithFunc)
Удобно, когда все задачи обрабатываются одной функцией, а аргументы разные.
```go
pool, _ := ants.NewPoolWithFunc(10, func(payload interface{}) {
    num := payload.(int)
    fmt.Println(num * num)
})
defer pool.Release()

for i := 0; i < 100; i++ {
    pool.Invoke(i)
}
pool.Wait() // дожидается завершения всех Invoke
```
## Возврат результата в PoolWithFunc
Результат можно отправить в канал, переданный через замыкание, или использовать `Invoke` с аргументом-структурой, содержащей возвратный канал.
```go
type task struct {
    n    int
    resp chan int
}
pool, _ := ants.NewPoolWithFunc(10, func(i interface{}) {
    t := i.(task)
    t.resp <- t.n * t.n
})
for i := 0; i < 100; i++ {
    ch := make(chan int, 1)
    pool.Invoke(task{n: i, resp: ch})
    go func() { fmt.Println(<-ch) }()
}
pool.Wait()
```
## Контекст и тайм-ауты
Стандартный пул не поддерживает контекст напрямую. Таймауты можно добавить через select при отправке результата или обернуть задачу в функцию с `context.WithTimeout`.