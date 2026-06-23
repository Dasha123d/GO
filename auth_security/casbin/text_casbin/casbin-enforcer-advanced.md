# Enforcer: домены, фильтрация и пакетные проверки

## Инициализация

```go
e, _ := casbin.NewEnforcer("model.conf", "policy.csv")
// или из адаптера
e, _ := casbin.NewEnforcer("model.conf", adapter)
```
## Домены (multi-tenancy)
Если модель содержит домен:
```ini
[request_definition]
r = sub, dom, obj, act

[policy_definition]
p = sub, dom, obj, act
```
Enforcer работает с доменами автоматически. При вызове:
```go
ok, _ := e.Enforce("alice", "domain1", "data1", "read")
```
## Фильтрация политик
При использовании адаптера (БД) можно загружать только политики, относящиеся к субъекту или объекту, чтобы не загружать всю таблицу в память.
```go
// Загрузить только правила для alice
e.LoadFilteredPolicy(&casbin.Filter{
    P: [][]string{ {"alice"} },
    G: [][]string{ {"alice"} },
})
```
## Пакетная проверка (Batch Enforce)
```go
requests := [][]interface{}{
    {"alice", "data1", "read"},
    {"bob", "data2", "write"},
}
results, _ := e.BatchEnforce(requests)
for _, r := range results {
    fmt.Println(r)
}
```
## Управление политикой во время выполнения
```go
e.AddPolicy("alice", "data3", "read")
e.RemovePolicy("bob", "data2", "write")
e.AddGroupingPolicy("alice", "editor")
e.RemoveGroupingPolicy("alice", "editor")

// Сохранить изменения (если адаптер поддерживает)
e.SavePolicy()
```
## Транзакции с AutoSave
```go
e.EnableAutoSave(true)
e.AddPolicy(...) // сразу пишет в адаптер
```