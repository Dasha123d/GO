# Построитель запросов: fluent API

## SELECT

```go
users, err := client.User.Query().Where(user.AgeGT(18)).All(ctx)
```
Фильтры: `EQ`, `NEQ`, `GT`, `GTE`, `LT`, `LTE`, `Contains`, `HasPrefix`, `In`.

## Пагинация
```go
users, err := client.User.Query().
    Limit(10).
    Offset(20).
    Order(ent.Desc(user.FieldCreatedAt)).
    All(ctx)
```

## Выборка одного
```go
u, err := client.User.Query().Where(user.NameEQ("Alice")).First(ctx)
if ent.IsNotFound(err) { ... }
```

## Агрегация
```go
count, _ := client.User.Query().Count(ctx)
maxAge, _ := client.User.Query().Aggregate(ent.Max(user.FieldAge)).Int(ctx)
```

## INSERT
```go
newUser, err := client.User.Create().
    SetName("Bob").
    SetAge(25).
    Save(ctx)
```

## UPDATE
```go
err := client.User.Update().
    Where(user.AgeLT(18)).
    SetActive(false).
    Exec(ctx)
```

## DELETE
```go
count, err := client.User.Delete().
    Where(user.NameContains("test")).
    Exec(ctx)
```

## Batch (несколько записей)
```go
bulk := make([]*ent.UserCreate, len(names))
for i, name := range names {
    bulk[i] = client.User.Create().SetName(name)
}
users, err := client.User.CreateBulk(bulk...).Save(ctx)
```