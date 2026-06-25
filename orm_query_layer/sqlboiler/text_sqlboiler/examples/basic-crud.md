# Пример: Базовый CRUD

Файл: `examples/basic-crud.go`

```go
func main() {
    db, _ := sql.Open("postgres", "host=localhost ...")
    boil.SetDB(db)
    ctx := context.Background()

    user := &models.User{Name: "Alice", Age: 30}
    user.Insert(ctx, db, boil.Infer())

    found, _ := models.FindUser(ctx, db, user.ID)

    user.Name = "Updated"
    user.Update(ctx, db, boil.Infer())

    user.Delete(ctx, db)
}
```