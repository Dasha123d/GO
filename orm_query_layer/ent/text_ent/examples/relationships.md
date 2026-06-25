# Пример: Связи User -> Pets

Файл: `examples/relationships.go`

```go
func main() {
    client, _ := ent.Open("sqlite3", "file:ent?mode=memory&cache=shared&_fk=1")
    defer client.Close()
    client.Schema.Create(ctx)

    u, _ := client.User.Create().SetName("Alice").Save(ctx)
    p, _ := client.Pet.Create().SetName("Rex").SetOwner(u).Save(ctx)

    // Eager
    users, _ := client.User.Query().WithPets().All(ctx)
    for _, u := range users {
        for _, p := range u.Edges.Pets {
            fmt.Println(u.Name, p.Name)
        }
    }
}
```