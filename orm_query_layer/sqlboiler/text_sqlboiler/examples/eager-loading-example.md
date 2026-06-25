# Пример: Eager Loading

Файл: `examples/eager-loading-example.go`

```go
func main() {
    db, _ := sql.Open("postgres", "...")
    ctx := context.Background()

    users, _ := models.Users(
        qm.Load("Orders"),
    ).All(ctx, db)

    for _, u := range users {
        fmt.Println(u.Name, len(u.R.Orders))
    }
}
```