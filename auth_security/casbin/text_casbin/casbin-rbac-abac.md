# RBAC и ABAC: роли, иерархия и атрибуты

## RBAC (ролевой доступ)

Базовая модель:
```ini
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[role_definition]
g = _, _

[matchers]
m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act
```
### Политика:
```csv
p, admin, /admin, read
p, editor, /posts, write
g, alice, admin
g, bob, editor
```
## Иерархия ролей
Добавляем роль `super_admin`, которая наследует `admin`:
```csv
g, super_admin, admin
g, alice, super_admin
```
Рекурсивное раскрытие ролей — Casbin делает автоматически.

## RBAC с доменами
```ini
[role_definition]
g = _, _, _   # user, role, domain
```

## ABAC (атрибутный доступ)
Можно использовать атрибуты запроса прямо в matcher:
```ini
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[matchers]
m = r.sub == p.sub && r.obj == p.obj && r.act == p.act && r.sub.Age > 18
```
Тогда при вызове передаём структуру:
```go
type User struct {
    Name string
    Age  int
}
alice := User{Name: "alice", Age: 20}
ok, _ := e.Enforce(alice, "data1", "read")
```
## ABAC с eval()
Можно встраивать вычисления в политику через функцию `eval()` (доступна в некоторых адаптерах, или через пользовательские функции).
```go
e.AddFunction("isAdult", func(args ...interface{}) (interface{}, error) {
    age := args[0].(int)
    return age >= 18, nil
})
```
и использовать в модели: `isAdult(r.sub.Age)`.