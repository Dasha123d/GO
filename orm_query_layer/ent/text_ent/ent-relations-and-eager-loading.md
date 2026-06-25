# Связи и Eager Loading

## Определение edge

```go
// В user.go
func (User) Edges() []ent.Edge {
    return []ent.Edge{
        edge.To("pets", Pet.Type),
    }
}
// В pet.go
func (Pet) Edges() []ent.Edge {
    return []ent.Edge{
        edge.From("owner", User.Type).Ref("pets").Unique(),
    }
}
```
## Создание со связью
```go
u, _ := client.User.Create().SetName("Alice").Save(ctx)
client.Pet.Create().SetName("Rex").SetOwner(u).Exec(ctx)
```

## Eager Loading (предзагрузка)
```go
users, err := client.User.Query().WithPets().All(ctx)
for _, u := range users {
    for _, p := range u.Edges.Pets {
        fmt.Println(p.Name)
    }
}
```

## Фильтрация по связанным объектам
```go
users, err := client.User.Query().
    Where(user.HasPetsWith(pet.NameEQ("Rex"))).
    All(ctx)
```

## Nested Eager Loading
```go
users, err := client.User.Query().
    WithPets(func(q *ent.PetQuery) {
        q.WithVeterinary()
    }).
    All(ctx)
```

## Запрос по edge напрямую
```go
pets, err := u.QueryPets().Where(pet.AgeGT(2)).All(ctx)
```